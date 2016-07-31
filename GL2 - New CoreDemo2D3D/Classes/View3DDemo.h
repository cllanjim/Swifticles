//
//  View3DDemo.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/16/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#ifndef CoreDemo_View3DDemo_h
#define CoreDemo_View3DDemo_h

#include "MainApp.h"
#include "CoinObject.h"

class View3DDemo : public FView
{
public:
    
    View3DDemo();
    virtual ~View3DDemo();
    
    virtual void                            Update();
	virtual void                            Draw();
    
	virtual void                            MouseDown(float pX, float pY);
	virtual void                            MouseUp(float pX, float pY);
	virtual void                            MouseMove(float pX, float pY);
    
    
    
    float                                   mTargetEyeZ;
    float                                   mEyeZ;
    
    float                                   mCameraOrbit;
    
    float                                   mCameraDist;
    
    FList                                   mObjectList;
    
    
    
    bool                                    mMouseIsDown;
    float                                   mMouseStartRotation;
    float                                   mMouseStartX;
    
    float                                   mMouseX;
    float                                   mMouseY;
    
};

#endif
