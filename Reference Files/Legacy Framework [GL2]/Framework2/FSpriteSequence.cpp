//
//  FSpriteSequence.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/19/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FSpriteSequence.h"

FSpriteSequence::FSpriteSequence()
{
    mCount = 0;
}

FSpriteSequence::~FSpriteSequence()
{
    FreeList(FSprite, mList);
    mCount = 0;
}

void FSpriteSequence::Load(const char *pFilePrefix)
{
    bool aSuccess = false;
    
    FString aFileBase = pFilePrefix;
    FString aNumberString;
    FString aPath;
    FSprite *aSprite = new FSprite();
    
    int aLoops = 0;
    
    for(int aStartIndex=0;(aStartIndex < 5) && (aSuccess == false);aStartIndex++)
    {
        aLoops++;
        
        for(int aLeadingZeroes=1;(aLeadingZeroes < 7) && (aSuccess == false) ;aLeadingZeroes++)
        {
            aLoops++;
            
            aNumberString = FString(aStartIndex);
            if(aNumberString.mLength < aLeadingZeroes)
            {
                FString aZeroString;
                aZeroString.Write('0', (aLeadingZeroes - aNumberString.mLength), 0);
                aNumberString = FString(aZeroString + aNumberString);
            }
            
            aPath = FString(aFileBase + aNumberString);
            
            aSprite->Load(aPath);
            
            if(aSprite->DidLoad())
            {
                mList += aSprite;
                aSprite = new FSprite();
                
                int aIndex = aStartIndex + 1;
                
                while(true)
                {
                    aLoops++;
                    
                    aNumberString = FString(aIndex);
                    if(aNumberString.mLength < aLeadingZeroes)
                    {
                        FString aZeroString;
                        aZeroString.Write('0', (aLeadingZeroes - aNumberString.mLength), 0);
                        aNumberString = FString(aZeroString + aNumberString);
                    }
                    
                    aPath = FString(aFileBase + aNumberString);
                    
                    aSprite->Load(aPath);
                    
                    if(aSprite->DidLoad())
                    {
                        mList += aSprite;
                        aSprite = new FSprite();
                        aIndex++;
                    }
                    else
                    {
                        break;
                    }
                }
                aSuccess = true;
            }
        }
    }
    
    mCount = mList.mCount;
    
    if(mList.mCount > 0)
    {
        //printf("[%s] Loaded Success [%d Sprites] [%d Loops]\n", pFilePrefix, mList.mCount, aLoops);
    }
    else
    {
        printf("[%s] Loaded Failure [%d Loops]\n", pFilePrefix, aLoops);
    }
    
    delete aSprite;
}

void FSpriteSequence::Load(const char *pFilePrefix, int pStartIndex, int pEndIndex)
{
    
}

void FSpriteSequence::Load(const char *pFilePrefix, const char *pExtension, int pStartIndex, int pEndIndex, int pLeadingZeroes)
{
    
}


void FSpriteSequence::Draw(float pFrame)
{
    FSprite *aSprite = GetSprite(pFrame);
    if(aSprite)aSprite->Draw();
}

void FSpriteSequence::Draw(float pFrame, float pX, float pY)
{
    FSprite *aSprite = GetSprite(pFrame);
    if(aSprite)aSprite->Draw(pX, pY);
}

void FSpriteSequence::DrawScaled(float pFrame, float pX, float pY, float pScale)
{
    FSprite *aSprite = GetSprite(pFrame);
    if(aSprite)aSprite->DrawScaled(pX, pY, pScale);
}


void FSpriteSequence::DrawScaled(float pFrame, float pX, float pY, float pScaleX, float pScaleY)
{
    FSprite *aSprite = GetSprite(pFrame);
    if(aSprite)aSprite->DrawScaled(pX, pY, pScaleX, pScaleY);
}

void FSpriteSequence::DrawRotated(float pFrame, float pX, float pY, float pRotation)
{
    FSprite *aSprite = GetSprite(pFrame);
    if(aSprite)aSprite->DrawRotated(pX, pY, pRotation);
}

void FSpriteSequence::Draw(float pFrame, float pX, float pY, float pRotation, float pScale)
{
    FSprite *aSprite = GetSprite(pFrame);
    if(aSprite)aSprite->Draw(pX, pY, pRotation, pScale);
}

FSprite *FSpriteSequence::GetSprite(float pFrame)
{
    FSprite *aReturn = 0;
    
    int aIndex = (int)(pFrame + 0.01f);
    
    if(mList.mCount > 0)
    {
        if(aIndex < 0)aIndex = 0;
        if(aIndex >= mList.mCount)aIndex = (mList.mCount - 1);
        
        aReturn = (FSprite *)(mList.mData[aIndex]);
    }
    
    return aReturn;
}


