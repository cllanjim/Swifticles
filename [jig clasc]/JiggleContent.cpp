//
//  JiggleContent.cpp
//  Ghibli
//
//  Created by Nick Raptis on 7/4/14.
//  Copyright (c) 2014 Union AdWorks LLC. All rights reserved.
//

#include "JiggleContent.h"
#include "core_includes.h"
#include "ToolControls.h"
#include "TopTools.h"

JiggleContent *gJiggleScene = 0;
JiggleZoomContainer *gJiggleContainer = 0;

JiggleContent::JiggleContent()
{
    mName = "Jiggle Content";
    
    mTopTools = 0;
    mBottomTools = 0;
    mContainer = 0;
    
    gJiggleScene = this;
    SetFrame(0.0f, 0.0f, gAppWidth, gAppHeight);
    
    
    gTools->SetUp(gAppWidth, gAppHeight);
    
    mBottomTools = new BottomTools();
    mBottomTools->SetUp(this, gAppWidth, gAppHeight);
    
    mTopTools = new TopTools();
    mTopTools->SetUp(this, gAppWidth, gAppHeight);
    
    
    mContainer = new JiggleZoomContainer();
    gJiggleContainer = mContainer;
    AddSubview(mContainer);
    mContainer->SetUp(0.0f, 0.0f, gAppWidth, gAppHeight);
    mContainer->mDrawManual = true;
    
    
    if((gJiggle != 0) && (gTools != 0))
    {
        gTools->RefreshUI();
        gTools->RefreshSelection(gJiggle->mSelected);
    }
    
}

JiggleContent::~JiggleContent()
{
    printf("JiggleContent::~JiggleContent()\n");
    
    gJiggleScene = 0;
}

void JiggleContent::Update()
{
    
    /*
        mToolsTopSlideout->Layout();
        
        if(mMenuAnimatingAdjust <= 0)
        {
            mMenuAnimatingAdjust = 0;
        }
    
    
    float aToolBarBottomY = (mToolsTop->mY + mToolsTop->mHeight);
    float aButtonHeight = mToolsTopSlideout->mButtonMenuExpand->mHeight;
    float aOffsetY0 = (mToolsTopSlideout->mHeight - aButtonHeight);
    float aOffsetY1 = 0.0f;
    
    float aShift = (aOffsetY0 + (aOffsetY1 - aOffsetY0) * aExpandPercent);
    
    float aY = (((int)aToolBarBottomY) - ((int)aShift));

    mToolsTopSlideout->SetY(aY);
    
    if(mMenuPrevious != 0)
    {
        mMenuPrevious->SetY((int)(mMenuPanel->mHeight - mMenuPrevious->mHeight));
    }
    
    if(mMenuCurrent != 0)
    {
        mMenuCurrent->SetY((int)(mMenuPanel->mHeight - mMenuCurrent->mHeight));
    }
    
    
    float aToolsBottomY = mToolsTop->mY + mToolsTop->mHeight;
    float aBottom = mToolsTopSlideout->mY + mToolsTopSlideout->mHeight;
    if(aToolsBottomY > aBottom)aBottom = aToolsBottomY;
    float aTop = mToolsTop->mY + mToolsTop->mHeight2;
    
    float aGoodY = (aTop + (aBottom - aTop) * 0.75f);
    mScrollView->SetY(aGoodY);
    
    */
    
    if(mTopTools)
    {
        mTopTools->Update();
    }
}

void JiggleContent::Draw()
{
    
    if(mContainer)mContainer->DrawManual();
    if(mBottomTools)mBottomTools->Draw();
    if(mTopTools)mTopTools->Draw();
    
    if(mContainer)
    {
        mContainer->DrawTransform();
        
        Graphics::SetColor(1.0f, 0.25f, 0.5f, 0.6f);
        Graphics::OutlineRect(0.0f, 0.0f, mContainer->mWidth, mContainer->mHeight, 4.0f);
        
        Graphics::SetColor(0.25f, 0.18f, 0.08f, 0.15f + gRand.GetFloat(0.05f));
        Graphics::DrawRect(20, 20, mContainer->mWidth - 40, mContainer->mHeight - 40);
        
    }
}


void JiggleContent::TouchDown(float pX, float pY, void *pData)
{
    
}

void JiggleContent::TouchMove(float pX, float pY, void *pData)
{
    
}

void JiggleContent::TouchUp(float pX, float pY, void *pData)
{
    //mActivePoint = 0;
}

void JiggleContent::TouchFlush()
{
    
}

void JiggleContent::Notify(void *pData)
{
    if(mTopTools)
    {
        mTopTools->Notify(pData);
    }
    
}


