//
//  FView.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/12/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#ifndef FRAMEWORK_VIEW_H
#define FRAMEWORK_VIEW_H

#include "FList.h"
#include "FRect.h"
#include "FMatrix.h"
#include "FString.h"

class FButton;

class FView
{
public:
    FView();
    virtual ~FView();
    
    virtual void                            BaseUpdate();
    virtual void                            BaseDraw();
    virtual void                            BaseDrawOver();
    
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
    
    virtual void                            ButtonClick(FButton *pButton){}
    virtual void                            Notify(void *pData){}
    
    virtual bool                            ContainsPoint(float pX, float pY, bool pRelative=true);
    
    void                                    Kill();
    int                                     mKill;
    
    FString                                 mName;
    
    float                                   mTestRed;
    float                                   mTestGreen;
    float                                   mTestBlue;
    
    FRect                                   mFrame;
    
    float                                   GetViewWidth(){return mFrame.mWidth * mTransformScale;}
    float                                   GetViewHeight(){return mFrame.mHeight * mTransformScale;}
    
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
    
    void                                    TransformScreenAspectFit();
    void                                    TransformScreenAspectFill();
    
    void                                    TransformScreenWidthFit();
    void                                    TransformScreenHeightFit();
    
    
};

#endif
