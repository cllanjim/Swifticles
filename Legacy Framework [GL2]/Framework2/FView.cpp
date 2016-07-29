//
//  FView.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/12/13.
//  Copyright (c) 2013 Nick Raptis Inc. All rights reserved.
//

#include "stdafx.h"
#include "FView.h"
#include "FButton.h"

FView::FView()
{
    mKill = 0;
    
    mName = "FView";
    
    mFrame = FRect(0.0f, 0.0f, gDeviceWidth, gDeviceHeight);
    
    mTransformTranslateX = 0.0f;
    mTransformTranslateY = 0.0f;
    
    mTransformScale = 1.0f;
    
    mTransformRotation = 0.0f;
    
    mSuperview = 0;
    
    mTestRed = gRand.GetFloat();
    mTestGreen = gRand.GetFloat();
    mTestBlue = gRand.GetFloat();
}

FView::~FView()
{
    printf("Deallocating View [%s]\n", mName.c());
    
    EnumList(FView, aView, mSubviews)delete aView;
    EnumList(FView, aView, mSubviewsKill)delete aView;
    EnumList(FView, aView, mSubviewsDelete)delete aView;
    
    mSubviews.RemoveAll();
    mSubviewsKill.RemoveAll();
    mSubviewsDelete.RemoveAll();
}

void FView::BaseUpdate()
{
    Update();
    
    EnumList(FView, aView, mSubviews)
    {
        aView->BaseUpdate();
        
        if(aView->mKill)
        {
            mSubviewsKill.Add(aView);
        }
    }
    
    EnumList(FView, aView, mSubviewsKill)
    {
        mSubviews.Remove(aView);
        aView->mKill--;
        if(aView->mKill <= 0)
        {
            mSubviewsDelete.Add(aView);
        }
    }
    
    EnumList(FView, aView, mSubviewsDelete)
    {
        mSubviewsKill.Remove(aView);
        delete aView;
    }
    
    mSubviewsDelete.RemoveAll();
}

void FView::BaseDraw()
{
    FMatrix aHold = gfx_matrixWorldViewGet();
    FMatrix aMatrix = aHold;
    
    aMatrix.Translate(mFrame.mX, mFrame.mY);
    
    aMatrix.Translate(mTransformTranslateX, mTransformTranslateY);
    aMatrix.Scale(mTransformScale);
    aMatrix.Rotate(mTransformRotation);
    
    gfx_matrixWorldViewSet(aMatrix);
    
    Draw();
    
    EnumList(FView, aView, mSubviews)
    {
        aView->BaseDraw();
    }
    
    gfx_matrixWorldViewSet(aHold);
}

void FView::BaseDrawOver()
{
    FMatrix aHold = gfx_matrixWorldViewGet();
    FMatrix aMatrix = aHold;
    
    aMatrix.Translate(mFrame.mX, mFrame.mY);
    
    aMatrix.Translate(mTransformTranslateX, mTransformTranslateY);
    aMatrix.Scale(mTransformScale);
    aMatrix.Rotate(mTransformRotation);
    
    gfx_matrixWorldViewSet(aMatrix);
    
    DrawOver();
    
    EnumList(FView, aView, mSubviews)
    {
        aView->BaseDrawOver();
    }
    
    gfx_matrixWorldViewSet(aHold);
}

/*
void FView::Draw()
{
    gfx_colorSet(mTestRed, mTestGreen, mTestBlue);
    gfx_drawRect(0.0f, 0.0f, mFrame.mWidth, mFrame.mHeight);
}
*/

void FView::BaseMouseDown(float pX, float pY)
{
    Transform(pX, pY);
    MouseDown(pX, pY);
    EnumList(FView, aView, mSubviews)
    {
        aView->BaseMouseDown(pX, pY);
    }
}

void FView::BaseMouseUp(float pX, float pY)
{
    Transform(pX, pY);
    MouseUp(pX, pY);
    EnumList(FView, aView, mSubviews)
    {
        aView->BaseMouseUp(pX, pY);
    }
}

void FView::BaseMouseMove(float pX, float pY)
{
    Transform(pX, pY);
    MouseMove(pX, pY);
    EnumList(FView, aView, mSubviews)
    {
        aView->BaseMouseMove(pX, pY);
    }
}

void FView::BaseTouchDown(float pX, float pY, void *pData)
{
    Transform(pX, pY);
    TouchDown(pX, pY, pData);
    EnumList(FView, aView, mSubviews)
    {
        aView->BaseTouchDown(pX, pY, pData);
    }
}

void FView::BaseTouchUp(float pX, float pY, void *pData)
{
    Transform(pX, pY);
    TouchUp(pX, pY, pData);
    EnumList(FView, aView, mSubviews)
    {
        aView->BaseTouchUp(pX, pY, pData);
    }
}

void FView::BaseTouchMove(float pX, float pY, void *pData)
{
    Transform(pX, pY);
    TouchMove(pX, pY, pData);
    EnumList(FView, aView, mSubviews)
    {
        aView->BaseTouchMove(pX, pY, pData);
    }
}

void FView::BaseTouchFlush()
{
    TouchFlush();
    EnumList(FView, aView, mSubviews)
    {
        aView->BaseTouchFlush();
    }
}

void FView::BaseInactive()
{
    Inactive();
}

void FView::BaseActive()
{
    Active();
}

void FView::Kill()
{
    mKill = 5;
}


void FView::SubviewAdd(FView *pView)
{
    pView->mSuperview = this;
    mSubviews.Add(pView);
}

void FView::SubviewSendBack(FView *pView)
{
    mSubviews.MoveToFront(pView);
}

void FView::SubviewSendFront(FView *pView)
{
    mSubviews.MoveToBack(pView);
}

bool FView::ContainsPoint(float pX, float pY, bool pRelative)
{
    bool aReturn = false;
    
    if((pX >= 0) && (pY >= 0) && (pX <= mFrame.mWidth) && (pY <= mFrame.mHeight))
    {
        aReturn = true;
    }
    
    //printf("View[%f %f %f %f] Contains[%f %f] = %d\n", mFrame.mX, mFrame.mY, mFrame.mWidth, mFrame.mHeight, pX, pY, aReturn);
    
    return aReturn;
}

void FView::Transform(float &pX, float &pY)
{
    float aX = pX - (mFrame.mX);
    float aY = pY - (mFrame.mY);
    
    float aDiffX = (aX - mTransformTranslateX);
    float aDiffY = (aY - mTransformTranslateY);
    
    float aRot = fmath_faceTarget(aDiffX, aDiffY);
    
    float aDist = aDiffX * aDiffX + aDiffY * aDiffY;
    
    if(aDist > SQRT_EPSILON)
    {
        aDist = sqrtf(aDist);
    }
    
    aRot -= mTransformRotation;
    
    float aDirX = fmath_sin(-aRot);
    float aDirY = fmath_cos(-aRot);
    
    pX = aDirX * (aDist / mTransformScale);
    pY = aDirY * (aDist / mTransformScale);
}



void FView::FitCenter(FRect pRect)
{
    if(mFrame.mWidth <= 0 || mFrame.mHeight <= 0 || pRect.mWidth <= 0 || pRect.mHeight <= 0)
    {
        return;
    }
    
    float aWidthRatio = pRect.mWidth / mFrame.mWidth;
    float aHeightRatio = pRect.mHeight / mFrame.mHeight;
    
    float aRatio = aWidthRatio;
    
    if(aHeightRatio < aWidthRatio)aRatio = aHeightRatio;
    
    mTransformScale = aRatio;
    
    //mFrame.mX = -mFrame.mWidth / 2.0f;
    //mFrame.mY = -mFrame.mHeight / 2.0f;
    
    mFrame.mX = pRect.mX + (pRect.mWidth / 2.0f - (mFrame.mWidth * mTransformScale) / 2.0f);
    mFrame.mY = pRect.mY + (pRect.mHeight / 2.0f - (mFrame.mHeight * mTransformScale) / 2.0f);
    
    mTransformTranslateX = 0.0f;//pRect.mWidth / 2.0f;
    mTransformTranslateY = 0.0f;//pRect.mHeight / 2.0f;
}

void FView::TransformScreenAspectFit()
{
    if(mFrame.mWidth <= 0 || mFrame.mHeight <= 0 || gDeviceWidth <= 0 || gDeviceHeight <= 0)
    {
        return;
    }
    
    float aWidthRatio = (gDeviceWidth) / mFrame.mWidth;
    float aHeightRatio = (gDeviceHeight) / mFrame.mHeight;
    
    float aRatio = aWidthRatio;
    
    if(aHeightRatio < aWidthRatio)aRatio = aHeightRatio;
    
    mTransformScale = aRatio;
    
    mFrame.mX = (gDeviceWidth2  - (mFrame.mWidth  * mTransformScale) / 2.0f);
    mFrame.mY = (gDeviceHeight2 - (mFrame.mHeight * mTransformScale) / 2.0f);
    
    mTransformTranslateX = 0.0f;
    mTransformTranslateY = 0.0f;
}

void FView::TransformScreenAspectFill()
{
    if(mFrame.mWidth <= 0 || mFrame.mHeight <= 0 || gDeviceWidth <= 0 || gDeviceHeight <= 0)
    {
        return;
    }
    
    float aWidthRatio = (gDeviceWidth) / mFrame.mWidth;
    float aHeightRatio = (gDeviceHeight) / mFrame.mHeight;
    
    float aRatio = aWidthRatio;
    
    if(aHeightRatio > aWidthRatio)aRatio = aHeightRatio;
    
    mTransformScale = aRatio;
        
    mFrame.mX = (gDeviceWidth2  - (mFrame.mWidth  * mTransformScale) / 2.0f);
    mFrame.mY = (gDeviceHeight2 - (mFrame.mHeight * mTransformScale) / 2.0f);
    
    mTransformTranslateX = 0.0f;
    mTransformTranslateY = 0.0f;
}

void FView::TransformScreenWidthFit()
{
    if(mFrame.mWidth <= 0 || mFrame.mHeight <= 0 || gDeviceWidth <= 0 || gDeviceHeight <= 0)
    {
        return;
    }
    
    mTransformScale = (gDeviceWidth) / mFrame.mWidth;
    
    mFrame.mX = 0.0f;
    
    mTransformTranslateX = 0.0f;
    mTransformTranslateY = 0.0f;
}

void FView::TransformScreenHeightFit()
{
    if(mFrame.mWidth <= 0 || mFrame.mHeight <= 0 || gDeviceWidth <= 0 || gDeviceHeight <= 0)
    {
        return;
    }
    
    mTransformScale = (gDeviceHeight - 10) / mFrame.mHeight;
    
    mFrame.mY = 0.0f;
    
    mTransformTranslateX = 0.0f;
    mTransformTranslateY = 0.0f;
}


