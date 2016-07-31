//
//  MainApp.h
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#ifndef CoreDemo_MainApp_h
#define CoreDemo_MainApp_h

#include "FApp.h"
#include "FModelData.h"

class Game;
class View3DDemo;

class MainApp : public FApp
{
public:
    
    MainApp();
    virtual ~MainApp();
    
    virtual void                            Load();
    virtual void                            LoadComplete();
    
    virtual void                            Update();
	virtual void                            Draw();
    
    virtual void                            MouseDown(float pX, float pY);
	virtual void                            MouseUp(float pX, float pY);
	virtual void                            MouseMove(float pX, float pY);
    
    View3DDemo                              *mDemo;
    
    FModelDataIndexed                       mModelTalisman;
    FModelDataIndexed                       mModelRocket;
    
    FSprite                                 mArrow;
    
};

extern MainApp *gApp;

#endif
