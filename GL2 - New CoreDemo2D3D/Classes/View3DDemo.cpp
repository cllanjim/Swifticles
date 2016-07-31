//
//  View3DDemo.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/16/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#include "View3DDemo.h"


View3DDemo::View3DDemo()
{
    mTargetEyeZ = 0.0f;
    mEyeZ = 0.0f;
    
    mCameraOrbit = 0.0f;
    
    mCameraDist = 6.0f;
    
    
    for(float aRotation = 0.0f;aRotation < 360.0f; aRotation += 30.0f)
    {
        
        float aDist = 4.0f;
        
        CoinObject *aObject = new CoinObject();
        aObject->mX = fmath_sin(aRotation) * aDist;
        aObject->mY = fmath_cos(aRotation) * aDist;
        aObject->mZ = gRand.GetFloat() * 0.5f;
        
        mObjectList += aObject;
        
    }
    
    
    mMouseIsDown = false;
    mMouseStartRotation = 0.0f;
    mMouseStartX = 0.0f;
    
    
    mMouseX = gDeviceWidth2;
    mMouseY = gDeviceHeight2 / 2.0f;
    
}

View3DDemo::~View3DDemo()
{
    
}

void View3DDemo::Update()
{
    if(mEyeZ < mTargetEyeZ)
    {
        mEyeZ += 0.25f;
        if(mEyeZ >= mTargetEyeZ)mEyeZ = mTargetEyeZ;
    }
    
    
    if(mEyeZ > mTargetEyeZ)
    {
        mEyeZ -= 0.25f;
        if(mEyeZ <= mTargetEyeZ)mEyeZ = mTargetEyeZ;
    }
    
    
    
    
    if(mMouseIsDown)
    {
    
    }
    else
    {
        mCameraOrbit += 0.5f;
        if(mCameraOrbit >= 360.0f)mCameraOrbit -= 360.0f;
    }
    
    EnumList(CoinObject, aObject, mObjectList)
    {
        aObject->Update();
    }
    
}

void View3DDemo::Draw()
{
    
    //3-D Rendering!!
    FMatrix aMatrixPerspective = FMatrixCreatePerspective(140.0f, (float)gDeviceWidth / (float)gDeviceHeight, 0.1f, 255.0f);
    gfx_matrixProjectionSet(aMatrixPerspective);
    
    float aEyeX = fmath_sin(mCameraOrbit) * mCameraDist;
    float aEyeY = fmath_cos(mCameraOrbit) * mCameraDist;
    float aEyeZ = mEyeZ;
    
    FMatrix aMatrixCamera = FMatrixCreateLookAt(aEyeX, aEyeY, aEyeZ, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f);
    gfx_matrixModelViewSet(aMatrixCamera);
    
    gfx_depthClear();
    gfx_depthEnable();
    
    gApp->mModelRocket.Draw();
    
    EnumList(CoinObject, aObject, mObjectList)
    {
        aObject->Draw();
    }
    
    gfx_depthDisable();
    
    //2-D Rendering!
    
    FMatrix aMatrixOrtho = FMatrixCreateOrtho(0.0f, gDeviceWidth, gDeviceHeight, 0.0f, 2048.0f, -2048.0f);
    gfx_matrixProjectionSet(aMatrixOrtho);
    
    
    
    gfx_matrixModelViewReset();
    
    
    
    float aArrowScale = 0.6f;
    if(gDeviceWidth != 768.0f)aArrowScale = 0.35f;
    
    
    float aArrowX = gDeviceWidth2 / 2.0f;
    float aArrowY = gDeviceHeight2 / 2.0f;
    
    float aArrowRotation = fmath_faceTarget(aArrowX, aArrowY, mMouseX, mMouseY);
    
    gApp->mArrow.Draw(aArrowX, aArrowY, aArrowRotation, aArrowScale);
    
    
    aArrowX += gDeviceWidth2;
    aArrowY += gDeviceHeight2;
    
    aArrowRotation = fmath_faceTarget(aArrowX, aArrowY, mMouseX, mMouseY);
    
    gApp->mArrow.Draw(aArrowX, aArrowY, aArrowRotation, aArrowScale);
    
}

void View3DDemo::MouseDown(float pX, float pY)
{
    
    mMouseIsDown = true;
    
    mMouseStartRotation = mCameraOrbit;
    mMouseStartX = pX;
    
    MouseMove(pX, pY);
}

void View3DDemo::MouseUp(float pX, float pY)
{
    mMouseIsDown = false;
}

void View3DDemo::MouseMove(float pX, float pY)
{
    mMouseX = pX;
    mMouseY = pY;
    
    float aPercent = (float)pY / (float)gDeviceHeight - 0.5f;
    mTargetEyeZ = aPercent * 20.0f;
    
    mCameraOrbit = (float)(pX - mMouseStartX) / ((float)gDeviceWidth) * 200.0f;
    
}








