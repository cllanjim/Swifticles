//
//  MainApp.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 9/26/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#include "MainApp.h"
#include "View3DDemo.h"

MainApp *gApp=0;

MainApp::MainApp()
{
    gApp = this;
    
    mDemo = 0;
}

MainApp::~MainApp()
{
    
}

void MainApp::Load()
{
    mModelTalisman.Load("talisman_lev");
    mModelTalisman.SetImage("talisman_lev_uvw");
    
    mModelRocket.Load("rocket");
    mModelRocket.SetImage("rocket_uvw");
    
    mArrow.Load("arrow");
}

void MainApp::LoadComplete()
{
    mDemo = new View3DDemo();
    ViewAdd(mDemo);
}


void MainApp::Update()
{
    
}

void MainApp::Draw()
{
    gfx_positionEnable();
    gfx_texCoordEnable();
    
    gfx_blendEnable();
    gfx_blendSetAlpha();
    
    gfx_clear(0.0f, 0.0f, 0.0f);
    
    FMatrix aPojection = FMatrixCreateOrtho(0.0f, gDeviceWidth, gDeviceHeight, 0.0f, 2048.0f, -2048.0f);
    gfx_matrixProjectionSet(aPojection);
}

void MainApp::MouseDown(float pX, float pY)
{
    
}

void MainApp::MouseUp(float pX, float pY)
{
    
}

void MainApp::MouseMove(float pX, float pY)
{
    
}





