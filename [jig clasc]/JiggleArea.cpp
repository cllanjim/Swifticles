//
//  JiggleArea.cpp
//  Jiggle
//
//  Created by Nick Raptis on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "JiggleArea.h"
#include "JigglePoint.h"
#include "JiggleZoomContainer.h"
#include "JiggleContent.h"
#include "ToolControls.h"
#include <sys/time.h>

JiggleArea *gJiggle = 0;
JiggleArea::JiggleArea()
{
    mName = "Jiggle Scene";
    
    gJiggle = this;
    
    mConsumesTouches = false;
    mEnabled = false;
    
    mTranslateX = 0.0f;
    mTranslateY = 0.0f;
    
    mImageWidth = ClosestPowerOfTwo((int)(gAppWidth + 0.5f));
    mImageHeight = ClosestPowerOfTwo((int)(gAppHeight + 0.5f));
    
    SetFrame(0.0f, 0.0f, gAppWidth, gAppHeight);
    
    mTargetAll=true;
    mRebind=false;
    
    mPanAndZoom = false;
    
    
    
    mRecordPreviewAutoSlow=false;
    mRecordPreviewAutoSlowTimer=0;
    
    
    mImage.Make(mImageWidth, mImageHeight, 0XFF484849);
    mImage.mWidth=((int)(gAppWidth + 0.5f));
    mImage.mHeight=((int)(gAppHeight + 0.5f));
    mImage.mExpandedWidth=mImageWidth;
    mImage.mExpandedHeight=mImageHeight;
    mImage.mFileName = "DEFAULT_JIGGLE_IMAGE";
    
    mTexture = new FTexture();
    mTexture->Load(&mImage);
    
    mSprite.Load(mTexture, 0, 0, (int)(gAppWidth + 0.5f), (int)(gAppHeight + 0.5f));
    
    
    
    
    mAnimationTime = 320;
    mAnimationFrame = 0;
    mAnimationTargetAll = false;
    
    mAnimationPlaying = true;
    
    mAnimationSlow = false;
    mAnimationSlowTick = 0;
    
    
    
    //if(gIsRetina)mSprite.mTextureRect.SetRect(, 0.0f, (float)gAppWidth * 2.0f, (float)gAppWidth * 2.0f);
    
    //else
    mSprite.mTextureRect.SetRect(0.0f, 0.0f, (int)(gAppWidth + 0.5f), (int)(gAppHeight + 0.5f));
    
    
    
    
    
    mDisplayImage = true;
    mFadeImage = true;
    
    mDisplayCenters = true;
    mDisplayMarkers = true;
    mDisplayGrid = true;
    mDisplayWeights = false;
    mDisplayAnimationMarkers = false;
    mDisplayEdgePercent = true;
    
    
    
    mLastSelected=0;
    mLastSelectedIncludingNull=0;
    
    mGlobalScale=1.0f;
    mGlobalTranslateX=0.0f;
    mGlobalTranslateY=0.0f;
    
    mGlobalScaleTarget=1.0f;
    mGlobalTranslateXTarget=0.0f;
    mGlobalTranslateYTarget=0.0f;
    
    mGlobalScaleStart=0.0f;
    mGlobalTranslateXStart=0.0f;
    mGlobalTranslateYStart=0.0f;
    
    mGlobalTranslateEdit=false;
    mGlobalScaleEdit=false;
    
    mRecordExportQuality=0;
    
    mImageOffsetX=0;
    mImageOffsetY=0;
    
    mMode = MODE_EDIT;
    
    mModeEdit = MODE_EDIT_AFFINE;
    mModeView = MODE_VIEW_TOUCH;
    mModeAnim = MODE_ANIM_PLAY;
    
    mGlobalScaleEdit=false;
    mGlobalTranslateEdit=false;
    
    mPanning=false;
    mPanStartX=0;
    mPanStartY=0;
    
    mPinching=false;
    mPinchStartScale=0;
    
    mRotating=false;
    mRotateStartRotation=0;
    
    mSelected=0;
    Deselect();
    
    mCurrentFileIndex=-1;
    mCurrentFileName="";
    
    RecordClear();
    
    
}

JiggleArea::~JiggleArea()
{
    printf("JiggleArea::~JiggleArea()\n");
    
    Save("jiggle.dat", 0);
    
    
    if(mTexture)
    {
        mSprite.Kill();
        mImage.Kill();
        mTexture->Unload();
        delete mTexture;
        mTexture = 0;
    }
    
    FreeList(JigglePoint, mKillList);
    FreeList(JigglePoint, mList);
}

void JiggleArea::DeleteAll()
{
    Deselect();
    mLastSelected=0;
    mLastSelectedIncludingNull=0;
    mSelected=0;
    
    mCurrentFileIndex=-1;
    
    EnumList(JigglePoint, aJiggle, mList)
    {
        aJiggle->mKillTimer=50;
        mKillList+=aJiggle;
    }
    
    mList.Clear();
    
    RecordClear();
}


void JiggleArea::SetUp(float pX, float pY, float pWidth, float pHeight)
{
    SetFrame(pX, pY, pWidth, pHeight);
    LoadXML(FString("jiggle.dat"));
}

JigglePoint *JiggleArea::SelectAny()
{
    if(mSelected)
    {
        if(mList.Exists(mSelected))return mSelected;
    }
    if(mLastSelected)
    {
        if(mList.Exists(mLastSelected))return mLastSelected;
    }
    if(mLastSelectedIncludingNull)
    {
        if(mList.Exists(mLastSelectedIncludingNull))return mLastSelectedIncludingNull;
    }
    if(mList.mCount > 0)
    {
        return (JigglePoint*)mList.Fetch(mList.mCount-1);
    }
    return 0;
}

void JiggleArea::SelectedSetJiggleSpeed(float pPercent)
{
    if(mTargetAll)
    {
        EnumList(JigglePoint, aJiggle, mList)
        {
            aJiggle->mMoveSpeedPercent=pPercent;
        }
    }
    else
    {
        JigglePoint *aJiggle = SelectAny();
        if(aJiggle)
        {
            aJiggle->mMoveSpeedPercent=pPercent;
        }
    }
}

void JiggleArea::SelectedSetJigglePower(float pPercent)
{
    if(mTargetAll)
    {
        EnumList(JigglePoint, aJiggle, mList)
        {
            aJiggle->mMovePowerPercent=pPercent;
        }
    }
    else
    {
        JigglePoint *aJiggle = SelectAny();
        if(aJiggle)
        {
            aJiggle->mMovePowerPercent=pPercent;
        }
    }
}

void JiggleArea::Select(JigglePoint* pSelect)
{
    EnumList(JigglePoint, aJiggle, mList)
    {
        aJiggle->mLine.mWidth=1.0f;
        aJiggle->mLine.mChanged=true;
    }
    if(pSelect == 0)
    {
        Deselect();
        return;
    }
    if(pSelect == mSelected)
    {
        
    }
    
    mSelected = pSelect;
    
    if(mSelected)
    {
        mSelected->mLine.mWidth=2.0f;
        mSelected->mLine.mChanged=true;
    }
    
    if(gTools)gTools->RefreshSelection(mSelected);
}

void JiggleArea::Deselect()
{
    if(mSelected)
    {
        
    }
    
    mSelected=0;
    
    EnumList(JigglePoint, aJiggle, mList)
    {
        aJiggle->mLine.mWidth=1.0f;
        aJiggle->mLine.mChanged=true;
        
    }
    
    if(gTools)gTools->RefreshSelection(mSelected);
}



void JiggleArea::DeleteSelected()
{
    if(mSelected)
    {
        mSelected->mKillTimer=50;
        mKillList+=mSelected;
        mList-=mSelected;
    }
    Deselect();
}

void JiggleArea::Update()
{
    
    if(mGlobalTranslateX != mGlobalTranslateXTarget || mGlobalTranslateY != mGlobalTranslateYTarget)
    {
        
        float aDiffX = mGlobalTranslateX - mGlobalTranslateXTarget;
        float aDiffY = mGlobalTranslateY - mGlobalTranslateYTarget;
        float aDist = aDiffX * aDiffX + aDiffY * aDiffY;
        
        if(aDist > 0.15f)
        {
            aDist = sqrtf(aDist);
            aDiffX /= aDist;
            aDiffY /= aDist;
            
            mGlobalTranslateY -= aDiffY * (aDist * 0.25f);
            mGlobalTranslateX -= aDiffX * (aDist * 0.25f);
            
        }
        else
        {
            mGlobalTranslateX=mGlobalTranslateXTarget;
            mGlobalTranslateY=mGlobalTranslateYTarget;
        }
    }
    
    float aDiff = mGlobalScale - mGlobalScaleTarget;
    
    if(aDiff <= 0.05f && aDiff >= -0.05f)
    {
        mGlobalScale = mGlobalScaleTarget;
    }
    else
    {
        mGlobalScale -= aDiff * 0.3f;
    }
    
    mDeleteList.mCount=0;
    EnumList(JigglePoint, aJiggle, mKillList)
    {
        if(aJiggle == mSelected)Deselect();
        aJiggle->mKillTimer--;
        if(aJiggle->mKillTimer <= 0)
        {
            mDeleteList+=aJiggle;
        }
    }
    
    EnumList(JigglePoint, aJiggle, mDeleteList)
    {
        mKillList -= aJiggle;
        delete aJiggle;
    }
    
    if(mMode == MODE_VIEW)
    {
        EnumList(JigglePoint, aJiggle, mList)
        {
            if(mSelected == aJiggle)
            {
                aJiggle->mHolding = true;
            }
        }
    }
    
    EnumList(JigglePoint, aJiggle, mList)
    {
        aJiggle->Update();
    }
    
    
    
    
    bool aAnimate = false;
    if(mMode == MODE_ANIM)
    {
        //if(mModeAnim != MODE_ANIM_GUIDE)
        //{
        aAnimate = true;
        
        //}
    }
    if(aAnimate)
    {
        if(mAnimationPlaying == true)
        {
            
            if(mAnimationSlow == true)
            {
                mAnimationSlowTick++;
                
                if(mAnimationSlowTick > 8)
                {
                    mAnimationSlowTick = 0;
                    mAnimationFrame++;
                }
                
                
            }
            else
            {
                mAnimationFrame++;
            }
            
            
        }
        
        
        
        
        if(mAnimationFrame >= mAnimationTime)
        {
            mAnimationFrame = 0;
        }
        
        EnumList(JigglePoint, aJiggle, mList)
        {
            //aJiggle->AnimationRefresh(mAnimationFrame, mAnimationTime);
            
            aJiggle->AnimationUpdate(mAnimationFrame, mAnimationTime);
            
            //aJiggle->AnimationOn();
        }
    }
    else
    {
        EnumList(JigglePoint, aJiggle, mList)
        {
            aJiggle->AnimationCancel();
        }
    }
    
    
    
    if(mLastSelectedIncludingNull != mSelected)
    {
        //Todo
        //UpdateSelected();
    }
    
    if(mSelected)
    {
        mLastSelected=mSelected;
    }
    
    mLastSelectedIncludingNull=mSelected;
    
}

void JiggleArea::Draw()
{
    
    //Graphics::Translate(-mWidth2, -mHeight2, 0.0f);
    Graphics::Translate(mGestureTranslateX, mGestureTranslateY, 0);
    
    
    //Graphics::SetColor(0.4f, 0.7f, 0.9f, 0.25f);
    //Graphics::DrawRect(0, 0, mWidth, mHeight);
    //Graphics::SetColor(0.4f, 0.7f, 0.9f);
    //Graphics::OutlineRect(0.0f, 0.0f, mWidth, mHeight, 16);
    
    //Graphics::SetColor(1.0f, 1.0f, 0.0f);
    //Graphics::DrawPoint(mTouchX, mTouchY, 22);
    
    
    Graphics::SetColor();
    
    if(mRecordExporting)
    {
        
    }
    else if(mRecordMode)
    {
        if(mRecordPreviewAutoPlay)
        {
            if(mRecordPreviewAutoSlow)
            {
                mRecordPreviewAutoSlowTimer++;
                if(mRecordPreviewAutoSlowTimer >= 4)
                {
                    mRecordPreviewAutoSlowTimer=0;
                    mRecordFrame++;
                }
            }
            else mRecordFrame++;
        }
        if(mRecordFrame < 0 || mRecordFrame >= mRecordFrameCount)mRecordFrame=0;
    }
    else if(mRecording)
    {
        EnumList(JigglePoint, aPoint, mList)
        {
            aPoint->SaveCurrentState();
        }
        mRecordFrameCount++;
    }
    
    
    
    if(mRecording || mRecordMode || mRecordExporting)
    {
        //UpdateRecordingInfo(mRecordFrameCount);
        
    }
    
    
    
    
    
    
    //Clip(0,0,gAppWidth,gAppHeight);
    EnumList(JigglePoint, aJiggle, mAddList)
    {
        mList.Add(aJiggle);
    }
    mAddList.mCount=0;
    
    
    glDisable(GL_CULL_FACE);
    
    if(mRebind)
    {
        Graphics::TextureSetData(mSprite.mTexture->mBindIndex, mImage.mData, mImage.mExpandedWidth, mImage.mExpandedHeight);
        //mImage.Rebind();
        mRebind=false;
    }
    
    Graphics::SetColor();
    
    //mSprite.Center(gAppWidth2,gAppHeight2);
    mSprite.DrawQuad(0.0f, 0.0f, mWidth, mHeight);
    
    
    //Graphics::SetColor(1.0f, 0.0f, 0.0f, 1.0f);
    //Graphics::OutlineRect(0.0f, 0.0f, mWidth, mHeight, 2.0f);
    //Graphics::SetColor();
    
    
    glShadeModel(GL_SMOOTH);
    Graphics::CullFacesDisable();
    Graphics::DepthEnable();
    
    //glEnable(GL_DEPTH_TEST);
    //glDepthFunc(GL_LEQUAL);
    //glDepthMask(GL_TRUE);
    
    Graphics::TextureSetClamp();
    Graphics::DepthClear();
    
    
    EnumList(JigglePoint, aJiggle, mList)
    {
        aJiggle->Draw();
    }
    
    if(mMode == MODE_VIEW)
    {
        
    }
    
    Graphics::DepthDisable();
    
    if(mMode != MODE_VIEW)
    {
        EnumList(JigglePoint, aJiggle, mList)
        {
            bool aSelected = (aJiggle == mSelected);
            aJiggle->DrawMarkers(aSelected, (aSelected ? 0.75f : 0.25f));
        }
    }
    else
    {
        
    }
    
    
    EnumList(JigglePoint, aJiggle, mList)
    {
        aJiggle->DrawCenters();
    }
    
    
    if(mDisplayGrid)
    {
        EnumList(JigglePoint, aJiggle, mList)
        {
            if(aJiggle != mSelected)aJiggle->DrawGrid();
        }
        EnumList(JigglePoint, aJiggle, mList)
        {
            if(aJiggle == mSelected)aJiggle->DrawGrid();
        }
    }
    
    if((mDisplayAnimationMarkers == true) || (mMode == MODE_ANIM))
    {
        EnumList(JigglePoint, aJiggle, mList)
        {
            //if(aJiggle != mSelected)
            aJiggle->DrawAnimMarkers(false, 0.65f);
        }
    }
    
    //    bool aAnimate = false;
    //    if(mMode == MODE_ANIM)
    //    {
    //        //if(mModeAnim != MODE_ANIM_GUIDE)
    //        //{
    //        aAnimate = true;
    //
    //        //}
    //    }
    //    if(aAnimate)
    //    {
    //        mAnimationFrame++;
    //        if(mAnimationFrame >= mAnimationTime)
    //        {
    //            mAnimationFrame = 0;
    //        }
    //
    //        EnumList(JigglePoint, aJiggle, mList)
    //        {
    //            aJiggle->AnimationRefresh(mAnimationFrame, mAnimationTime);
    //            aJiggle->AnimationUpdate(mAnimationFrame, mAnimationTime);
    //
    //            //aJiggle->AnimationOn();
    //        }
    //    }
    //    else
    //    {
    //        EnumList(JigglePoint, aJiggle, mList)
    //        {
    //            aJiggle->AnimationCancel();
    //        }
    //    }
    
    /*
     SetColor(0,1,0.25f);
     
     
     Spline aSpline;
     
     float aScale=1.0f;
     
     for(int aIteration=0;aIteration<1;aIteration++)
     {
     aSpline.Add(-20.0f * aScale, -20.0f * aScale);
     aSpline.Add( 20.0f * aScale, -20.0f * aScale);
     
     aSpline.Add( 30.0f * aScale, 50.0f * aScale);
     aSpline.Add( 0.0f, 70.0f * aScale);
     aSpline.Add( -30.0f * aScale, 50.0f * aScale);
     }
     
     aSpline.SetClosed(true);
     
     for(float k=0.0f;k<=aSpline.Max();k+=0.1f)
     {
     float aX,aY;
     aSpline.Get(k, aX, aY);
     
     aX += gAppWidth2;
     aY += gAppHeight2;
     
     DrawRect(aX-1, aY-1, 3, 3);
     }
     */
    
    
    //    for(float i=0;i<300;i+=5)
    //    {
    //        for(float n=0;n<300;n+=5)
    //        {
    //            EnumList(JigglePoint, aJiggle , mList)
    //            {
    //                if(aJiggle->ContainsPoint(i, n))
    //                {
    //                    SetColor(1,0,0,0.5f);
    //                    DrawRect(i,n,5,5);
    //                }
    //                else
    //                {
    //
    //                }
    //            }
    //        }
    //    }
    
    /*
     Graphics::SetColor(0.5f, 0.25f, 1.0f, 1.0f);
     Graphics::DrawPoint(mMouseX, mMouseY, 20.0f);
     Graphics::SetColor(1.0f, 0.0f, 0.0f, 1.0f);
     Graphics::DrawPoint(mMouseX, mMouseY, 14.0f);
     */
    
    
    /*
     DrawTransform();
     Graphics::SetColor(0.25f, 0.25f, 1.0f, 1.0f);
     Graphics::OutlineRect(2.0f, 2.0f, mWidth - 4.0f, mHeight - 4.0f, 2.0f);
     */
    
    
    
    
    Graphics::Translate(-mGestureTranslateX, -mGestureTranslateY, 0);
    //Graphics::Translate(mWidth2, mHeight2, 0.0f);
    //Graphics::Translate(-mTranslateX, -mTranslateY, 0.0f);
    
}

void JiggleArea::Touch(int x, int y)
{
    
    if((mRecordMode==true)||(mRecordExporting==true))return;
    
    if(mMode == MODE_VIEW)
    {
        if(mModeView == MODE_VIEW_TOUCH)
        {
            if(mSelected == 0)
            {
                Select(GetClosest(x, y));
            }
        }
    }
    
    
}

void JiggleArea::Drag(int x, int y)
{
    
    if((mRecordMode==true)||(mRecordExporting==true))return;
    
    /*
     if(mSelected)
     {
     //printf("Setting X, Y to [%d, %d]\n", x, y);
     //mSelected->mX = x;
     //mSelected->mY = y;
     }
     if(mSplineEditing)
     {
     EnumList(JigglePoint, aJiggle, mList)
     {
     aJiggle->Drag(x, y);
     }
     }
     else
     {
     EnumList(JigglePoint, aJiggle, mList)
     {
     aJiggle->KillTouches();
     }
     }
     */
    
    if(mMode == MODE_EDIT)
    {
        if(mModeEdit == MODE_EDIT_CENTER)
        {
            if(mSelected)
            {
                mSelected->SetCenter(x,y);
            }
        }
    }
    
}

void JiggleArea::Release(int x, int y)
{
    mPanning = false;
    mRotating = false;
    mPinching = false;
    
    if(mMode == MODE_VIEW)
    {
        if(mModeView == MODE_VIEW_TOUCH)
        {
            Deselect();
        }
    }
    
    EnumList(JigglePoint, aJiggle, mList)
    {
        aJiggle->FlushMultiTouch();
    }
    
    /*
     
     
     if(mSplineEditing)
     {
     EnumList(JigglePoint, aJiggle, mList)
     {
     aJiggle->Release(x, y);
     }
     }
     else
     {
     EnumList(JigglePoint, aJiggle, mList)
     {
     aJiggle->KillTouches();
     }
     }
     */
}

void JiggleArea::MultiTouch(int x, int y, void *pData)
{
    if((mRecordMode==true)||(mRecordExporting==true))return;
    
    //printf("Multi-Touch [%x]\n", pData);
    EnumList(JigglePoint, aJiggle, mList)
    {
        aJiggle->mSplineDragging=false;
    }
    
    if(mMode == MODE_EDIT)
    {
        Deselect();
        
        //
        
        
        if(mModeEdit == MODE_EDIT_AFFINE)
        {
            Select(GetClosest(x, y));
        }
        
        
        if(mModeEdit == MODE_EDIT_CENTER)
        {
            float aBestDist = 100 * 100;
            float aDist;
            EnumList(JigglePoint,aJiggle,mList)
            {
                aDist = aJiggle->DistToCenter(x, y);
                if(aDist < aBestDist)
                {
                    aBestDist = aDist;
                    Select(aJiggle);
                    
                }
            }
            
            
            
            if(!mSelected)
            {
                Select(GetClosest(x, y));
            }
            
            if(mSelected)
            {
                mSelected->SetCenter(x,y);
            }
        }
        
        
        if(mModeEdit == MODE_EDIT_SHAPE)
        {
            
            Deselect();
            
            float aBestDist = 100 * 100;
            float aDist;
            EnumList(JigglePoint, aJiggle, mList)
            {
                
                aJiggle->mTouch=0;
                
                aDist = aJiggle->ClosestControlPoint(x, y);
                
                if(aDist < aBestDist)
                {
                    Select(aJiggle);
                    aBestDist=aDist;
                }
            }
            
            if(mSelected)
            {
                float aX = mSelected->mSplineBase.GetX(mSelected->mSplineTouchIndex);
                float aY = mSelected->mSplineBase.GetY(mSelected->mSplineTouchIndex);
                
                mSelected->Untransform(aX, aY, aX, aY);
                
                mSelected->mPointDragStartX = aX - x;
                mSelected->mPointDragStartY = aY - y;
                
                mSelected->mSplineDragging=true;
                mSelected->mTouch=pData;
                mSelected->MultiDrag(x, y, pData);
            }
        }
    }
    
    
    
    if(mMode == MODE_VIEW)
    {
        if(mModeView == MODE_VIEW_TOUCH)
        {
            JigglePoint *aPoint = GetClosest(x, y, 10);
            if(aPoint)
            {
                if(aPoint->mTouch == 0 || aPoint->mTouch2 == 0)
                {
                    int aTouchCount = 0;
                    
                    
                    if(aPoint->mTouch || aPoint->mTouch2)aTouchCount=2;
                    
                    if(aPoint->mTouch == 0)
                    {
                        aPoint->mTouchX1=x;
                        aPoint->mTouchY1=y;
                        aPoint->mTouch = pData;
                    }
                    else
                    {
                        aPoint->mTouchX2=x;
                        aPoint->mTouchY2=y;
                        aPoint->mTouch2 = pData;
                    }
                    
                    if(aTouchCount == 2)
                    {
                        x = (aPoint->mTouchX1 + aPoint->mTouchX2) / 2;
                        y = (aPoint->mTouchY1 + aPoint->mTouchY2) / 2;
                    }
                    
                    
                    
                    
                    
                    
                    aPoint->mHolding = true;
                    
                    //if(aTouchCount == 1)
                    //{
                    
                    //aPoint->mNippleX = 0;
                    //aPoint->mNippleY = 0;
                    
                    aPoint->mTouchStartX = aPoint->mNippleX;
                    aPoint->mTouchStartY = aPoint->mNippleY;
                    //}
                    
                    
                    aPoint->mTouchStartMouseX = x;
                    aPoint->mTouchStartMouseY = y;
                    
                    
                    //aPoint->mNippleX = (float)x - aPoint->mX;
                    //aPoint->mNippleY = (float)y - aPoint->mY;
                    
                    aPoint->mNippleSpeedX = 0;
                    aPoint->mNippleSpeedY = 0;
                }
            }
        }
    }
}

void JiggleArea::MultiDrag(int x, int y, void *pData)
{
    
    if((mRecordMode==true)||(mRecordExporting==true))return;
    
    //for(int i=0;i<10;i++)
    //{
    //Sparkle *aSparkle = new Sparkle();
    //aSparkle->mPos = FPoint(x, y);
    //mSparkleList += aSparkle;
    //}
    
    if(mMode == MODE_EDIT)
    {
        if(mModeEdit == MODE_EDIT_SHAPE)
        {
            if(mSelected)
            {
                mSelected->MultiDrag(x, y, pData);
            }
        }
    }
    
    if(mMode == MODE_VIEW)
    {
        
        
        if(mModeView == MODE_VIEW_TOUCH)
        {
            EnumList(JigglePoint, aPoint, mList)
            {
                if(aPoint->mTouch==pData || aPoint->mTouch2==pData)
                {
                    
                    
                    int aTouchCount = 0;
                    
                    if(aPoint->mTouch && aPoint->mTouch2)aTouchCount=2;
                    
                    if(aPoint->mTouch == pData)
                    {
                        aPoint->mTouchX1=x;
                        aPoint->mTouchY1=y;
                    }
                    else
                    {
                        aPoint->mTouchX2=x;
                        aPoint->mTouchY2=y;
                    }
                    
                    
                    if(aTouchCount == 2)
                    {
                        x = (aPoint->mTouchX1 + aPoint->mTouchX2) / 2;
                        y = (aPoint->mTouchY1 + aPoint->mTouchY2) / 2;
                    }
                    
                    
                    aPoint->SetHoldNipple(aPoint->mTouchStartX - (aPoint->mTouchStartMouseX - x),
                                          aPoint->mTouchStartY - (aPoint->mTouchStartMouseY - y));
                    
                    aPoint->mNippleSpeedX = 0;
                    aPoint->mNippleSpeedY = 0;
                }
            }
        }
    }
}

void JiggleArea::MultiRelease(int x, int y, void *pData)
{
    EnumList(JigglePoint, aPoint, mList)
    {
        aPoint->MultiRelease(x, y, pData);
    }
    
    EnumList(JigglePoint, aJiggle, mList)
    {
        aJiggle->mSplineDragging=false;
    }
    
    EnumList(JigglePoint, aPoint, mList)
    {
        if(aPoint->mTouch==pData || aPoint->mTouch2==pData)
        {
            aPoint->mTouch2=0;
            aPoint->mTouch=0;
            aPoint->mHolding=false;
            
        }
    }
}



void JiggleArea::FlushMultiTouch()
{
    EnumList(JigglePoint, aPoint, mList)
    {
        aPoint->FlushMultiTouch();
        aPoint->mTouch=0;
        aPoint->mHolding=false;
    }
}

bool JiggleArea::AllowAction()
{
    if(mRecordExporting == true)return false;
    if(mPanAndZoom == true)return false;
    
    
    
    
    return true;
}

void JiggleArea::Accelerometer(float x, float y, float z, bool pReverse)
{
    EnumList(JigglePoint, aPoint, mList)
    {
        aPoint->Accelerometer(x, y, z, pReverse);
    }
}


void JiggleArea::SamplePoint(float x, float y, float &u, float &v)
{
    u = (float)(x + mTexture->mOffsetX) / (float)mImageWidth;
    v = (float)(y + mTexture->mOffsetY) / (float)mImageHeight;
    
    /*
     if(gIsRetina)
     {
     for(int i=0;i<mTri.mCount;i++)
     {
     int aXIndex = mTri.mX[i];int aYIndex = mTri.mY[i];
     float aU, aV;
     gJiggle->SamplePointRetina(mTriGridAffineX[aXIndex][aYIndex]+mX, mTriGridAffineY[aXIndex][aYIndex]+mY, aU, aV);
     mVBuffer.AddUV(aU, aV);
     }
     }
     else
     {
     for(int i=0;i<mTri.mCount;i++)
     {
     int aXIndex = mTri.mX[i];int aYIndex = mTri.mY[i];
     float aU, aV;
     gJiggle->SamplePoint(mTriGridAffineX[aXIndex][aYIndex]+mX, mTriGridAffineY[aXIndex][aYIndex]+mY, aU, aV);
     mVBuffer.AddUV(aU, aV);
     }
     }
     */
    
    
}

/*
 void JiggleArea::SamplePointRetina(float x, float y, float &u, float &v)
 {
 u = (float)((x * 2.0f) + mTexture->mOffsetX) / (float)mImageWidth;
 v = (float)((y * 2.0f) + mTexture->mOffsetY) / (float)mImageHeight;
 }
 */


void JiggleArea::SetImage(FImage *pImage)
{
    if(!pImage)return;
    
}

void JiggleArea::SetImage(unsigned int *pData, int pWidth, int pHeight)
{
    DeleteAll();
    
    //mWidth=pWidth;
    //mHeight=pHeight;
    
    //mOffsetX = IMAGE_SIZE / 2 - pWidth / 2;
    //mOffsetY = IMAGE_SIZE / 2 - pHeight / 2;
    
    //mImageOffsetX = IMAGE_SIZE / 2 - pWidth / 2;
    //mImageOffsetY = IMAGE_SIZE / 2 - pHeight / 2;
    
    //mOffsetX = 0;
    //mOffsetY = 0;
    
    //mImageOffsetX = 0;
    //mImageOffsetY = 0;
    
    //mImage.mOffsetX = 0;
    //mImage.mOffsetY = 0;
    
    FImage aImage;
    aImage.mData = pData;
    aImage.mWidth = pWidth;aImage.mExpandedWidth = pWidth;
    aImage.mHeight = pHeight;aImage.mExpandedHeight = pHeight;
    
    
    
    mImage.Stamp(&aImage, mTexture->mOffsetX + (int)((float)(mWidth2 - (aImage.mWidth / 2)) + 0.5f), mTexture->mOffsetY, 0, 0, pWidth, pHeight);
    //mImage.Stamp(<#FImage *pImage#>, <#int x#>, <#int y#>, <#int pImageX#>)
    //mSprite.Load(&mImage, mOffsetX, mOffsetY, pWidth, pHeight);
    
    aImage.mData = 0;
    aImage.mWidth = 0;aImage.mExpandedWidth = 0;
    aImage.mHeight = 0;aImage.mExpandedHeight = 0;
    
    mImage.mOffsetX = mImageOffsetX;
    mImage.mOffsetY = mImageOffsetY;
    
    mStartU=(float)(mTexture->mOffsetX)/(float)mImageWidth;
    mStartV=(float)(mTexture->mOffsetY)/(float)mImageHeight;
    
    mEndU=(float)(mTexture->mOffsetX+pWidth)/(float)mImageWidth;
    mEndV=(float)(mTexture->mOffsetY+pHeight)/(float)mImageHeight;
    
    mSprite.mTextureRect.SetRect(0, 0,((int)(gAppWidth)), ((int)(gAppHeight)));
    
    mRebind=true;
    
    
    mSelected=0;
    mLastSelected=0;
    mLastSelectedIncludingNull=0;
    
    EnumList(JigglePoint, aPoint, mList)
    {
        aPoint->mHolding=false;
    }
}

void JiggleArea::AddPoint(int pType)
{
    JigglePoint *aPoint = new JigglePoint();
    
    aPoint->mJiggleArea = this;
    aPoint->mTexture = mTexture;
    
    bool aHit=true;
    for(int i=0;(i<10)&&(aHit==true);i++)
    {
        aHit=false;
        EnumList(JigglePoint, aJiggle, mList)
        {
            if(aJiggle->mX == aPoint->mX && aJiggle->mY == aPoint->mY)aHit=true;
        }
        if(aHit)aPoint->mX += 35.0f;
    }
    
    //aPoint->ResetCircle(9);
    
    
    mAddList += aPoint;
    aPoint->mFreshTimer=35;
    Select(aPoint);
    
    aPoint->SolveSpline();
    aPoint->UpdateAffine();
    aPoint->CalcDistances();
    aPoint->MeshSpline();
}

JigglePoint *JiggleArea::GetClosest(int x, int y, float pDist)
{
    JigglePoint *aReturn=0;
    float aDiffX, aDiffY, aDist, aBestDist;
    
    FList aHitList;
    EnumList(JigglePoint, aJiggle, mList)
    {
        if(aJiggle->ContainsPoint(x, y))
        {
            aHitList += aJiggle;
        }
    }
    
    float aX, aY;
    
    if(aHitList.mCount == 1)
    {
        aReturn=(JigglePoint*)aHitList.Fetch(0);
    }
    else if(aHitList.mCount > 1)
    {
        aBestDist = 1024.0f * 1024.0f;
        EnumList(JigglePoint, aJiggle, aHitList)
        {
            aJiggle->Transform(x, y, aX, aY);
            
            aDiffX = aX - aJiggle->mX;
            aDiffY = aY - aJiggle->mY;
            
            aDist = aDiffX * aDiffX + aDiffY * aDiffY;
            
            if(aDist < aBestDist)
            {
                aBestDist = aDist;
                aReturn = aJiggle;
            }
        }
    }
    else
    {
        aBestDist = 100.0f;
        EnumList(JigglePoint, aJiggle, mList)
        {
            aJiggle->Transform(x, y, aX, aY);
            
            aDiffX = aX - aJiggle->mX;
            aDiffY = aY - aJiggle->mY;
            
            aDist = aJiggle->DistanceToPoint(x,y);
            
            if(aDist < aBestDist)
            {
                aBestDist = aDist;
                aReturn = aJiggle;
            }
        }
    }
    
    return aReturn;
    
}



void JiggleArea::PanAndZoomSet(bool pState)
{
    
    if(pState == false)
    {
        
        
        mPanAndZoom = false;
        
        
    }
    else
    {
        KillGestures();
        
        if(gJiggleContainer != 0)
        {
            gJiggleContainer->ClearGestures(true);
        }
        
        KillGestures();
        mPanAndZoom = true;
    }
    
}

void JiggleArea::SetMode(int pMode)
{
    
    
    
    if(((mMode == MODE_VIEW) != (pMode == MODE_VIEW)) || ((mModeView == MODE_ANIM) != (pMode == MODE_ANIM)))
    {
        
        if((mMode == MODE_VIEW) || (mMode == MODE_ANIM))
        {
            
        }
        else
        {
            Deselect();
        }
    }
    
    
    
    
    
    
    
    //PinchBegin
    
    PanEnd(0.0f, 0.0f, 0.0f, 0.0f);
    PinchEnd(1.0f);
    RotateEnd(0.0f);
    
    mMode = pMode;
    
    if(mMode != MODE_VIEW)
    {
        EnumList(JigglePoint, aJiggle, mList)
        {
            aJiggle->Reset();
        }
    }
    
    EnumList(JigglePoint, aJiggle, mList)
    {
        aJiggle->MeshSpline();
    }
    
    
    
    
    
}

void JiggleArea::SetMode(int pMode, int pSubmode)
{
    SetMode(pMode);
    
    if(mMode == MODE_VIEW)
    {
        mModeView = pSubmode;
    }
    
    if(mMode == MODE_EDIT)
    {
        mModeEdit = pSubmode;
    }
    
    
    if(mMode == MODE_ANIM)
    {
        mModeAnim = pSubmode;
    }
    
    
    
    
    
}

void JiggleArea::KillGestures()
{
    if(mPanning)
    {
        
        PanEnd(mPanStartX, mPanStartY, 0.0f, 0.0f);
    }
    else
    {
        PanEnd(0.0f, 0.0f, 0.0f, 0.0f);
    }
    PinchEnd(1.0f);
}

SavedJiggle *JiggleArea::FetchList(int pIndex)
{
    return ((SavedJiggle*)gApp->mSavedList.Fetch((gApp->mSavedList.mCount - pIndex) - 1));
}

SavedJiggle *JiggleArea::FetchJiggle(int pIndex)
{
    SavedJiggle *aReturn = 0;
    
    EnumList(SavedJiggle, aJiggle, gApp->mSavedList)
    {
        if(aJiggle->mIndex == pIndex)
        {
            aReturn = aJiggle;
        }
    }
    return aReturn;
}


void JiggleArea::Save(FString pName, int pIndex, const char *pAutoSaveName)
{
    if(pName.mLength <= 0)pName = "Auto Save";
    
    FXML aXML;
    FXMLTag *aRoot=new FXMLTag();
    
    aRoot->SetName("jiggle_file");
    aRoot->AddParam("target_all", FString(mTargetAll).c());
    aRoot->AddParam("mode", FString(mMode).c());
    aRoot->AddParam("mode_edit", FString(mModeEdit).c());
    aRoot->AddParam("mode_view", FString(mModeView).c());
    aRoot->AddParam("selected_index", FString(mList.Find(mSelected)).c());
    
    
    
    
    
    
    FString aBoolStr[2];
    aBoolStr[0] = "false";
    aBoolStr[1] = "true";
    
    FXMLTag *aDisplayTag = new FXMLTag();
    *aRoot += aDisplayTag;
    aDisplayTag->SetName("display_data");
    aDisplayTag->AddTag("fade_img", aBoolStr[mFadeImage].c());
    aDisplayTag->AddTag("display_img", aBoolStr[mDisplayImage].c());
    aDisplayTag->AddTag("display_centers", aBoolStr[mDisplayCenters].c());
    aDisplayTag->AddTag("display_markers", aBoolStr[mDisplayMarkers].c());
    aDisplayTag->AddTag("display_grid", aBoolStr[mDisplayGrid].c());
    aDisplayTag->AddTag("display_weights", aBoolStr[mDisplayWeights].c());
    aDisplayTag->AddTag("display_animation_markers", aBoolStr[mDisplayAnimationMarkers].c());
    
    
    
    
    
    FXMLTag *aZoomContainerTag = gJiggleContainer->SaveXML();
    *aRoot += aZoomContainerTag;
    
    FXMLTag *aJigglesTag = new FXMLTag();
    aJigglesTag->SetName("jiggle_point_list");
    *aRoot += aJigglesTag;
    
    EnumList(JigglePoint, aJiggle, mList)
    {
        FXMLTag *aJiggleTag = aJiggle->SaveXML();
        *aJigglesTag += aJiggleTag;
        
        //aJiggle->SaveXML(aJiggleTag);
        
        /*
         
         FXMLTag *aJiggleTag=new FXMLTag();
         *aJigglesTag += aJiggleTag;
         
         aJiggle->SaveXML(aJiggleTag);
         
         aJiggleTag->SetName("jiggle_point");
         aJiggleTag->AddTag("x", FString(FloatToInt(aJiggle->mX)).c());
         aJiggleTag->AddTag("y", FString(FloatToInt(aJiggle->mY)).c());
         aJiggleTag->AddTag("scale", FString(FloatToInt(aJiggle->mScale)).c());
         aJiggleTag->AddTag("rotation", FString(FloatToInt(aJiggle->mRotation)).c());
         aJiggleTag->AddTag("speed", FString(FloatToInt(aJiggle->mMoveSpeedPercent)).c());
         aJiggleTag->AddTag("power", FString(FloatToInt(aJiggle->mMovePowerPercent)).c());
         aJiggleTag->AddTag("bulge_index", FString(aJiggle->mBulgeIndex).c());
         
         
         //aJiggleTag->AddTag("continuous_mode", FString((int)(aJiggle->mContinuousMode)).c());
         //aJiggleTag->AddTag("continuous_touch", FString((int)(aJiggle->mContinuousDidTouch)).c());
         //aJiggleTag->AddTag("continuous_x", FString(FloatToInt(aJiggle->mContinuousStartX)).c());
         //aJiggleTag->AddTag("continuous_y", FString(FloatToInt(aJiggle->mContinuousStartY)).c());
         //aJiggleTag->AddTag("continuous_sin", FString(FloatToInt(aJiggle->mContinuousSin)).c());
         
         
         FXMLTag *aSplineTag = new FXMLTag();
         aSplineTag->SetName("spline");
         *aJiggleTag += aSplineTag;
         
         
         for(int i=0;i<aJiggle->mSplineBase.mPointCount;i++)
         {
         FXMLTag *aControlPointTag=new FXMLTag();
         
         aControlPointTag->SetName("control_point");
         
         *aSplineTag += aControlPointTag;
         
         aControlPointTag->AddParamSafeFloat("x", aJiggle->mSplineBase.mX[i]);
         aControlPointTag->AddParamSafeFloat("y", aJiggle->mSplineBase.mY[i]);
         
         }
         */
    }
    
    aXML.mRoot = aRoot;
    
    
    if(pAutoSaveName == 0)
    {
        aXML.Save(gDirDocuments + pName);
        mCurrentFileIndex = pIndex;
    }
    else
    {
        aXML.Save(gDirDocuments + "auto_save.xml");
    }
}

void JiggleArea::LoadDemo(int pIndex)
{
    mCurrentFileIndex=-1;
    
    FString aXMLPath = gDirBundle + FString("example") + FString(pIndex) + FString("_");
    
    if(gIsLargeScreen)
    {
        aXMLPath += "ipad.xml";
    }
    else
    {
        aXMLPath += "iphone.xml";
    }
    
    LoadXML(aXMLPath);
    
}

void JiggleArea::SaveAuto()
{
    Save("auto_save", -1, "auto_save.xml");
}

void JiggleArea::LoadAuto()
{
    mCurrentFileIndex=-1;
    FString aXMLPath = gDirDocuments + FString("auto_save.xml");
    LoadXML(aXMLPath);
}

void JiggleArea::Load(int pIndex)//String pName)
{
    mCurrentFileIndex=pIndex;
    FString aXMLPath = gDirDocuments + FString("saved_jiggle_") + FString(pIndex) + FString(".xml");
    LoadXML(aXMLPath);
}

void JiggleArea::LoadXML(FString pPath)
{
    EnumList(JigglePoint, aJiggle, mList)
    {
        aJiggle->mKillTimer = 50;
        mKillList += aJiggle;
    }
    
    mList.Clear();
    
    FXML aXML;
    aXML.Load(pPath);
    FXMLTag *aRootTag = aXML.GetRoot();
    
    if(aRootTag)
    {
        mTargetAll = FString(aRootTag->GetParamValue("target_all", "false")).ToBool();
        
        mMode = aRootTag->GetParamInt("mode", 0);
        mModeEdit = aRootTag->GetParamInt("mode_edit", 0);
        mModeView = aRootTag->GetParamInt("mode_view", 0);
        
        int aSelectedIndex = aRootTag->GetParamInt("selected_index", -1);
        
        
        
        EnumTagsMatching(aRootTag, aDisplayTag, "display_data")
        {
            mFadeImage = aRootTag->GetParamBool("fade_img", "false");
            mDisplayImage = aRootTag->GetParamBool("display_markers", "true");
            mDisplayCenters = aRootTag->GetParamBool("display_centers", "false");
            mDisplayMarkers = aRootTag->GetParamBool("mode_edit", "false");
            mDisplayGrid = aRootTag->GetParamBool("display_grid", "false");
            mDisplayWeights = aRootTag->GetParamBool("display_weights", "false");
            mDisplayAnimationMarkers = aRootTag->GetParamBool("display_animation_markers", "false");
            
        }
        
        
        
        if(gJiggleContainer)
        {
            EnumTagsMatching(aRootTag, aZoomContainerTag, "jiggle_container")
            {
                gJiggleContainer->LoadXML(aZoomContainerTag);
            }
        }
        
        
        
        
        JigglePoint *aSelected = 0;
        
        
        
        int aJiggleIndex = 0;
        EnumTagsMatching(aRootTag, aJigglePointListTag, "jiggle_point_list")
        {
            EnumTagsMatching(aJigglePointListTag, aJigglePointTag, "jiggle_point")
            {
                JigglePoint *aJiggle = new JigglePoint();
                aJiggle->mJiggleArea = this;
                aJiggle->mTexture = mTexture;
                
                aJiggle->mSplineBase.Reset();
                
                aJiggle->LoadXML(aJigglePointTag);
                
                mAddList += aJiggle;
                
                if(aJiggleIndex == aSelectedIndex)
                {
                    aSelected = aJiggle;
                    
                }
                
                aJiggleIndex++;
            }
        }
        
        if(aSelected != 0)Select(aSelected);
        
    }
}

void JiggleArea::CheckGestures()
{
    
}

void JiggleArea::PanBegin(float x, float y)
{
    FGestureView::PanEnd(x, y, 0, 0);
    
    if((mRecordMode==true)||(mRecordExporting==true))return;
    
    if(mMode == MODE_EDIT)
    {
        if(mModeEdit == MODE_EDIT_AFFINE)
        {
            if(mSelected)
            {
                mPanning=true;
                mPanStartX = (mSelected->mX - x);
                mPanStartY = (mSelected->mY - y);
            }
            
            mGlobalTranslateXStart = mGlobalTranslateX;
            mGlobalTranslateYStart = mGlobalTranslateY;
            mGlobalTranslateXTarget = mGlobalTranslateXStart;
            mGlobalTranslateYTarget = mGlobalTranslateYStart;
            mGlobalTranslateEdit=true;
        }
    }
}

void JiggleArea::PanEnd(float pX, float pY, float pSpeedX, float pSpeedY)
{
    mPanning=false;
    mGlobalTranslateEdit=false;
}

void JiggleArea::PinchBegin(float pScale)
{
    PinchEnd(1.0f);
    
    if((mRecordMode==true)||(mRecordExporting==true))return;
    
    if(mMode == MODE_EDIT)
    {
        if(mModeEdit == MODE_EDIT_AFFINE)
        {
            if(mSelected)
            {
                mPinching=true;
                mPinchStartScale=mSelected->mScale;
            }
            
            
            mGlobalScaleEdit=true;
            mPinching=true;
            mGlobalScaleStart = mGlobalScale;
            mGlobalScaleTarget = mGlobalScaleStart;
        }
    }
}

void JiggleArea::PinchEnd(float pScale)
{
    mPinching=false;
    mGlobalScaleEdit=false;
}

void JiggleArea::RotateStart(float pRotation)
{
    RotateEnd(0.0f);
    
    
    if((mRecordMode==true)||(mRecordExporting==true))return;
    
    //if(mMode == MODE_EDIT || mMode == MODE_VIEW)
    //{
    if(mSelected)
    {
        mRotateStartRotation=mSelected->mRotation;
        mRotating=true;
    }
    //}
}

void JiggleArea::RotateEnd(float pDegrees)
{
    mRotating=false;
}


void JiggleArea::Pan(float x, float y)
{
    if((mRecordMode==true)||(mRecordExporting==true))return;
    
    if(mMode == MODE_EDIT)
    {
        if(mModeEdit == MODE_EDIT_AFFINE)
        {
            if(mGlobalTranslateEdit)
            {
                mGlobalTranslateXTarget = mGlobalTranslateXStart + x;
                mGlobalTranslateYTarget = mGlobalTranslateYStart + y;
            }
            
            if(mSelected)
            {
                mSelected->SetTranslation(mPanStartX+x, mPanStartY+y);
            }
        }
    }
}

void JiggleArea::Pinch(float pScale)
{
    if((mRecordMode==true)||(mRecordExporting==true))return;
    
    if(mMode == MODE_EDIT)
    {
        if(mModeEdit == MODE_EDIT_AFFINE)
        {
            if(mGlobalScaleEdit)
            {
                mGlobalScaleTarget = mGlobalScaleStart + (pScale - 1) * mGlobalScale;
                if(mGlobalScaleTarget < 0.95f)mGlobalScaleTarget=0.95f;
                if(mGlobalScaleTarget > 3.0f)mGlobalScaleTarget=3.0f;
            }
            if(mSelected)
            {
                mSelected->SetScale(mPinchStartScale * pScale);
            }
        }
    }
    
    if(mMode == MODE_VIEW)
    {
        if(mModeView == MODE_VIEW_TOUCH)
        {
            //TODO
            //if(mApp->mPurchased)
            //{
            if(mSelected)
            {
                if(mSelected->mTouch && mSelected->mTouch2)
                {
                    mSelected->SetPunch(pScale - 1.0f);
                    mSelected->mPunchSpeed=0.0f;
                }
            }
            //}
        }
    }
    
    
    
}

void JiggleArea::Rotate(float pDegrees)
{
    
    if((mRecordMode==true)||(mRecordExporting==true))return;
    
    if(mSelected && mRotating)
    {
        if(mMode == MODE_EDIT)
        {
            mSelected->SetRotation(mRotateStartRotation + pDegrees);
        }
        else if(mMode == MODE_VIEW)
        {
            if(mSelected->mTouch && mSelected->mTouch2)
            {
                mSelected->mTwistRotation = pDegrees;
                if(mSelected->mTwistRotation < -90)mSelected->mTwistRotation=-90;
                if(mSelected->mTwistRotation >  90)mSelected->mTwistRotation= 90;
                mSelected->mTwistRotationSpeed = 0;
            }
        }
        else if(mMode == MODE_ANIM)
        {
            if(mSelected->mTouch && mSelected->mTouch2)
            {
                //mSelected->mTwistRotation = pDegrees;
                //if(mSelected->mTwistRotation < -90)mSelected->mTwistRotation=-90;
                //if(mSelected->mTwistRotation >  90)mSelected->mTwistRotation= 90;
                //mSelected->mTwistRotationSpeed = 0;
                
            }
        }
    }
}


void JiggleArea::RecordStart()
{
    RecordClear();
    mRecording=true;
}

void JiggleArea::RecordStop()
{
    mRecording=false;
}

void JiggleArea::RecordClear()
{
    EnumList(JigglePoint, aPoint, mList)
    {
        aPoint->Reset();
    }
    
    mRecording=false;
    mRecordFrameCount=0;
    
    mRecordMode=false;
    
    mRecordFrame=0;
    
    mRecordPreviewAutoPlay=false;
    mRecordPreviewAutoSlow=false;
    mRecordPreviewAutoSlowTimer=0;
    
    mRecordExporting=false;
    mRecordExportCancel=false;
    
    MovieExportPreviewStop();
}


void JiggleArea::MovieExportPreviewStart(bool pAutoPlay)
{
    mRecordMode=true;
    mRecordFrame=0;
    mRecordPreviewAutoPlay=pAutoPlay;
}

void JiggleArea::MovieExportPreviewStop()
{
    EnumList(JigglePoint, aPoint, mList)aPoint->Reset();
    
    mRecordMode=false;
    mRecordFrame=0;
}

void JiggleArea::MovieExportPreviewFrameJump(int pIndex)
{
    mRecordFrame=pIndex;
    if(mRecordFrame < 0)mRecordFrame=0;
    if(mRecordFrame >= mRecordFrameCount)mRecordFrame=(mRecordFrameCount-1);
}

void JiggleArea::MovieExportPreviewFrameJumpPercent(float pPercent)
{
    float aFrame = (pPercent * (float)mRecordFrameCount) - 0.4f;
    MovieExportPreviewFrameJump((int)aFrame);
}

void JiggleArea::MovieExportPreviewFrameNext()
{
    mRecordPreviewAutoPlay=false;
    MovieExportPreviewFrameJump(mRecordFrame+1);
}

void JiggleArea::MovieExportPreviewFramePrev()
{
    mRecordPreviewAutoPlay=false;
    MovieExportPreviewFrameJump(mRecordFrame-1);
}

void JiggleArea::MovieExportPreviewFrameNext10()
{
    mRecordPreviewAutoPlay=false;
    if(mRecordFrameCount >= 50)MovieExportPreviewFrameJump(mRecordFrame+10);
    else MovieExportPreviewFrameJump(mRecordFrame+5);
}

void JiggleArea::MovieExportPreviewFramePrev10()
{
    mRecordPreviewAutoPlay=false;
    if(mRecordFrameCount >= 50)MovieExportPreviewFrameJump(mRecordFrame-10);
    else MovieExportPreviewFrameJump(mRecordFrame-5);
}



bool JiggleArea::MovieExportTrimAfter()
{
    bool aReturn=false;
    int aFrame = mRecordFrame;
    if(mRecordFrameCount > 0)
    {
        int aNewCount = aFrame;
        
        if(aNewCount >= 3)
        {
            aReturn=true;
            EnumList(JigglePoint, aJiggle, mList)
            {
                aJiggle->MovieExportTrimAfter(aFrame);
                mRecordFrameCount = aJiggle->mFrameStateList.mCount;
            }
        }
        
    }
    return aReturn;
}

bool JiggleArea::MovieExportTrimBefore()
{
    bool aReturn=false;
    int aFrame = mRecordFrame;
    if(mRecordFrameCount > 0)
    {
        int aNewCount = (mRecordFrameCount - aFrame) + 1;
        printf("Trimming Before 1 [%d @ count %d] New Size = %d\n", aFrame, mRecordFrameCount, aNewCount);
        if(aNewCount >= 3)
        {
            aReturn=true;
            EnumList(JigglePoint, aJiggle, mList)
            {
                aJiggle->MovieExportTrimBefore(aFrame);
                mRecordFrameCount = aJiggle->mFrameStateList.mCount;
            }
            mRecordFrame=0;
        }
        printf("Trimming Before 2 [%d @ count %d] New Size = %d\n", aFrame, mRecordFrameCount, aNewCount);
    }
    return aReturn;
}





