
//
//  JiggleAnimationCubic.cpp
//  JiggleReloaded
//
//  Created by Nicholas Raptis on 10/27/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

#include "JiggleAnimationCubic.h"
#include "ToolStyle.h"
#include "core_includes.h"



JiggleAnimationCubic::JiggleAnimationCubic()
{
    
    mLoopTimeVariance = 7;
    mAnimationLoopCount = 9;
    mAnimationFrameOffset = 0;
    
    
    mOffsetX = 0.0f;
    mOffsetY = 0.0f;
    
}

JiggleAnimationCubic::~JiggleAnimationCubic()
{
    
}


void JiggleAnimationCubic::Update()
{
    
}

void JiggleAnimationCubic::Draw(float pCenterX, float pCenterY)
{
    
}

void JiggleAnimationCubic::DrawGuide(float pCenterX, float pCenterY)
{
    
    Graphics::SetColor(1.0f, 1.0f, 0.45f, 0.65f);
    
    Graphics::DrawRect(mOffsetX + pCenterX - 3, mOffsetY + pCenterY - 3, 7, 7);
    
    
}

void JiggleAnimationCubic::AnimationUpdate(int pTick, int pTime)
{
    int aTick = (pTick + mAnimationFrameOffset);
    
    if(aTick < 0){aTick += pTime;}
    if(aTick > pTime){aTick -= pTime;}
    if((aTick >= 0) && (aTick < pTime))
    {
        mOffsetX = mInterpX[aTick];
        mOffsetY = mInterpY[aTick];
        
        //mTwistRotation = mInterpTwist[aTick];
        //SetPunch(mInterpBulge[aTick]);
        //mPunch = mInterpBulge[aTick];
    }
}

void JiggleAnimationCubic::AnimationRefresh(int pTick, int pTime)
{
    if(mAnimationLoopCount < 1)mAnimationLoopCount = 1;
    if(mAnimationLoopCount >= ANIM_MAX_LOOPS)mAnimationLoopCount = (ANIM_MAX_LOOPS - 1);
    
    //int aPrevTime = 0;
    for(int i=0;i<=mAnimationLoopCount;i++)
    {
        float aPercent = ((float)i) / ((float)mAnimationLoopCount);
        if(aPercent > 1.0f)aPercent = 1.0f;
        
        int aTime = (int)(((aPercent) * ((float)pTime)) + 0.5f);
        
        mAnimTime[i] = aTime;
        
        mAnimTwist[i] = 0.0f;
        mAnimBulge[i] = 0.0f;
        /*
         mAnimBulge[i] = mAnimationRand.GetFloat(-1.25f, 1.25f);
         
         if(gRand.GetBool())
         {
         mAnimTwist[i] = mAnimationRand.GetFloat(-2.0f, 2.0f);
         }
         else
         {
         mAnimTwist[i] = mAnimationRand.GetFloat(1.0f, 5.0f);
         }
         
         */
        
        mAnimX1[i] = gRand.GetFloat(-5.0f, 5.0f);
        mAnimY1[i] = -24.0f - gRand.GetFloat(22.0f);
        mAnimX2[i] = gRand.GetFloat(-4.0f, 4.0f);
        mAnimY2[i] = 80.0f - gRand.GetFloat(40.0f);
        
        mAnimTanX1[i] = 60.0f + gRand.GetFloat(80.0f);
        mAnimTanY1[i] = gRand.GetFloat(-24.0f, 24.0f);
        mAnimTanX2[i] = -160.0f - gRand.GetFloat(100.0f);
        mAnimTanY2[i] = gRand.GetFloat(-30.0f, 30.0f);
        
        
    }
    
    for(int i=1;i<mAnimationLoopCount;i++)
    {
        mAnimTime[i] += gRand.Get(-(mLoopTimeVariance / 2), (mLoopTimeVariance / 2) + 1);
    }
    
    mAnimX1[mAnimationLoopCount] = mAnimX1[0];mAnimY1[mAnimationLoopCount] = mAnimY1[0];
    mAnimX2[mAnimationLoopCount] = mAnimX2[0];mAnimY2[mAnimationLoopCount] = mAnimY2[0];
    mAnimTanX1[mAnimationLoopCount] = mAnimTanX1[0];mAnimTanY1[mAnimationLoopCount] = mAnimTanY1[0];
    mAnimTanX2[mAnimationLoopCount] = mAnimTanX2[0];mAnimTanY2[mAnimationLoopCount] = mAnimTanY2[0];
    
    mAnimBulge[mAnimationLoopCount] = mAnimBulge[0];
    mAnimTwist[mAnimationLoopCount] = mAnimTwist[0];
    
    for(int i=1;i<=mAnimationLoopCount;i++)
    {
        mAnimTimeSpan[i - 1] = (mAnimTime[i] - mAnimTime[i - 1]);
    }
    mAnimTimeSpan[mAnimationLoopCount] = mAnimTimeSpan[0];
    
    
    
    
    int aIndex1 = 0, aIndex2 = 1;
    int aTick = 0, aTime = 0;
    
    int aTickCount = mAnimTimeSpan[0];
    
    for(int i=0;i<pTime;i++)
    {
        int aDiv = aTickCount;
        if(aDiv < 1)aDiv = 1;
        
        mInterpPercent[i] = ((float)aTick) / ((float)aDiv);
        mInterpIndex1[i] = aIndex1;mInterpIndex2[i] = aIndex2;
        
        aTick++;
        if(aTick >= aTickCount)
        {
            aIndex1++;
            aTick = 0;
            aTime = mAnimTime[aIndex1];
            aTickCount = mAnimTimeSpan[aIndex1];
            aIndex2 = (aIndex1 + 1);
            if(aIndex2 > mAnimationLoopCount)aIndex2 = mAnimationLoopCount;
        }
    }
    
    for(int i=0;i<pTime;i++)
    {
        int aInd1 = mInterpIndex1[i];
        int aInd2 = mInterpIndex2[i];
        float aPercent = mInterpPercent[i];
        mInterpBulge[i] = mAnimBulge[aInd1] + (mAnimBulge[aInd2] - mAnimBulge[aInd1]) * aPercent;
        mInterpTwist[i] = mAnimTwist[aInd1] + (mAnimTwist[aInd2] - mAnimTwist[aInd1]) * aPercent;
    }
    
    float aX1, aY1, aX2, aY2, aTanX1, aTanY1, aTanX2, aTanY2;
    for(int i=0;i<pTime;i++)
    {
        float aPercent = mInterpPercent[i] * 2.0f;
        int aInd1 = mInterpIndex1[i];int aInd2 = mInterpIndex2[i];
        
        if(aPercent > 1.0f)
        {
            aPercent -= 1.0f;
            aX1 = mAnimX2[aInd1];aY1 = mAnimY2[aInd1];
            aX2 = mAnimX1[aInd2];aY2 = mAnimY1[aInd2];
            aTanX1 = -mAnimTanX2[aInd1];aTanY1 = -mAnimTanY2[aInd1];
            aTanX2 = mAnimTanX1[aInd2];aTanY2 = mAnimTanY1[aInd2];
        }
        else
        {
            aX1 = mAnimX1[aInd1];aY1 = mAnimY1[aInd1];
            aX2 = mAnimX2[aInd1];aY2 = mAnimY2[aInd1];
            aTanX1 = -mAnimTanX1[aInd1];aTanY1 = -mAnimTanY1[aInd1];
            aTanX2 = mAnimTanX2[aInd1];aTanY2 = mAnimTanY2[aInd1];
        }
        
        mInterpX[i] = FAnimation::SplineInterpolate(aPercent, aX1, aX2, aTanX1, aTanX2);
        mInterpY[i] = FAnimation::SplineInterpolate(aPercent, aY1, aY2, aTanY1, aTanY2);
        
    }
}

void JiggleAnimationCubic::AnimationCancel()
{
    
}




