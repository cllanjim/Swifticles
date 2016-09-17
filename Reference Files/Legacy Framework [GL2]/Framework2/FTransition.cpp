//
//  FTransition.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/25/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "FTransition.h"
#include "FApp.h"
#include "FastMatrix.h"

FTransition::FTransition()
{
    mKill = 0;
    
    mTransitionState = TRANSITION_STATE_INITIAL;
    
    mEnterTime = 6;
    mSwapTime = 1;
    mExitTime = 6;
    mTimer = 0;
}

FTransition::~FTransition()
{
    printf("Dealloc[FTransition]\n");
    
}

void FTransition::Update()
{
    if(mTransitionState == TRANSITION_STATE_INITIAL)
    {
        mTransitionState = TRANSITION_STATE_ENTER;
        mTimer = mEnterTime;
    }
    
    if(mTimer > 0)
    {
        mTimer--;
        
        if(mTimer <= 0)
        {
            if(mTransitionState == TRANSITION_STATE_ENTER)
            {
                mTransitionState = TRANSITION_STATE_SWAP;
                mTimer = mSwapTime;
            }
            else if(mTransitionState == TRANSITION_STATE_SWAP)
            {
                if(gAppBase)gAppBase->TransitionSwapViews();
                mTransitionState = TRANSITION_STATE_EXIT;
                mTimer = mExitTime;
            }
            else
            {
                Kill();
            }
        }
    }
}

void FTransition::Draw()
{
    FMatrix aProjection = FMatrixCreateOrtho(0.0f, gDeviceWidth, gDeviceHeight, 0.0f, 2048.0f, -2048.0f);
    gfx_matrixWorldViewSet(aProjection);
    
    
    float aPercentEnter = 0.0f;
    float aPercentSwap = 0.0f;
    float aPercentExit = 0.0f;
    
    float aFade = 0.0f;
    
    if(mTransitionState == TRANSITION_STATE_ENTER)
    {
        if(mEnterTime > 0)aPercentEnter = 1.0f - ((float)mTimer) / ((float)mEnterTime);
        else aPercentEnter = 1.0f;
        aFade = aPercentEnter;
    }
    else if(mTransitionState == TRANSITION_STATE_SWAP)
    {
        aPercentEnter = 1.0f;
        
        if(mSwapTime > 0)aPercentSwap = 1.0f - ((float)mTimer) / ((float)mSwapTime);
        else aPercentSwap = 1.0f;
        aFade = 1.0f;
    }
    else if(mTransitionState == TRANSITION_STATE_EXIT)
    {
        if(mExitTime > 0)aPercentExit = 1.0f - ((float)mTimer) / ((float)mExitTime);
        else aPercentExit = 1.0f;
        aFade = (1.0f - aPercentExit);
    }
    
    gfx_colorSet(0.0f, 0.0f, 0.0f, aFade);
    gfx_drawRect(0.0f, 0.0f, gDeviceWidth, gDeviceHeight);
    gfx_colorSet();
}

