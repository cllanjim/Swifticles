//
//  core_social.m
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>

#include "Root.h"

#include "openal/al.h"
#include "OpenAL/alc.h"


#include "core_sound.h"
#include "core_os.h"

#include "stdafx.h"

ALCcontext *gAudioContext = 0;
ALCdevice *gAudioDevice = 0;

void snd_initialize()
{
	gAudioDevice = alcOpenDevice(NULL);
    
    if(gAudioDevice)
    {
        
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        OSStatus propertySetError = 0;
        UInt32 allowMixing = true;
        propertySetError = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers,
                                                   sizeof (allowMixing),&allowMixing);
        
        
        gAudioContext = alcCreateContext(gAudioDevice, NULL);
        alcMakeContextCurrent(gAudioContext);
        
        ALfloat ListenerPos[]={0.0, 0.0, 0.0};
        ALfloat ListenerVel[]={0.0, 0.0, 0.0};
        ALfloat ListenerOri[]={0.0, 0.0, 0.0,  0.0, 1.0, 0.0};
        
        alListenerfv(AL_POSITION,ListenerPos);
        alListenerfv(AL_VELOCITY,ListenerVel);
        alListenerfv(AL_ORIENTATION,ListenerOri);
    }
}


void *LoadSound(char *theFilename, int *theDataSize, int *theDataFormat, int* theSampleRate)
{
	NSString *aPath=[NSString stringWithUTF8String: theFilename];
	NSURL *aUrl=[NSURL fileURLWithPath:aPath];
    
	CFURLRef						aFileURL=(__bridge CFURLRef)aUrl;
	OSStatus						aResult = noErr;
	SInt64							aFileLengthInFrames = 0;
	AudioStreamBasicDescription		aFileFormat;
	UInt32							aPropertySize = sizeof(aFileFormat);
	ExtAudioFileRef					aExtRef = NULL;
	unsigned int*					aData = NULL;
	AudioStreamBasicDescription		aOutputFormat;
	
	for(;;)
	{
		aResult = ExtAudioFileOpenURL(aFileURL, &aExtRef);
		if(aResult)
        {
            //printf("AudioToBits: ExtAudioFileOpenURL FAILED, Error = %ld\n", aResult);
            //	break;
		}
		
		aResult=ExtAudioFileGetProperty(aExtRef, kExtAudioFileProperty_FileDataFormat, &aPropertySize, &aFileFormat);
		
        if(aResult)
        {
            break;
        }
		if (aFileFormat.mChannelsPerFrame>2)
        {
            //printf("MyGetOpenALAudioData - Unsupported Format, channel count is greater than stereo\n");
            break;
        }
		
		
		aOutputFormat.mSampleRate=aFileFormat.mSampleRate;
		aOutputFormat.mChannelsPerFrame=aFileFormat.mChannelsPerFrame;
		
		
		aOutputFormat.mFormatID=kAudioFormatLinearPCM;
		aOutputFormat.mBytesPerPacket=2*aOutputFormat.mChannelsPerFrame;
		aOutputFormat.mFramesPerPacket=1;
		aOutputFormat.mBytesPerFrame=2*aOutputFormat.mChannelsPerFrame;
		aOutputFormat.mBitsPerChannel=16;
		aOutputFormat.mFormatFlags=kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
		
		aResult=ExtAudioFileSetProperty(aExtRef, kExtAudioFileProperty_ClientDataFormat,sizeof(aOutputFormat),&aOutputFormat);
		if(aResult)
		{
			//printf("AudioToBits: ExtAudioFileSetProperty(kExtAudioFileProperty_ClientDataFormat) FAILED, Error = %ld\n",aResult);
			break;
		}
		
		aPropertySize=sizeof(aFileLengthInFrames);
		aResult=ExtAudioFileGetProperty(aExtRef, kExtAudioFileProperty_FileLengthFrames, &aPropertySize, &aFileLengthInFrames);
		if(aResult)
		{
			//printf("AudioToBits: ExtAudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = %ld\n",aResult);
			break;
		}
		
		unsigned int aDataSize = aFileLengthInFrames*aOutputFormat.mBytesPerFrame;
        
		aData = (unsigned int*)malloc(aDataSize);
        
		if (aData)
		{
			AudioBufferList		aDataBuffer;
			aDataBuffer.mNumberBuffers = 1;
			aDataBuffer.mBuffers[0].mDataByteSize=aDataSize;
			aDataBuffer.mBuffers[0].mNumberChannels=aOutputFormat.mChannelsPerFrame;
			aDataBuffer.mBuffers[0].mData=aData;
			
			aResult=ExtAudioFileRead(aExtRef, (UInt32*)&aFileLengthInFrames, &aDataBuffer);
			if(aResult==noErr)
			{
				*theDataSize = (int)aDataSize;
				*theDataFormat = aOutputFormat.mChannelsPerFrame;//(aOutputFormat.mChannelsPerFrame>1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
				*theSampleRate = (int)aOutputFormat.mSampleRate;
			}
			else
			{
				free(aData);
				aData=NULL;
				//printf("AudioToBits: ExtAudioFileRead FAILED, Error = %ld\n",aResult); break;
			}
		}
		break;
    }
    
	//Dispose the ExtAudioFileRef, it is no longer needed
    if(aExtRef)ExtAudioFileDispose(aExtRef);
    
	return aData;
}

void snd_load(FSound *pSound, const char *pFileName, int pInstanceCount)
{
    
}

void snd_play(FSound *pSound)
{
    
}

void snd_play(FSound *pSound, float pVolume)
{
    
}

void snd_playPitched(FSound *pSound, float pPitch, float pVolume)
{
    
}

void snd_musicPlay(const char *pPath, bool pLoop)
{
    FString aPath = gDirBundle + pPath;
    [gRoot musicPlay:[NSString stringWithUTF8String:aPath.c()] withLoop:pLoop];
}

void snd_musicCrossFade(const char *pPath, int pDurationTicks, bool pLoop)
{
    FString aPath = gDirBundle + pPath;
    [gRoot musicCrossFadeWithPath:[NSString stringWithUTF8String:aPath.c()] withDurationTicks:pDurationTicks withLoop:pLoop];
}

void snd_musicFadeOut(int pDurationTicks)
{
    [gRoot musicFadeOutWithDurationTicks:pDurationTicks];
}

void snd_musicStop()
{
    [gRoot musicStop];
}

bool snd_musicIsPlaying()
{
    bool aReturn = false;
    
    aReturn = [gRoot musicIsPlaying];
    
    return aReturn;
}
