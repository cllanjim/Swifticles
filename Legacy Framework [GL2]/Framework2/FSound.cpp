/*
 *  FSound.cpp
 *  Drillheads
 *
 *  Created by Nick Raptis on 11/29/09.
 *  Copyright 2009 Raptisoft LLC. All rights reserved.
 *
 */

#include "FSound.h"
#include "stdafx.h"
#include "core_sound.h"

FSoundInstance::FSoundInstance(ALuint pIndex)
{
	mIndex=pIndex;
	//gAudio.mFSoundInstanceList+=this;
    
	mVolume=1.0f;
	mSavedPlaying=false;
	mIsLooping=false;
	mPause=0;
}

FSoundInstance::~FSoundInstance()
{
	//if (!gAudio.mDestroyed) gAudio.mFSoundInstanceList-=this;
}

void FSoundInstance::SetPitch()
{
	alSourcef(mIndex,AL_PITCH,1.0f);
}

void FSoundInstance::SetPitch(float pMultiplier)
{
	alSourcef(mIndex,AL_PITCH,pMultiplier);
}

void FSoundInstance::SetPitchManual(float pPitch)
{
	alSourcef(mIndex,AL_PITCH,pPitch);
}


void FSoundInstance::Play(float pVolume)
{
	SetVolume(pVolume);
	alSourcei(mIndex,AL_LOOPING,false);
	alSourcePlay(mIndex);
	mIsLooping=false;
    
    /*
	if(!gApp->mFSoundOn)return;
	SetVolume(pVolume*gApp->mFSoundVolume);
	alSourcei(mIndex,AL_LOOPING,false);
	alSourcePlay(mIndex);
	mIsLooping=false;
    */
}

void FSoundInstance::Pause(bool pState)
{
	if(pState)mPause++;
    if(mPause > 0)mPause--;
    else mPause = 0;
    
	if(mPause)
	{
		if(mPause==1 && pState)
		{
			mSavedPlaying=IsPlaying();
			alSourcePause(mIndex);
		}
	}
	else
	{
		if(mSavedPlaying)
		{
			alSourcePlay(mIndex);
			mSavedPlaying=false;
		}
	}
}


void FSoundInstance::Loop(float pVolume)
{
	SetVolume(pVolume);
	alSourcei(mIndex,AL_LOOPING,true);
	alSourcePlay(mIndex);
	mIsLooping=true;
}

void FSoundInstance::SetVolume(float pVolume)
{
	mVolume=pVolume;
	alSourcef(mIndex, AL_GAIN,mVolume*
			  1
			  //gAudio.mFSoundVolume
              );
}

void FSoundInstance::Stop()
{
	alSourceStop(mIndex);
}

bool FSoundInstance::IsPlaying()
{
	ALint aResult;
	alGetSourcei(mIndex,AL_SOURCE_STATE,&aResult) ;
	return (aResult==AL_PLAYING);
}

int FSoundInstance::GetPosition()
{
	return 0;
}

void FSoundInstance::Destroy()
{
	
}

void FSoundInstance::GetSourceProperty(unsigned int pFlag, float *pBuffer)
{
	alGetSourcef(mIndex, pFlag, pBuffer);
}

FSound::FSound(void)
{
	//mBufferListEnum=mBufferList.GetEnumerator(PtrToUlong(__FILE__),__COUNTER__);
	mFSoundData=NULL;
	mInstanceCount=1;
	
	
	mSourceBuffer=new float[16];
}

FSound::~FSound(void)
{
	delete[]mSourceBuffer;
	mSourceBuffer=0;
	
	Clean();
}

void FSound::Clean()
{
	FreeList(FSoundInstance,mBufferList);
	mBufferList.Clear();
	if(mFSoundData)
	{
		alDeleteBuffers(mInstanceCount,mFSoundData);
		delete[]mFSoundData;
		delete[]mInstanceID;
	}
	
}

void FSound::Play(float pVolume)
{
	PlayPitched(1,pVolume);
}

bool FSound::IsPlaying()
{
	EnumList(FSoundInstance,aInstance,mBufferList)
	{
        if(aInstance->IsPlaying())
		{
            return true;
        }
    }
    return false;
    
}

void FSound::PlayPitched(float pPitch, float pVolume)
{
	FSoundInstance *aFSoundInstance=0;
	EnumList(FSoundInstance,aInstance,mBufferList)
	{
		if(!aInstance->IsPlaying())
		{
			aFSoundInstance=aInstance;
			break;
		}
	}
    
	if(aFSoundInstance)
	{
		aFSoundInstance->SetPitch(pPitch);
		aFSoundInstance->Play(pVolume);
	}
}

/*
void FSound::GetSourceProperty(unsigned int pFlag)
{
	
	EnumList(FSoundInstance,aInstance,mBufferList)
	{
		if(aInstance->IsPlaying())
		{
			aInstance->GetSourceProperty(pFlag, mSourceBuffer);
			break;
		}
	}
}



float FSound::GetGain()
{
	if(mFSoundData)
	{
		GetSourceProperty(AL_GAIN);
		return mFSoundData[0];
	}
	return 0;
	
}


float FSound::GetByteOffset()
{
	if(mFSoundData)
	{
		GetSourceProperty(AL_BYTE_OFFSET);
		return mFSoundData[0];
	}
	return 0;
}

*/

void FSound::StopAll()
{
	EnumList(FSoundInstance,aFSoundInstance,mBufferList)aFSoundInstance->Stop();
}

void FSound::SetPitch(float pAdjustment)
{
	EnumList(FSoundInstance,aFSoundInstance,mBufferList)aFSoundInstance->SetPitch(pAdjustment);
}


void FSound::Load(FString pFilename, int pDuplicates)
{
	//pFilename=ClassifyFile(pFilename.c());
	
    FString aFileNameBase = FString(gDirBundle + pFilename);
    FString aFileName;
                                    
    
                                    
    aFileName = FString(aFileNameBase) + FString(".caf");
    
	int aLoadDataSize;
	int aLoadDataFormat;
	int aLoadSampleRate;
	
	ALsizei aDataSize;
	ALenum aDataFormat;
	ALsizei aSampleRate;
    
	void *aData = LoadSound((aFileName).c(),&aLoadDataSize,&aLoadDataFormat,&aLoadSampleRate);
    
    
    if(aData == 0)
    {
        aFileName = FString(aFileNameBase) + FString(".aif");
        aData = LoadSound((aFileName).c(),&aLoadDataSize,&aLoadDataFormat,&aLoadSampleRate);
    }
    
    if(aData == 0)
    {
        aFileName = FString(aFileNameBase) + FString(".wav");
        aData = LoadSound((aFileName).c(),&aLoadDataSize,&aLoadDataFormat,&aLoadSampleRate);
    }
    
    if(aData == 0)
    {
        aFileName = FString(aFileNameBase) + FString(".mp3");
        aData = LoadSound((aFileName).c(),&aLoadDataSize,&aLoadDataFormat,&aLoadSampleRate);
    }
    
	
    if(aData)
	{
		aDataSize=aLoadDataSize;
		aDataFormat=(aLoadDataFormat>1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
		aSampleRate=aLoadSampleRate;
		
		mFSoundData=new ALuint(aDataSize);
		alGenBuffers(1,mFSoundData);
		if(alGetError()!=AL_NO_ERROR)
		{
			printf("Could not load CAF (alGenBuffers Failed): %s\n",pFilename.c());
			return;
		}
		
		alBufferData(mFSoundData[0],aDataFormat,aData,aDataSize,aSampleRate);
		if(alGetError()!=AL_NO_ERROR)
		{
			printf("Could not load CAF (alBufferData Failed): %s\n",pFilename.c());
			return;
		}
        
		mInstanceID = new ALuint[pDuplicates];
		alGenSources(pDuplicates, mInstanceID);
        
		if(alGetError() != AL_NO_ERROR)
		{
			printf("Could not load CAF (alGenSources Failed): %s\n",pFilename.c());
			return;
		}
		
		for(int aCount=0;aCount<pDuplicates;aCount++)
		{
			alSourcei(mInstanceID[aCount],AL_BUFFER,mFSoundData[0]);
            
			FSoundInstance *aFSoundInstance=new FSoundInstance(mInstanceID[aCount]);
			mBufferList+=aFSoundInstance;
		}
		
		free(aData);
	}
    
	return;
}

