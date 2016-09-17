//
//  ImageImport.cpp
//  JiggleReloaded
//
//  Created by Nicholas Raptis on 1/29/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

#include "JiggleZoomContainer.h"
#include "JiggleContent.h"
#include "ImageImportContent.h"
#include "GLApp.h"
#include "core_includes.h"

JiggleZoomContainer::JiggleZoomContainer()
{
    gJiggleContainer = this;
    
    //mCanvas = new JiggleZoomCanvas();
    //AddSubview(mCanvas);
    //mCanvas->mDrawManual = true;
    //mCanvas->SetTransformAnchor(0.0f, 0.0f);
    
    
    mJiggle = new JiggleArea();
    AddSubview(mJiggle);
    //mCanvas->AddSubview(mJiggle);
    mJiggle->mDrawManual = true;
    mJiggle->SetTransformAnchor(0.0f, 0.0f);
    
}


JiggleZoomContainer::~JiggleZoomContainer()
{
    printf("JiggleZoomContainer::~JiggleZoomContainer()\n");
    
    if(mJiggle)mJiggle = 0;
    
    FreeList(FDrawQuad, mDrawQuadList);
    mDrawQuadList.Clear();
}

void JiggleZoomContainer::Update()
{
    FZoomView::Update();
    
}

void JiggleZoomContainer::Draw()
{
    if(mBackLoop)
    {
        EnumList(FDrawQuad, aQuad, mDrawQuadList)aQuad->Draw(mBackLoop);
    }
    
    DrawContent();
    
    DrawTransform();
    Graphics::SetColor(0.95f, 0.95f, 0.95f);
    Graphics::OutlineRect(0, 0, mWidth, mHeight, 2);
    Graphics::SetColor();
    
}



void JiggleZoomContainer::TouchDown(float pX, float pY, void *pData)
{
    if(gJiggle->mPanAndZoom == false)
    {
        mJiggle->TouchDown(TransformX(pX), TransformY(pY), pData);
    }
    
}

void JiggleZoomContainer::TouchMove(float pX, float pY, void *pData)
{
    if(gJiggle->mPanAndZoom == false)
    {
        mJiggle->TouchMove(TransformX(pX), TransformY(pY), pData);
    }
}

void JiggleZoomContainer::TouchUp(float pX, float pY, void *pData)
{
    if(gJiggle->mPanAndZoom == false)
    {
        mJiggle->TouchUp(TransformX(pX), TransformY(pY), pData);
    }
}

void JiggleZoomContainer::TouchFlush()
{
    mJiggle->TouchFlush();
}



void JiggleZoomContainer::SetUp(float pX, float pY, float pWidth, float pHeight)
{
    SetFrame(pX, pY, pWidth, pHeight);
    
    float aBorderH = 200;
    float aBorderV = 400;
    
    //mCanvas->SetUp(0.0f, 0.0f, (int)(pWidth + (aBorderH * 2.0f) + 0.5f), (int)(pHeight + (aBorderV * 2.0f) + 0.5));
    
    SetContentView(mJiggle);
    mJiggle->SetUp(0.0f, 0.0f, pWidth, pHeight);
    
}

void JiggleZoomContainer::SetContentView(FGestureView *pView)
{
    mContentView = pView;
    if(mContentView != 0)
    {
        
        AddSubview(mContentView);
        mContentView->mDrawManual = true;
        mContentView->SetTransformAnchor(0.0f, 0.0f);
        
        mCenterX = pView->mWidth2;
        mCenterY = pView->mHeight2;
        
        FitArenaOnScreen();
    }
}


bool JiggleZoomContainer::AllowPan()
{
    if(gJiggle->mPanAndZoom)return true;
    if(mTouchCount > 1)
    {
        if((gJiggle->mMode == MODE_EDIT) && (gJiggle->mModeEdit == MODE_EDIT_AFFINE))return false;
        if((gJiggle->mMode == MODE_VIEW) && (gJiggle->mModeView == MODE_VIEW_TOUCH))return false;
        
        return true;
    }
    return false;
}

bool JiggleZoomContainer::AllowPinch()
{
    
    //if(gJiggle->mPanAndZoom)return true;
    //if(mTouchCount > 1)return true;
    return AllowPan();
    
}

bool JiggleZoomContainer::AllowRotate()
{
    //if(gJiggle->mPanAndZoom)return true;
    //if(mTouchCount > 1)return true;
    
    return AllowPan();
}

FXMLTag *JiggleZoomContainer::SaveXML()
{
    FXMLTag *aJiggleTag = new FXMLTag();
    aJiggleTag->SetName("jiggle_container");
    aJiggleTag->AddTag("center_x", FString(FloatToInt(mCenterX)).c());
    aJiggleTag->AddTag("center_y", FString(FloatToInt(mCenterY)).c());
    aJiggleTag->AddTag("zoom_scale", FString(FloatToInt(mZoomScale)).c());
    aJiggleTag->AddTag("zoom_scale_min", FString(FloatToInt(mZoomScaleMin)).c());
    aJiggleTag->AddTag("zoom_scale_max", FString(FloatToInt(mZoomScaleMax)).c());
    return aJiggleTag;
}

void JiggleZoomContainer::LoadXML(FXMLTag *pTag)
{
    if(pTag)
    {
        
        mCenterX = IntToFloat(FString(pTag->GetSubtagValue("center_x")).ToInt());
        mCenterY = IntToFloat(FString(pTag->GetSubtagValue("center_y")).ToInt());
        
        mZoomScale = IntToFloat(FString(pTag->GetSubtagValue("zoom_scale")).ToInt());
        
        mZoomScaleMin = IntToFloat(FString(pTag->GetSubtagValue("zoom_scale_min")).ToInt());
        mZoomScaleMax = IntToFloat(FString(pTag->GetSubtagValue("zoom_scale_max")).ToInt());
        
        if(mZoomScale <= 0.1f)mZoomScale = 1.0f;
        mZoomScaleTarget = mZoomScale;

        if(mZoomScaleMax < 0.15f)mZoomScaleMax = 1.0f;
        if(mZoomScaleMin < 0.05f)(mZoomScaleMin = mZoomScaleMax * 0.75f);
    }
}


JiggleZoomCanvas::JiggleZoomCanvas()
{
    
}

JiggleZoomCanvas::~JiggleZoomCanvas()
{
    
}

void JiggleZoomCanvas::Update()
{
    
}

void JiggleZoomCanvas::Draw()
{
    Graphics::SetColor(0.45f, 0.33f, 0.25f, 0.8f);
    Graphics::OutlineRect(0.0f, 0.0f, mWidth, mHeight, 5.0f);
    
    Graphics::SetColor(1.0f, 0.88f, 1.0f, 0.45f);
    Graphics::DrawRect(10.0f, 10.0f, mWidth - 20, mHeight - 20);
    
    Graphics::SetColor();
    
}

void JiggleZoomCanvas::SetUp(float pX, float pY, float pWidth, float pHeight)
{
    SetFrame(pX, pY, pWidth, pHeight);
    
}


void JiggleZoomCanvas::PanBegin(float x, float y)
{
    
}

void JiggleZoomCanvas::PanEnd(float pX, float pY, float pSpeedX, float pSpeedY)
{
    
}

void JiggleZoomCanvas::PinchBegin(float pScale)
{
    
}

void JiggleZoomCanvas::PinchEnd(float pScale)
{
    
}

void JiggleZoomCanvas::RotateStart(float pRotation)
{
    
}

void JiggleZoomCanvas::RotateEnd(float pDegrees)
{
    
}


void JiggleZoomCanvas::Pan(float x, float y)
{
    
}

void JiggleZoomCanvas::Pinch(float pScale)
{

}

void JiggleZoomCanvas::Rotate(float pDegrees)
{
    
}































