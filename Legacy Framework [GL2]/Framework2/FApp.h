//
//  FApp.h
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef FRAMEWORK_APP_H
#define FRAMEWORK_APP_H

#include "core_gfx.h"
#include "core_os.h"
#include "core_sound.h"
#include "core_social.h"
#include "stdafx.h"
#include "FTransition.h"
#include "FRenderQueue.h"

class FApp
{
public:
    
    FApp();
    virtual ~FApp();
    
    virtual void                            Load(){}
    virtual void                            LoadComplete(){}
    
    void                                    BaseUpdate();
    void                                    BaseDraw();
    void                                    BaseDrawOver();
    
    virtual void                            Update(){}
	virtual void                            Draw(){}
    virtual void                            DrawOver(){}
    
    void                                    BaseMouseDown(float pX, float pY);
	void                                    BaseMouseUp(float pX, float pY);
	void                                    BaseMouseMove(float pX, float pY);
    
	virtual void                            MouseDown(float pX, float pY){}
	virtual void                            MouseUp(float pX, float pY){}
	virtual void                            MouseMove(float pX, float pY){}
    
    void                                    BaseTouchDown(float pX, float pY, void *pData);
	void                                    BaseTouchUp(float pX, float pY, void *pData);
    void                                    BaseTouchMove(float pX, float pY, void *pData);
    void                                    BaseTouchFlush();
    
    virtual void                            TouchDown(float pX, float pY, void *pData){}
	virtual void                            TouchUp(float pX, float pY, void *pData){}
    virtual void                            TouchMove(float pX, float pY, void *pData){}
    virtual void                            TouchFlush(){}
    
    virtual void                            BaseInactive();
    virtual void                            BaseActive();
    
    virtual void                            Inactive(){}
    virtual void                            Active(){}
    
    
    
    void                                    PopoverViewAdd(FView *pView);
    
    FView                                   *mPopoverViewCurrent;
    
    FList                                   mPopoverViews;
    FList                                   mPopoverViewsKill;
    FList                                   mPopoverViewsDelete;
    
    
    
    
    //Texture binding stuff... Eventually move to gfx core?
	void                                    BindAdd(int pIndex);
	void                                    BindRemove(int pIndex);
	void                                    BindListPrint();
    void                                    BindPurgeAll();
    
    int                                     *mBindList;
	int                                     *mBindCountList;
	int                                     mBindListSize;
	int                                     mBindListCount;
    
    void                                    ViewAdd(FView *pView);
    void                                    ViewSendBack(FView *pView);
    void                                    ViewSendFront(FView *pView);
    
    FList                                   mViews;
    FList                                   mViewsKill;
    FList                                   mViewsDelete;
    
    FTransition                             *mTransition;
    FView                                   *mTransitionToView;
    FView                                   *mTransitionFromView;
    
    
    
    bool                                    TransitionInProgress(){return (mTransition != 0);}
    void                                    TransitionTo(FView *pToView, FView *pFromView, FTransition *pTransition);
    void                                    TransitionSwapViews();
    
};

extern FApp *gAppBase;
extern FRenderQueue gRenderQueue;

#endif
