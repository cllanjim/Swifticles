//
//  core_social.h
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef FRAMEWORK_CORE_SOUND
#define FRAMEWORK_CORE_SOUND

#include "FSound.h"

void snd_initialize();

void *LoadSound(char *theFilename, int *theDataSize, int *theDataFormat, int* theSampleRate);

void snd_load(FSound *pSound, const char *pFileName, int pInstanceCount=3);

void snd_play(FSound *pSound);
void snd_play(FSound *pSound, float pVolume=1.0f);
void snd_playPitched(FSound *pSound, float pPitch, float pVolume=1.0f);


void snd_musicPlay(const char *pPath, bool pLoop);
void snd_musicCrossFade(const char *pPath, int pDurationTicks, bool pLoop);
void snd_musicFadeOut(int pDurationTicks);
void snd_musicStop();

bool snd_musicIsPlaying();




#endif
