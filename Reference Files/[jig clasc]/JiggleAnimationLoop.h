//
//  JiggleAnimationLoop.h
//  JiggleReloaded
//
//  Created by Nicholas Raptis on 10/27/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

#ifndef JIGGLE_ANIM_LOOP_H
#define JIGGLE_ANIM_LOOP_H

#include "FQuad.h"
#include "FSprite.h"
#include "FDrawQuad.h"
#include "FSpline.h"

#define ANIM_MAX_LOOPS 32
#define ANIM_MAX_TICKS 1024

class JiggleAnimationLoop
{
public:
    JiggleAnimationLoop();
    virtual ~JiggleAnimationLoop();
    
    void                            Update();
    void                            Draw(float pCenterX, float pCenterY);
    void                            DrawGuide(float pCenterX, float pCenterY);
    
    int                             mAnimationLoopCount;
    FSpline                         mAnimationSpline;
    int                             mAnimationFrameOffset;
    
    int                             mLoopTimeVariance;
    
    int                             mAnimTime[ANIM_MAX_LOOPS];
    int                             mAnimTimeSpan[ANIM_MAX_LOOPS];
    
    float                           mAnimTwist[ANIM_MAX_LOOPS];
    float                           mAnimBulge[ANIM_MAX_LOOPS];
    
    float                           mAnimTanX1[ANIM_MAX_TICKS];
    float                           mAnimTanY1[ANIM_MAX_TICKS];
    float                           mAnimTanX2[ANIM_MAX_TICKS];
    float                           mAnimTanY2[ANIM_MAX_TICKS];
    
    float                           mAnimX1[ANIM_MAX_TICKS];
    float                           mAnimY1[ANIM_MAX_TICKS];
    float                           mAnimX2[ANIM_MAX_TICKS];
    float                           mAnimY2[ANIM_MAX_TICKS];
    
    
    
    int                             mInterpIndex1[ANIM_MAX_TICKS];
    int                             mInterpIndex2[ANIM_MAX_TICKS];
    
    float                           mInterpPercent[ANIM_MAX_TICKS];
    
    float                           mInterpX[ANIM_MAX_TICKS];
    float                           mInterpY[ANIM_MAX_TICKS];
    
    float                           mInterpBulge[ANIM_MAX_TICKS];
    float                           mInterpTwist[ANIM_MAX_TICKS];
    
    void                            AnimationUpdate(int pTick, int pTime);
    void                            AnimationRefresh(int pTick, int pTime);
    void                            AnimationCancel();
    
    float                           mOffsetX;
    float                           mOffsetY;
};

#endif /* JiggleAnimationLoop_hpp */







