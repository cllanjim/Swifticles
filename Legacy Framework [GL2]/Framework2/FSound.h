//
//  FFSound.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/17/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef __CoreDemo__FFSound__
#define __CoreDemo__FFSound__

#include "openal/al.h"
#include "OpenAL/alc.h"

#include "FList.h"
#include "FString.h"

class FSoundInstance
{
public:
    
	FSoundInstance(unsigned int pIndex);
	virtual ~FSoundInstance();
	FSoundInstance(const FSoundInstance&);
	FSoundInstance &operator = (const FSoundInstance&);
    
	void                            Play(float pVolume=1.0f);
	void                            Loop(float pVolume=1.0f);
	void                            Stop();
	void                            SetVolume(float pVolume=1.0f);
	bool                            IsPlaying();
	
	void                            SetPitch(float pAdjustment);
	void                            SetPitchManual(float pPitch);
	void                            SetPitch();
	
	int                             GetPosition();
	void                            Pause(bool pState);
	
	void                            Destroy();
    
	unsigned int                    mIndex;
	float                           mVolume;
	
	int                             mPause;
	bool                            mSavedPlaying;
	
	bool                            mIsLooping;
    
	void                            GetSourceProperty(unsigned int pFlag, float *pBuffer);
};

class FSound
{
public:
	FSound(void);
	virtual ~FSound(void);
    
	void                            Load(FString pFilename, int pDuplicates = 8);
    
	void                            Play(float pVolume = 1.0f);
	void                            PlayPitched(float pPitch, float pVolume = 1.0f);
	void                            StopAll();
	void                            Clean();
	
	bool                            IsPlaying();
    
	int                             mInstanceCount;
	unsigned int                    *mFSoundData;
	unsigned int                    *mInstanceID;
	
	float                           *mSourceBuffer;
    
	void                            SetPitch(float pMultiplier);
	
	FList                           mBufferList;
    
};

#endif
