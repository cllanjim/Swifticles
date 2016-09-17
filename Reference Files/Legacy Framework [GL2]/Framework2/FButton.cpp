//
//  FButton.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/23/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FButton.h"


FButton::FButton()
{
    mName = "FButton[FView]";
    
    mMultiTouch = true;
    
    mClickData = 0;
    
    mIsDown = false;
    mIsOver = false;
    
    mSpriteUp = 0;
    mSpriteOver = 0;
    mSpriteDown = 0;
    
}

FButton::~FButton()
{
    
}

void FButton::SetUp(FSprite *pSpriteUp, FSprite *pSpriteOver, FSprite *pSpriteDown, FVec2 pPos)
{
    if(pSpriteUp)
    {
        if(pSpriteUp->DidLoad())mSpriteUp = pSpriteUp;
        else mSpriteUp = 0;
    }
    else mSpriteUp = 0;
    
    if(pSpriteOver)
    {
        if(pSpriteOver->DidLoad())mSpriteOver = pSpriteOver;
        else mSpriteOver = 0;
    }
    else mSpriteOver = 0;
    
    if(pSpriteDown)
    {
        if(pSpriteDown->DidLoad())mSpriteDown = pSpriteDown;
        else mSpriteDown = 0;
    }
    else mSpriteDown = 0;
    
    FSprite *aSprite = GetButtonImage();
    
    if(aSprite)
    {
        mFrame = FRect(pPos.mX, pPos.mY, aSprite->mWidth, aSprite->mHeight);
    }
}

void FButton::Update()
{
    
}

void FButton::Draw()
{
    FSprite *aSprite = GetButtonImage();
    if(aSprite)
    {
        aSprite->Center(mFrame.mWidth / 2.0f, mFrame.mHeight / 2.0f);
    }
}

void FButton::MouseDown(float pX, float pY)
{
    if(mMultiTouch)return;
    
    
}

void FButton::MouseUp(float pX, float pY)
{
    if(mMultiTouch)return;
    
    
}

void FButton::MouseMove(float pX, float pY)
{
    if(mMultiTouch)return;
}

void FButton::TouchDown(float pX, float pY, void *pData)
{
    if(mMultiTouch == false)return;
    
    if(mClickData == 0)
    {
        if(ContainsPoint(pX, pY))
        {
            ButtonActionDragOver();
            mClickData = pData;
            mIsDown = true;
        }
    }
}

void FButton::TouchUp(float pX, float pY, void *pData)
{
    if(mMultiTouch == false)return;
    
    if(pData == mClickData)
    {
        if(ContainsPoint(pX, pY))
        {
            ButtonActionReleaseOver();
            if(mSuperview)
            {
                if(mSuperview->mKill == 0)
                {
                    mSuperview->ButtonClick(this);
                }
            }
        }
        else
        {
            ButtonActionReleaseOff();
        }
        
        mIsDown = false;
        mClickData = 0;
    }
}

void FButton::TouchMove(float pX, float pY, void *pData)
{
    if(mMultiTouch == false)return;
    
    if(pData == mClickData)
    {
        if(ContainsPoint(pX, pY))
        {
            if(mIsDown == false)
            {
                mIsDown = true;
                ButtonActionDragOver();
            }
        }
        else
        {
            if(mIsDown)
            {
                mIsDown = false;
                ButtonActionDragOff();
            }
        }
    }
}

void FButton::TouchFlush()
{
    mIsDown = false;
    mClickData = 0;
}

FSprite *FButton::GetButtonImage()
{
    FSprite *aReturn = 0;
    
    if(mIsDown)
    {
        if(mSpriteDown)
        {
            aReturn = mSpriteDown;
        }
        else
        {
            aReturn = mSpriteOver;
        }
    }
    else if(mIsOver)
    {
        aReturn = mSpriteOver;
    }
    else
    {
        aReturn = mSpriteUp;
    }
    
    if(aReturn == 0)
    {
        if(mSpriteUp)aReturn = mSpriteUp;
        else if(mSpriteOver)aReturn = mSpriteOver;
        else if(mSpriteDown)aReturn = mSpriteDown;
    }
    
    return aReturn;
}
