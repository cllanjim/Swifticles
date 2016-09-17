//
//  CoinObject.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/16/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#include "CoinObject.h"


CoinObject::CoinObject()
{
    mX = 0;
    mY = 0;
    mZ = 0;
    
    mRotX = gRand.GetFloat(360.f);
    mRotY = gRand.GetFloat(360.f);
    mRotZ = gRand.GetFloat(360.f);
    
    mRotXSpeed = gRand.GetFloat(-4.0f, 4.0f);
    mRotYSpeed = gRand.GetFloat(-4.0f, 4.0f);
    mRotZSpeed = gRand.GetFloat(-4.0f, 4.0f);
    
    mScale = gRand.GetFloat() * 0.2f + 0.6f;
    
    
    
    
}

CoinObject::~CoinObject()
{
    
}

void CoinObject::Update()
{
    mRotX += mRotXSpeed;
    if(mRotX >= 360.0f)mRotX -= 360.0f;
    if(mRotX < 0)mRotX += 360.0f;
    
    mRotY += mRotYSpeed;
    if(mRotY >= 360.0f)mRotY -= 360.0f;
    if(mRotY < 0)mRotY += 360.0f;
    
    mRotZ += mRotZSpeed;
    if(mRotZ >= 360.0f)mRotZ -= 360.0f;
    if(mRotZ < 0)mRotZ += 360.0f;
}

void CoinObject::Draw()
{
    FMatrix aHold = gfx_matrixModelViewGet();
    FMatrix aMatrix = aHold;
    
    aMatrix.Translate(mX, mY, mZ);
    
    aMatrix.RotateX(mRotX);
    aMatrix.RotateY(mRotY);
    aMatrix.RotateZ(mRotZ);
    
    aMatrix.Scale(mScale);
    
    gfx_matrixModelViewSet(aMatrix);
    
    gApp->mModelTalisman.Draw();
    
    
    
    
    //FMatrix aHoldProj = gfx_matrixProjectionGet();
    //FMatrix aPojection = FMatrixCreateOrtho(0.0f, gDeviceWidth, gDeviceHeight, 0.0f, 2048.0f, -2048.0f);
    //gfx_matrixProjectionSet(aPojection);
    
    gfx_depthDisable();
    
    FMatrix aBillboard = FMatrixBillboard(aMatrix);
    aBillboard.Scale(0.005f);
    
    gfx_matrixModelViewSet(aBillboard);
    
    gApp->mArrow.Draw();
    
    gfx_depthEnable();
    
    
    
    //gfx_matrixProjectionSet(aHoldProj);
    gfx_matrixModelViewSet(aHold);
}




