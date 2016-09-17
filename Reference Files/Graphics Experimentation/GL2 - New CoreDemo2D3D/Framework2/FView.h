//
//  FView.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/12/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#ifndef FRAMEWORK_VIEW_H
#define FRAMEWORK_VIEW_H

#include "FList.h"
#include "FRect.h"
#include "FMatrix.h"

class FView
{
public:
    FView();
    virtual ~FView();
    
    void                                    BaseUpdate();
    void                                    BaseDraw();
    
    virtual void                            Update(){}
	//virtual void                            Draw(){}
    virtual void                            Draw();
    
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
    
    void                                    Kill();
    int                                     mKill;
    
    float                                   mTestRed;
    float                                   mTestGreen;
    float                                   mTestBlue;
    
    FRect                                   mFrame;
    
    float                                   mTransformTranslateX;
    float                                   mTransformTranslateY;
    float                                   mTransformScale;
    float                                   mTransformRotation;
    
    void                                    SubviewAdd(FView *pView);
    void                                    SubviewSendBack(FView *pView);
    void                                    SubviewSendFront(FView *pView);
    
    FList                                   mSubviews;
    FList                                   mSubviewsKill;
    FList                                   mSubviewsDelete;
    
    FView                                   *mSuperview;
    
    void                                    Transform(float &pX, float &pY);
    
    void                                    FitCenter(FRect pRect);
    
};

#endif
