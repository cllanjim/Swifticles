//
//  FButton.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/23/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef FRAMEWORK_BUTTON_H
#define FRAMEWORK_BUTTON_H

#include "FView.h"
#include "FSprite.h"

class FButton : public FView
{
public:
    
    FButton();
    virtual ~FButton();
    
    void                                    SetUp(FSprite *pSpriteUp, FSprite *pSpriteOver, FSprite *pSpriteDown, FVec2 pPos);
    
    virtual void                            Update();
    virtual void                            Draw();
    
    virtual void                            MouseDown(float pX, float pY);
	virtual void                            MouseUp(float pX, float pY);
	virtual void                            MouseMove(float pX, float pY);
    
    virtual void                            TouchDown(float pX, float pY, void *pData);
	virtual void                            TouchUp(float pX, float pY, void *pData);
    virtual void                            TouchMove(float pX, float pY, void *pData);
    virtual void                            TouchFlush();
    
    void                                    *mClickData;
    
    bool                                    mMultiTouch;
    
    bool                                    mIsDown;
    bool                                    mIsOver;
    
    FSprite                                 *mSpriteUp;
    FSprite                                 *mSpriteOver;
    FSprite                                 *mSpriteDown;
    
    //bool                                    mIsHighlighted;
    
    //These are for PC only.. Ignore for now..
    virtual void                            ButtonActionRollOver(){}
    virtual void                            ButtonActionRollOff(){}
    
    virtual void                            ButtonActionDragOver(){}
    virtual void                            ButtonActionDragOff(){}
    
    virtual void                            ButtonActionReleaseOver(){}
    virtual void                            ButtonActionReleaseOff(){}
    
    FSprite                                 *GetButtonImage();
    
};


#endif
