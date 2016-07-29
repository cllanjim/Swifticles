//
//  FSpriteSequence.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/19/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef __CoreDemo__FSpriteSequence__
#define __CoreDemo__FSpriteSequence__

#include "FString.h"
#include "FSprite.h"
#include "FList.h"


class FSpriteSequence
{
public:
    
    FSpriteSequence();
    virtual ~FSpriteSequence();
    
    void                                Load(const char *pFilePrefix);
    inline void                         Load(char *pFilePrefix){Load((const char*)pFilePrefix);}
    inline void                         Load(FString pFilePrefix){Load((const char*)(pFilePrefix.c()));}
    
    void                                Load(const char *pFilePrefix, int pStartIndex, int pEndIndex);
    
    void                                Load(const char *pFilePrefix, const char *pExtension, int pStartIndex, int pEndIndex, int pLeadingZeroes);
    
    FList                               mList;
    int                                 mCount;
    
    void                                Draw(float pFrame);
    void                                Draw(float pFrame, float pX, float pY);
    void                                DrawScaled(float pFrame, float pX, float pY, float pScale);
    void                                DrawScaled(float pFrame, float pX, float pY, float pScaleX, float pScaleY);
    void                                DrawRotated(float pFrame, float pX, float pY, float pRotation);
    void                                Draw(float pFrame, float pX, float pY, float pRotation, float pScale=1.0f);
    
    FSprite                             *GetSprite(float pFrame);
};

#endif