//
//  JigglePoint.cpp
//  Jiggle
//
//  Created by Nick Raptis on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "JigglePoint.h"
#include "JiggleArea.h"
#include "SavedFrameState.h"
#include "MainMenu.h"

JigglePoint::JigglePoint()
{
    float aRadius = 100;
    
    if(gIsLargeScreen == false)aRadius = 50;
    
    mX = aRadius + 25;
    mY = gAppHeight2 - (aRadius / 2.0f);
    
    mScale=1.0f;
    
    mCenterX=0.0f;
    mCenterY=0.0f;
    
    mRotation=0.0f;
    
    //mVBuffer.mTexture = (gJiggle->mTexture);
    
    mTexture = 0;
    
    mJiggleArea = 0;
    mMainMenu = 0;
    
    
    mFreshTimer=0;
    mFreshFade=0.0f;
    mFreshSin=0.0f;
    
    mDrawSkipFudge = 0;
    
    mTwistRotation=0.0f;
    mTwistRotationSpeed=0.0f;
    
    mPunch=0.0f;
    mPunchSpeed=0.0f;
    
    mBoxLeft=0.0f;
    mBoxRight=0.0f;
    mBoxTop=0.0f;
    mBoxBottom=0.0f;
    
    mPointDragStartX=0.0f;
    mPointDragStartY=0.0f;
    
    mSplineTouchIndex = -1;
    
    mSplineDragging=false;
    
    mTouchX1=-1;
    mTouchY1=-1;
    mTouchX2=-1;
    mTouchY2=-1;
    
    mDrawSkips=0;
    
    mFakeX=-1;
    mFakeY=-1;
    
    
    mTouch=0;
    mTouch2=0;
    
    
    for(int i=0;i<SPLINE_SAMPLES;i++)
    {
        mSplineX[i] = 0;
        mSplineY[i] = 0;
        
        mSplineAffineX[i] = 0;
        mSplineAffineY[i] = 0;
    }
    
    for(int i=0;i<SPLINE_GRID_SIZE;i++)
    {
        for(int n=0;n<SPLINE_GRID_SIZE;n++)
        {
            mTriGridDist[i][n] = 0.0f;
            mTriGridEdgeDist[i][n] = 0.0f;
            
            mRingUpX[i][n] = 0.0f;
            mRingUpY[i][n] = 0.0f;
            
            mRingDownX[i][n] = 0.0f;
            mRingDownY[i][n] = 0.0f;
            
            mRingRightX[i][n] = 0.0f;
            mRingRightY[i][n] = 0.0f;
            
            mRingLeftX[i][n] = 0.0f;
            mRingLeftY[i][n] = 0.0f;
        }
        
        for(int n=0;n<SPLINE_GRID_SIZE*2;n++)
        {
            mSplineGridHit[i][n] = false;
            mRingExists[i][n] = false;
            
            mTriGridX[i][n] = 0.0f;
            mTriGridY[i][n] = 0.0f;
            mTriGridZ[i][n] = 0.0f;
            
            mTriGridPercent[i][n] = 0.0f;
            mTriGridEdgePercent[i][n] = 0.0f;
            
            mTriGridAffineX[i][n] = 0.0f;
            mTriGridAffineY[i][n] = 0.0f;
            
            mTriGridBaseX[i][n] = 0.0f;
            mTriGridBaseY[i][n] = 0.0f;
            
            mPushAnimNudgeX[i][n] = 0.0f;
            mPushAnimNudgeY[i][n] = 0.0f;
        }
    }
    
    mNippleSpeedSizeFactor=1.0f;
    mNippleSpeedSizeFactorDrag=0.0f;
    mNippleSpeedX=0.0f;
    mNippleSpeedY=0.0f;
    mNippleX=0.0f;
    mNippleY=0.0f;
    
    mAccelX=0.0f;
    mAccelY=0.0f;
    mLastAccelX=0.0f;
    mLastAccelY=0.0f;
    
    mReceivedAccelData=false;
    mSelectIgnore=false;
    mHolding=false;
    mDeformed=false;
    
    mShapeIndex=0;
    
    mKillTimer=0;
    
    mTouchStartX=0;
    mTouchStartY=0;
    
    mTouchStartMouseX=0;
    mTouchStartMouseY=0;
    
    
    
    mBulgeIndex=1;
    
    
    
    mHoldFactor = 0.0f;
    
    mMoveSpeedPercent = 0.5f;
    mMovePowerPercent = 0.5f;
    
    
    
    
    
    mColorSplineControlPointOuter[0]=FColor(0,0,0,1.0f);
    mColorSplineControlPointInner[0]=FColor(1,1,1,1.0f);
    mColorSplineLine[0]=FColor(1,1,1,1);
    mColorSplineFill[0]=FColor(0.05f,0.55,0.08f,0.15f);
    
    mColorSplineControlPointOuterSelected[0]=FColor(0,0,0,1);
    mColorSplineControlPointInnerSelected[0]=FColor(1,1,1,1);
    mColorSplineLineSelected[0]=FColor(1,1,1,1);
    mColorSplineFillSelected[0]=FColor(0.05f,0.55,0.08f,0.33f);
    
    
    
    mColorSplineControlPointOuter[1]=FColor(1,1,1,1.0f);
    mColorSplineControlPointInner[1]=FColor(0,0,0,1.0f);
    mColorSplineLine[1]=FColor(0,0,0,1.0f);
    mColorSplineFill[1]=FColor(0.85,1,0.65f,0.15f);
    
    mColorSplineControlPointOuterSelected[1]=FColor(1,1,1,1);
    mColorSplineControlPointInnerSelected[1]=FColor(0,0,0,1);
    mColorSplineLineSelected[1]=FColor(0,0,0,1);
    mColorSplineFillSelected[1]=FColor(0.85,1,0.65f,0.33f);
    
    
    mColorSplineControlPointOuter[2]=FColor(0,1,0,1.0f);
    mColorSplineControlPointInner[2]=FColor(0,0,1,1.0f);
    mColorSplineLine[2]=FColor(0,1,0,0.5f);
    mColorSplineFill[2]=FColor(0.15f,0.1f,0.45f,0.15f);
    
    mColorSplineControlPointOuterSelected[2]=FColor(0,1,0,1);
    mColorSplineControlPointInnerSelected[2]=FColor(0,0,1,1);
    mColorSplineLineSelected[2]=FColor(0,1,0,1);
    mColorSplineFillSelected[2]=FColor(0.13f,0.1f,0.45f,0.33f);
    
    ResetCircle(9);
    
    
    mAnimationActive = false;
    mAnimationRefresh = true;
    
    
    
    mAnimationGuideX = 0.0f;
    mAnimationGuideY = 40.0f;
    mAnimationGuideRadius = 60.0f;
    mAnimationGuidePower = 1.0f;
    
    mAnimationGuideSin1 = 0.0f;
    mAnimationGuideSin2 = 180.0f;
    
    
    
    Draw();
    DrawMarkers(false, 0.0f);
}

JigglePoint::~JigglePoint()
{
    FlushFrameStates();
}

void JigglePoint::Reset()
{
    mTwistRotation=0;
    mTwistRotationSpeed=0;
    
    mAccelX=0;
    mAccelY=0;
    mLastAccelX=0;
    mLastAccelY=0;
    
    mReceivedAccelData=false;
    
    mNippleSpeedX=0;
    mNippleSpeedY=0;
    
    mNippleX=0;
    mNippleY=0;
    
    mPunch=0.0f;
    mPunchSpeed=0.0f;
    
    mTwistRotation=0.0f;
    
    //mTouch=0;
    
    mHolding=false;
    
    UpdateAffine();
}

void JigglePoint::SetHoldNipple(float x, float y)
{
    
    mNippleX = x;
    mNippleY = y;
    
    float aMaxDist = 130.0f * mNippleSpeedSizeFactorDrag;// mNippleSpeedSizeFactor;
    
    float aDiffX = mNippleX;
    float aDiffY = mNippleY;
    
    float aDist = aDiffX * aDiffX + aDiffY * aDiffY;
    
    if(aDist > 0.25f)
    {
        aDist = sqrtf(aDist);
        
        aDiffX /= aDist;
        aDiffY /= aDist;
    }
    else
    {
        aDiffX=0;
        aDiffY=0;
        aDist=0;
    }
    
    if(aDist > aMaxDist)
    {
        aDist = aMaxDist;
    }
    
    mNippleX = aDiffX * aDist;
    mNippleY = aDiffY * aDist;
}

void JigglePoint::Update()
{
    
    if(mDrawSkipFudge < 32)
    {
        mDrawSkipFudge++;
    }
    
    if(mFreshTimer > 0)
    {
        mFreshFade=1.0f;
        mFreshTimer--;
    }
    if(mFreshTimer < 0)
    {
        mFreshTimer=0;
    }
    if(mFreshFade > 0)
    {
        mFreshSin += 16.0f;
        if(mFreshSin > 360.0f)mFreshSin -= 360.0f;
        
        if(mFreshTimer <= 0)
        {
            mFreshFade -= 0.01f;
            if(mFreshFade <= 0)
            {
                mFreshFade=0;
            }
        }
    }
    
    
    float aDiffX;
    float aDiffY;
    float aDist;
    
    if(mHolding == false)
    {
        if(mAnimationActive == false)
        {
            mTwistRotationSpeed += -(mTwistRotation * 0.075f);
            mTwistRotation *= 0.96f;
            mTwistRotation += mTwistRotationSpeed;
            
            mPunchSpeed += -(mPunch * 0.075f);
            
            if(mPunch < 0)
            {
                mPunch -= (mPunch * 0.2f);
            }
            
            mPunchSpeed *= 0.96f;
            mPunch += mPunchSpeed;
            
            
            if(mHoldFactor > 0)
            {
                mHoldFactor -= 0.025f;
                if(mHoldFactor < 0)mHoldFactor = 0;
            }
        }
    }
    else
    {
        mHoldFactor=1.0f;
        
        //mPunch+=0.025f;
        //if(mPunch >= 1.20f)mPunch=1.20f;
    }
    
    
    
    bool aEditMode = false;
    bool aEditModeCenter = false;
    bool aEditModeShape = false;
    
    
    bool aViewMode = true;
    bool aViewModeTouch = false;
    
    if(mJiggleArea != 0)
    {
        if(mJiggleArea->mMode == MODE_EDIT)
        {
            aEditMode = true;
            
            if(mJiggleArea->mModeEdit == MODE_EDIT_CENTER)aEditModeCenter = true;
            if(mJiggleArea->mModeEdit == MODE_EDIT_SHAPE)aEditModeShape = true;
        }
        
        if(gJiggle->mMode == MODE_VIEW)
        {
            aViewMode = true;
            
            if(gJiggle->mModeView == MODE_VIEW_TOUCH)aViewModeTouch = true;
        }
        else
        {
            aViewMode = false;
        }
    }
    
    if(aViewMode)
    {
        
        if((mHolding == false) && (aViewModeTouch == true))
        {
            
            
            
            if(mReceivedAccelData)
            {
                //mNippleSpeedX += (mAccelX - mLastAccelX) * (mMovePowerPercent * 14.0f + 2.5f) * mNippleSpeedSizeFactor;//* mScale
                //mNippleSpeedY += (mAccelY - mLastAccelY) * (mMovePowerPercent * 14.0f + 2.5f) * mNippleSpeedSizeFactor;//* mScale
                
                if(gIsLargeScreen)
                {
                    mNippleSpeedX += (mAccelX - mLastAccelX) * (5.0f) * mNippleSpeedSizeFactor;//* mScale
                    mNippleSpeedY += (mAccelY - mLastAccelY) * (5.0f) * mNippleSpeedSizeFactor;//* mScale
                }
                else
                {
                    mNippleSpeedX += (mAccelX - mLastAccelX) * (7.0f) * mNippleSpeedSizeFactor;//* mScale
                    mNippleSpeedY += (mAccelY - mLastAccelY) * (7.0f) * mNippleSpeedSizeFactor;//* mScale
                }
                
                
            }
            else
            {
                //mNippleSpeedX += (Sin(SystemTime() / 1000)) * (10.0f);//* mScale
                //mNippleSpeedY += ((1 - Cos(SystemTime() / 1000))) * (10.0f);//* mScale
            }
            
            aDiffX = -mNippleX;
            aDiffY = -mNippleY;
            aDist = aDiffX * aDiffX + aDiffY * aDiffY;
            
            if(aDist > 0.25f)
            {
                aDist = sqrtf(aDist);
                
                aDiffX /= aDist;
                aDiffY /= aDist;
            }
            else
            {
                aDiffX=0;
                aDiffY=0;
                aDist=0;
            }
            
            
            //float aSizeFactor = mNippleSpeedSizeFactor;
            //if(aSizeFactor > 0.1f)
            //{
            //    aSizeFactor = 1 / aSizeFactor;
            //    aSizeFactor /= 2.0f;
            //}
            
            mNippleSpeedX += aDiffX * aDist * (0.090 + mMoveSpeedPercent * 0.40f);// * aSizeFactor;
            mNippleSpeedY += aDiffY * aDist * (0.090 + mMoveSpeedPercent * 0.40f);// * aSizeFactor;
            
            mNippleSpeedX *= 0.9535f;
            mNippleSpeedY *= 0.9535f;
            
            mNippleX += mNippleSpeedX;
            mNippleY += mNippleSpeedY;
        }
        else
        {
            //mMotionMagnitude=0;
        }
        
    }
    
    //mNippleX=0;
    //mNippleY=Sin(SystemTime() / 1000) * 40.0f;
    
    /*
     float aTwist = mNippleX + mNippleY;
     bool aSign = aTwist < 0;
     
     if(aTwist < 0)aTwist = -aTwist;
     if(aTwist > 0.25f)aTwist = sqrtf(aTwist);
     if(aSign)aTwist = - aTwist;
     */
    
    
}

void JigglePoint::AddTriangle(int x1, int y1, int x2, int y2, int x3, int y3)
{
    mTri.Add(x1, y1);
    mTri.Add(x2, y2);
    mTri.Add(x3, y3);
}

void JigglePoint::DrawCenters()
{
    float aCX = mCenterX;
    float aCY = mCenterY;
    Untransform(mCenterX, mCenterY, aCX, aCY);
    
    gAss.mCircle.Center(aCX, aCY);
    gAss.mCircle.Center(mX, mY);
    
    
    float aX = mX + mAnimationGuideX;
    float aY = mY + mAnimationGuideY;
    
    Graphics::SetColor(1.0f, 0.25f, 0.45f, 0.8f);
    Graphics::DrawLine(mX, mY, aX, aY);
    
    
    
    Graphics::SetColor(1.0f, 0.25f, 0.15f, 0.8f);
    
    Graphics::DrawLine(aX, aY, aX, aY + mAnimationGuideRadius);
    
    
    gAss.mCircleFill.Draw(aX, aY, (mAnimationGuideRadius / 32.0f) * 2.0f, 0.0f);
    
    
    Graphics::SetColor();
    
    
    
    
    
    
    
    
    
}

void JigglePoint::DrawGrid()
{
    Graphics::SetColor(1,0,0);
    for(int x=0;x<SPLINE_GRID_SIZE;x++)
    {
        for(int y=0;y<SPLINE_GRID_SIZE;y++)
        {
            float aX = mTriGridAffineX[x][y];
            float aY = mTriGridAffineY[x][y];
            
            aX += mX;
            aY += mY;
            
            
            
            //Untransform(aX, aY, aX, aY);
            
            
            Graphics::SetColor(1.0f, 0.0f, 0.25f, 0.45f);
            Graphics::DrawPoint(aX, aY, 2.0f);
            
            Graphics::SetColor();
        }
    }
    
    
    Graphics::SetColor(0,1,0);
    for(int x=0;x<SPLINE_GRID_SIZE;x++)
    {
        for(int y=0;y<SPLINE_GRID_SIZE;y++)
        {
            
            float aX1 = mTriGridAffineX[x][y];
            float aY1 = mTriGridAffineY[x][y];
            
            aX1 += mX;
            aY1 += mY;
            
            float aX2 = aX1 - mPushAnimNudgeX[x][y] * 20.0f * mTriGridEdgePercent[x][y];
            float aY2 = aY1 - mPushAnimNudgeY[x][y] * 20.0f * mTriGridEdgePercent[x][y];
            
            Graphics::SetColor(0.925f, 0.75f, 0.88f, 0.65f);
            Graphics::DrawLine(aX1, aY1, aX2, aY2, 1);
            
        }
    }
    
    Graphics::SetColor();
    
}

void JigglePoint::DrawPercentageGrid()
{
    float aCX = mCenterX;
    float aCY = mCenterY;
    Untransform(mCenterX, mCenterY, aCX, aCY);
}

void JigglePoint::DrawAnimMarkers(bool pSelected, float pOpacity)
{
    float aCX = mCenterX;
    float aCY = mCenterY;
    Untransform(mCenterX, mCenterY, aCX, aCY);
    
    mMainAnimationLoop.Draw(aCX, aCY);
}

void JigglePoint::DrawMarkers(bool pSelected, float pOpacity)
{
    mVBuffer.Clear();
    mVBuffer.mMode=GL_TRIANGLES;
    
    float aPercent;
    float aX, aY;
    
    
    for(int i=0;i<SPLINE_GRID_SIZE;i++)
    {
        for(int n=0;n<SPLINE_GRID_SIZE*2;n++)
        {
            if(mSplineGridHit[i][n])
            {
                aPercent = mTriGridPercent[i][n];
                mTriGridX[i][n] = mTriGridAffineX[i][n];
                mTriGridY[i][n] = mTriGridAffineY[i][n];
            }
        }
    }
    
    int aXIndex, aYIndex;
    
    for(int i=0;i<mTri.mCount;i++)
    {
        aXIndex = mTri.mX[i];
        aYIndex = mTri.mY[i];
        
        aX = mTriGridX[aXIndex][aYIndex];
        aY = mTriGridY[aXIndex][aYIndex];
        
        mVBuffer.AddXYZ(aX+mX, aY+mY, mTriGridPercent[aXIndex][aYIndex]);
    }
    
    
    bool aEditing = false;
    
    if(mJiggleArea != 0)
    {
        if(mJiggleArea->mSelected == this)aEditing = true;
    }
    
    
    bool aEditMode = false;
    bool aEditModeCenter = false;
    bool aEditModeShape = false;
    if(mJiggleArea != 0)
    {
        if(gJiggle->mMode == MODE_EDIT)
        {
            aEditMode = true;
            
            if(gJiggle->mModeEdit == MODE_EDIT_CENTER)aEditModeCenter = true;
            if(gJiggle->mModeEdit == MODE_EDIT_SHAPE)aEditModeShape = true;
        }
    }
    
    
    Graphics::TextureDisable();
    
    bool aDrawCenters = false;
    
    if(mJiggleArea != 0)
    {
        if((mJiggleArea->mMode == MODE_EDIT) && (mJiggleArea->mModeEdit==MODE_EDIT_CENTER))
        {
            aDrawCenters = true;
        }
    }
    
    if(mDrawSkipFudge > 3)
    {
        if(aDrawCenters == true)
        {
            Graphics::SetColor();
            mVBuffer.DrawColored();
        }
        else
        {
            if(aEditing)
            {
                Graphics::SetColor(mColorSplineFillSelected[gApp->mColorIndex]);
            }
            else
            {
                Graphics::SetColor(mColorSplineFill[gApp->mColorIndex]);
            }
            
            mVBuffer.Draw();
        }
    }
    
    
    
    if(aEditing)
    {
        Graphics::SetColor(mColorSplineLineSelected[gApp->mColorIndex]);
    }
    
    else
    {
        Graphics::SetColor(mColorSplineLine[gApp->mColorIndex]);
    }
    
    
    if(mDrawSkipFudge > 3)
    {
        mLine.Draw();
    }
    
    if(aEditMode)
    {
        if(aEditModeShape)
        {
            if(aEditing)
            {
                for(int i=0;i<mSplineBase.mPointCount;i++)
                {
                    
                    Untransform(mSplineBase.mX[i], mSplineBase.mY[i], aX, aY);
                    
                    
                    if(mSplineTouchIndex == i)
                    {
                        gG.SetColor(mColorSplineControlPointOuterSelected[gApp->mColorIndex].mRed * 0.8f, mColorSplineControlPointOuterSelected[gApp->mColorIndex].mGreen * 0.8f, mColorSplineControlPointOuterSelected[gApp->mColorIndex].mBlue * 0.8f);
                        
                        gG.DrawRect(aX-8, aY-8, 17, 17);
                    }
                    else
                    {
                        gG.SetColor(mColorSplineControlPointOuterSelected[gApp->mColorIndex]);
                        gG.DrawRect(aX-5, aY-5, 11, 11);
                    }
                    
                    
                    
                    if(mSplineTouchIndex == i)
                    {
                        gG.SetColor(mColorSplineControlPointInnerSelected[gApp->mColorIndex].mRed * 0.8f, mColorSplineControlPointInnerSelected[gApp->mColorIndex].mGreen * 0.8f, mColorSplineControlPointInnerSelected[gApp->mColorIndex].mBlue * 0.8f);
                        gG.DrawRect(aX-4, aY-4, 9, 9);
                    }
                    else
                    {
                        gG.SetColor(mColorSplineControlPointInnerSelected[gApp->mColorIndex]);
                        gG.DrawRect(aX-3, aY-3, 7, 7);
                    }
                }
            }
            else
            {
                
                
                for(int i=0;i<mSplineBase.mPointCount;i++)
                {
                    Untransform(mSplineBase.mX[i], mSplineBase.mY[i], aX, aY);
                    
                    gG.SetColor(mColorSplineControlPointOuterSelected[gApp->mColorIndex]);
                    gG.DrawRect(aX-5, aY-5, 11, 11);
                    
                    gG.SetColor(mColorSplineControlPointInner[gApp->mColorIndex]);
                    gG.DrawRect(aX-3, aY-3, 7, 7);
                }
            }
        }
    }
    
    gG.SetColor();
    
    
    
    
    if(mDrawSkipFudge > 3)
    {
        
        if(aEditMode)
        {
            if(aEditing)
            {
                gApp->mRegistrationSprite[1].Center(mX, mY);
                //Draw(mX,mY,mScale,mRotation);
            }
            else
            {
                gApp->mRegistrationSprite[0].Center(mX,mY);
                //Draw(mX,mY,mScale,mRotation);
            }
            
            if(aEditModeCenter)
            {
                Untransform(mCenterX, mCenterY, aX, aY);
                if(aEditing)gApp->mCenterSprite[1].Center(aX,aY);
                else gApp->mCenterSprite[0].Center(aX,aY);
            }
        }
    }
    
}

void JigglePoint::Draw()
{
    if(mJiggleArea)
    {
        if(mJiggleArea->mRecordMode || mJiggleArea->mRecordExporting)
        {
            GoToFrameState(mJiggleArea->mRecordFrame);
        }
    }
    
    
    int aXIndex, aYIndex;
    
    float aX, aY;
    float aPercent;
    float aEdgePercent;
    
    mVBuffer.Clear();
    
    float aFactor = mMovePowerPercent * 0.75f + 0.25f;
    
    aFactor = ((aFactor * (1 - mHoldFactor))) + (mHoldFactor);
    
    float aNippleX = mNippleX * aFactor;
    float aNippleY = mNippleY * aFactor;
    
    for(int i=0;i<SPLINE_GRID_SIZE;i++)
    {
        for(int n=0;n<SPLINE_GRID_SIZE*2;n++)
        {
            if(mSplineGridHit[i][n])
            {
                aPercent = mTriGridPercent[i][n];
                aEdgePercent = mTriGridEdgePercent[i][n];
                
                aX = mTriGridAffineX[i][n];
                aY = mTriGridAffineY[i][n];
                
                float aDiffX = mTriGridAffineX[i][n];
                float aDiffY = mTriGridAffineY[i][n];
                float aRot = FaceTarget(aDiffX, aDiffY);
                float aDist = aDiffX * aDiffX + aDiffY * aDiffY;
                
                if(aDist > 0.25f)
                {
                    aDist = sqrtf(aDist);
                    
                    aDiffX /= aDist;
                    aDiffY /= aDist;
                }
                else
                {
                    aDiffX = 0;
                    aDiffY = 0;
                }
                
                aRot += mTwistRotation * aEdgePercent * aPercent;
                
                float aDirX = Sin(-aRot);
                float aDirY = Cos(-aRot);
                
                aX = aDirX * (aDist * (1 + (mPunch * aEdgePercent)));
                aY = aDirY * (aDist * (1 + (mPunch * aEdgePercent)));
                
                aX += aNippleX * aPercent;
                aY += aNippleY * aPercent;
                
                mTriGridX[i][n] = aX;
                mTriGridY[i][n] = aY;
                
            }
        }
    }
    
    for(int i=0;i<mTri.mCount;i++)
    {
        aXIndex = mTri.mX[i];
        aYIndex = mTri.mY[i];
        
        aPercent = mTriGridPercent[aXIndex][aYIndex];
        
        aX = mTriGridX[aXIndex][aYIndex];
        aY = mTriGridY[aXIndex][aYIndex];
        
        mVBuffer.AddXYZ(aX+mX, aY+mY, aPercent);
        
    }
    
    if(mDrawSkipFudge > 3)
    {
        if(mTexture)
        {
            Graphics::TextureEnable();
            Graphics::TextureBind(mTexture);
            
            gG.SetColor();
            
            mVBuffer.mMode=GL_TRIANGLES;
            mVBuffer.Draw();
            
            gG.SetColor();
            
            
            
            Graphics::TextureDisable();
        }
    }
    
    
}

void JigglePoint::Transform(float x, float y, float &pNewX, float &pNewY)
{
    x -= mX;y -= mY;
    
    float aDiffX = -x;float aDiffY = -y;
    
    float aRot = FaceTarget(aDiffX, aDiffY);
    float aDist = aDiffX * aDiffX + aDiffY * aDiffY;
    
    if(aDist > 0.25f)
    {
        aDist = sqrtf(aDist);
        aDiffX /= aDist;aDiffY /= aDist;
    }
    else
    {
        aDiffX = 0;aDiffY = 0;
    }
    
    aRot -= mRotation;
    
    float aDirX = Sin(-aRot);
    float aDirY = Cos(-aRot);
    
    pNewX = aDirX * (aDist / mScale);
    pNewY = aDirY * (aDist / mScale);
}

void JigglePoint::Untransform(float x, float y, float &pNewX, float &pNewY, bool pSkipTranslate)
{
    float aDiffX = x;float aDiffY = y;
    float aRot = FaceTarget(-aDiffX, -aDiffY);
    float aDist = aDiffX * aDiffX + aDiffY * aDiffY;
    
    if(aDist > 0.25f)
    {
        aDist = sqrtf(aDist);
        aDiffX /= aDist;aDiffY /= aDist;
    }
    else
    {
        aDiffX = 0;aDiffY = 0;
    }
    
    aRot += mRotation;
    
    float aDirX = Sin(-aRot);
    float aDirY = Cos(-aRot);
    
    pNewX = aDirX * (aDist * mScale);
    pNewY = aDirY * (aDist * mScale);
    
    if(pSkipTranslate == false)
    {
        pNewX += mX;
        pNewY += mY;
    }
}

void JigglePoint::ClosestPointInDirection(int pGridX, int pGridY, int pDir, float &pClosestX, float &pClosestY)
{
    float aStartX = mTriGridBaseX[pGridX][pGridY];float aStartY = mTriGridBaseY[pGridX][pGridY];
    float aEndX = mTriGridBaseX[pGridX][pGridY];float aEndY = mTriGridBaseY[pGridX][pGridY];
    
    pClosestX=aStartX;
    pClosestY=aStartY;
    
    if(pDir == 0)
    {
        aEndX = mTriGridBaseX[pGridX-1][pGridY];
    }
    else if(pDir == 1)
    {
        aEndX = mTriGridBaseX[pGridX+1][pGridY];
    }
    else if(pDir == 2)
    {
        aEndY = mTriGridBaseY[pGridX][pGridY-1];
    }
    else
    {
        aEndY = mTriGridBaseY[pGridX+1][pGridY+1];
    }
    
    
    int aLoopCount = 20;
    float aPercent;
    float aBestDist = 1000000.0f;
    float aCheckX, aCheckY;
    float aDiffX, aDiffY, aDist;
    for(int k=0;k<aLoopCount;k++)
    {
        aPercent = (float)k / ((float)(aLoopCount-1));
        
        aCheckX = aStartX + (aEndX - aStartX) * aPercent;
        aCheckY = aStartY + (aEndY - aStartY) * aPercent;
        
        for(int i=0;i<SPLINE_SAMPLES;i++)
        {
            aDiffX = aCheckX - mSplineX[i];
            aDiffY = aCheckY - mSplineY[i];
            aDist = aDiffX * aDiffX + aDiffY * aDiffY;
            
            if(aDist < aBestDist)
            {
                aBestDist = aDist;
                
                pClosestX = mSplineX[i];
                pClosestY = mSplineY[i];
            }
        }
    }
}

void JigglePoint::UpdateAffine()
{
    //float aX, aY, aU, aV;
    
    for(int i=0;i<SPLINE_GRID_SIZE;i++)
    {
        for(int n=0;n<SPLINE_GRID_SIZE*2;n++)
        {
            if(mSplineGridHit[i][n])
            {
                mTriGridAffineX[i][n] = mTriGridBaseX[i][n] * mScale;// + mX;
                mTriGridAffineY[i][n] = mTriGridBaseY[i][n] * mScale;// + mY;
            }
        }
    }
    
    for(int i=0;i<SPLINE_GRID_SIZE;i++)
    {
        for(int n=0;n<SPLINE_GRID_SIZE*2;n++)
        {
            if(mSplineGridHit[i][n])
            {
                float aDiffX = mTriGridAffineX[i][n];
                float aDiffY = mTriGridAffineY[i][n];
                
                float aRot = FaceTarget(-aDiffX, -aDiffY);
                float aDist = aDiffX * aDiffX + aDiffY * aDiffY;
                
                if(aDist > 0.25f)
                {
                    aDist = sqrtf(aDist);
                    aDiffX /= aDist;aDiffY /= aDist;
                }
                else
                {
                    aDiffX = 0;aDiffY = 0;
                }
                
                aRot += mRotation;
                
                float aDirX = Sin(-aRot);float aDirY = Cos(-aRot);
                mTriGridAffineX[i][n] = aDirX * aDist;
                mTriGridAffineY[i][n] = aDirY * aDist;
            }
        }
    }
    
    float aTotalEdgeLength = 0.0f;
    
    float aDiffX, aDiffY, aDist, aRot, aDirX, aDirY;
    
    for(int i=0;i<SPLINE_SAMPLES;i++)
    {
        aDiffX = mSplineX[i];aDiffY = mSplineY[i];
        
        aRot = FaceTarget(-aDiffX, -aDiffY);
        aDist = aDiffX * aDiffX + aDiffY * aDiffY;
        
        if(aDist > 0.25f)
        {
            aDist = sqrtf(aDist);
            aDiffX /= aDist;
            aDiffY /= aDist;
        }
        else
        {
            aDiffX = 0;aDiffY = 0;
        }
        
        aRot += mRotation;
        aDirX = Sin(-aRot);aDirY = Cos(-aRot);
        
        aDist *= mScale;
        mSplineAffineX[i] = aDirX * aDist;// * mScale;
        mSplineAffineY[i] = aDirY * aDist;// * mScale;
    }
    
    
    
    float aLastX = mSplineAffineX[0];
    float aLastY = mSplineAffineX[0];
    
    for(int i=1;i<SPLINE_SAMPLES;i++)
    {
        aDiffX = mSplineAffineX[i] - aLastX;
        aDiffY = mSplineAffineY[i] - aLastY;
        aLastX = mSplineAffineX[i];
        aLastY = mSplineAffineY[i];
        
        aDist = aDiffX * aDiffX + aDiffY * aDiffY;
        
        if(aDist > 0.25f)aDist = sqrtf(aDist);
        
        aTotalEdgeLength += aDist;
    }
    
    mNippleSpeedSizeFactor = aTotalEdgeLength / 1200.0f;
    mNippleSpeedSizeFactorDrag = aTotalEdgeLength / 900.0f;
    
    //mNippleSpeedSizeFactor
    
    if(gIsLargeScreen == false)
    {
        mNippleSpeedSizeFactor = aTotalEdgeLength / 1200.0f;
    }
    else
    {
        mNippleSpeedSizeFactor = aTotalEdgeLength / 900.0f;
        mNippleSpeedSizeFactorDrag = aTotalEdgeLength / 900.0f;
    }
    
    
    if(mNippleSpeedSizeFactor > 4.0f)mNippleSpeedSizeFactor=4.0f;
    if(mNippleSpeedSizeFactor < 0.15f)mNippleSpeedSizeFactor=0.15f;
    
    if(mNippleSpeedSizeFactorDrag > 4.0f)mNippleSpeedSizeFactorDrag=4.0f;
    if(mNippleSpeedSizeFactorDrag < 0.15f)mNippleSpeedSizeFactorDrag=0.15f;
    
    mLine.Clear();
    
    for(int i=0;i<SPLINE_SAMPLES;i+=4)
    {
        mLine.Add(mSplineAffineX[i] + mX, mSplineAffineY[i] + mY);
    }
    
    mVBuffer.mCoordCount=0;
    
    if(mJiggleArea != 0)
    {
        for(int i=0;i<mTri.mCount;i++)
        {
            int aXIndex = mTri.mX[i];int aYIndex = mTri.mY[i];
            float aU, aV;
            mJiggleArea->SamplePoint(mTriGridAffineX[aXIndex][aYIndex]+mX, mTriGridAffineY[aXIndex][aYIndex]+mY, aU, aV);
            mVBuffer.AddUV(aU, aV);
        }
    }
    else if(mMainMenu != 0)
    {
        for(int i=0;i<mTri.mCount;i++)
        {
            int aXIndex = mTri.mX[i];int aYIndex = mTri.mY[i];
            float aU, aV;
            mMainMenu->SamplePoint(mTriGridAffineX[aXIndex][aYIndex]+mX, mTriGridAffineY[aXIndex][aYIndex]+mY, aU, aV);
            mVBuffer.AddUV(aU, aV);
        }
    }
    
    
}

void JigglePoint::SetCenter(float x, float y)
{
    float aX, aY;
    Transform(x, y, aX, aY);
    mCenterX = aX;mCenterY = aY;
    CalcDistances();
}

void JigglePoint::SetScale(float pScale)
{
    mScale = pScale;
    if(mScale > 3.0f)mScale = 3.0f;
    if(mScale < 0.25f)mScale = 0.25f;
    UpdateAffine();
}

void JigglePoint::SetPunch(float pPunch)
{
    mPunch = pPunch;
    if(mPunch > 1.65f)mPunch=1.65f;
    
}

void JigglePoint::SetRotation(float pRotation)
{
    mRotation = pRotation;
    
    if(mRotation > 360.0f)mRotation -= 360.0f;
    if(mRotation < 0)mRotation += 360.0f;
    
    UpdateAffine();
}


void JigglePoint::SetTranslation(float x, float y)
{
    mX = x;mY = y;
    
    float aRing = 50;
    
    if(mX < aRing)mX = aRing;
    if(mX > gAppWidth - aRing)mX = gAppWidth - aRing;
    
    if(mY < aRing)mY = aRing;
    if(mY > gAppHeight - aRing)mY = gAppHeight - aRing;
    
    UpdateAffine();
}

void JigglePoint::SolveSpline()
{
    float aX, aY, aPos, aPercent;
    
    mSplineBase.Solve(false, true);
    for(int i=0;i<SPLINE_SAMPLES;i++)
    {
        aPercent = (float)i / (float)((SPLINE_SAMPLES));
        aPos = aPercent * (mSplineBase.Max());
        
        aX = mSplineBase.GetX(aPos);aY = mSplineBase.GetY(aPos);
        mSplineX[i] = aX;mSplineY[i] = aY;
    }
    UpdateAffine();
}

void JigglePoint::ClosestPoint(float x1, float y1, float x2, float y2, float pLength, float x, float y, float &pClosestX, float &pClosestY)
{
    pClosestX=x1;
    pClosestY=y1;
    
    float aFactor1X=x-x1;
    float aFactor1Y=y-y1;
    
    float aFactor2X=x2-x1;
    float aFactor2Y=y2-y1;
    
    float aLength=pLength;
    
    if(aLength > 0.01f)
    {
        aFactor2X/=pLength;
        aFactor2Y/=pLength;
        
        float aScalar=aFactor2X*aFactor1X+aFactor2Y*aFactor1Y;
        
        if(aScalar<0)
        {
            pClosestX=x1;
            pClosestY=y1;
        }
        else if(aScalar>pLength)
        {
            pClosestX=x2;
            pClosestY=y2;
        }
        else
        {
            pClosestX=x1+aFactor2X*aScalar;
            pClosestY=y1+aFactor2Y*aScalar;
        }
    }
}


void JigglePoint::MeshSpline()
{
    mTri.Clear();
    
    mFakeX = 0;
    mFakeY = SPLINE_GRID_SIZE;
    
    for(int x = 0;x<SPLINE_GRID_SIZE;x++)
    {
        for(int y=0;y<SPLINE_GRID_SIZE*2;y++)
        {
            mTriGridBaseX[x][y]=0;
            mTriGridBaseY[x][y]=0;
            mSplineGridHit[x][y]=false;
        }
    }
    
    float aLeft, aRight, aTop, aBottom;
    float aDiffX, aDiffY, aDist;
    
    
    aLeft=mSplineX[0];
    aRight=mSplineX[0];
    aTop=mSplineY[0];
    aBottom=mSplineY[0];
    
    for(int i=0;i<SPLINE_SAMPLES;i++)
    {
        if(mSplineX[i] < aLeft)aLeft=mSplineX[i];
        if(mSplineX[i] > aRight)aRight=mSplineX[i];
        
        if(mSplineY[i] < aTop)aTop=mSplineY[i];
        if(mSplineY[i] > aBottom)aBottom=mSplineY[i];
    }
    
    aLeft -= 5.0f;
    aRight += 5.0f;
    aTop -= 5.0f;
    aBottom += 5.0f;
    
    float aXPercent, aYPercent;
    
    float aGridX, aGridY;
    
    bool aIntersects;
    
    for(int x = 0;x<SPLINE_GRID_SIZE;x++)
    {
        aXPercent = (float)x / (float)(SPLINE_GRID_SIZE - 1);
        aGridX = aXPercent * (aRight - aLeft) + aLeft;
        
        for(int y=0;y<SPLINE_GRID_SIZE;y++)
        {
            aYPercent = (float)y / (float)(SPLINE_GRID_SIZE-1);
            aGridY = aYPercent * (aBottom - aTop) + aTop;
            
            mTriGridBaseX[x][y]=aGridX;
            mTriGridBaseY[x][y]=aGridY;
            
            aIntersects = false;
            
            for(int aStart=0,aEnd=SPLINE_SAMPLES-1;aStart<SPLINE_SAMPLES;aEnd=aStart++)
            {
                if ((((mSplineY[aStart]<=aGridY) && (aGridY<mSplineY[aEnd]))||
                     ((mSplineY[aEnd]<=aGridY) && (aGridY<mSplineY[aStart])))&&
                    (aGridX < (mSplineX[aEnd] - mSplineX[aStart])*(aGridY - mSplineY[aStart])
                     /(mSplineY[aEnd] - mSplineY[aStart]) + mSplineX[aStart]))
                    aIntersects=!aIntersects;
            }
            if(aIntersects)
            {
                mSplineGridHit[x][y]=true;
            }
        }
    }
    
    
    for(int x=0;x<SPLINE_GRID_SIZE-1;x++)
    {
        for(int y=0;y<SPLINE_GRID_SIZE-1;y++)
        {
            if(mSplineGridHit[x][y]&&mSplineGridHit[x][y+1]
               &&mSplineGridHit[x+1][y]&&mSplineGridHit[x+1][y+1])
            {
                AddTriangle(x+1, y, x, y, x, y+1);
                AddTriangle(x+1, y+1, x+1, y, x, y+1);
            }
        }
    }
    
    
    float aBestX, aBestY;
    for(int x = 1;x<SPLINE_GRID_SIZE-1;x++)
    {
        for(int y=1;y<SPLINE_GRID_SIZE-1;y++)
        {
            if(mSplineGridHit[x][y])
            {
                if(mSplineGridHit[x-1][y] == false)
                {
                    ClosestPointInDirection(x, y, 0, aBestX, aBestY);
                    mRingLeftX[x][y]=aBestX;
                    mRingLeftY[x][y]=aBestY;
                }
                if(mSplineGridHit[x+1][y] == false)
                {
                    ClosestPointInDirection(x, y, 1, aBestX, aBestY);
                    mRingRightX[x][y]=aBestX;
                    mRingRightY[x][y]=aBestY;
                }
                if(mSplineGridHit[x][y-1] == false)
                {
                    ClosestPointInDirection(x, y, 2, aBestX, aBestY);
                    mRingUpX[x][y]=aBestX;
                    mRingUpY[x][y]=aBestY;
                }
                if(mSplineGridHit[x][y+1] == false)
                {
                    ClosestPointInDirection(x, y, 3, aBestX, aBestY);
                    mRingDownX[x][y]=aBestX;
                    mRingDownY[x][y]=aBestY;
                }
            }
        }
    }
    
    
    
    
    int aFakeX1, aFakeY1, aFakeX2, aFakeY2;
    
    for(int x = 1;x<SPLINE_GRID_SIZE-1;x++)
    {
        for(int y=1;y<SPLINE_GRID_SIZE-1;y++)
        {
            if(mSplineGridHit[x][y])
            {
                if(mSplineGridHit[x-1][y] == false && mSplineGridHit[x][y-1] == false)
                {
                    mTri.Add(mFakeX, mFakeY);
                    PadFakeGrid(mRingLeftX[x][y], mRingLeftY[x][y]);
                    
                    mTri.Add(mFakeX, mFakeY);
                    PadFakeGrid(mRingUpX[x][y], mRingUpY[x][y]);
                    
                    mTri.Add(x, y);
                }
                
                if(mSplineGridHit[x+1][y] == false && mSplineGridHit[x][y-1] == false)
                {
                    mTri.Add(mFakeX, mFakeY);
                    PadFakeGrid(mRingRightX[x][y], mRingRightY[x][y]);
                    
                    mTri.Add(mFakeX, mFakeY);
                    PadFakeGrid(mRingUpX[x][y], mRingUpY[x][y]);
                    
                    mTri.Add(x, y);
                    
                }
                
                if(mSplineGridHit[x-1][y] == false && mSplineGridHit[x][y+1] == false)
                {
                    mTri.Add(mFakeX, mFakeY);
                    PadFakeGrid(mRingLeftX[x][y], mRingLeftY[x][y]);
                    
                    mTri.Add(mFakeX, mFakeY);
                    PadFakeGrid(mRingDownX[x][y], mRingDownY[x][y]);
                    
                    mTri.Add(x, y);
                }
                
                if(mSplineGridHit[x+1][y] == false && mSplineGridHit[x][y+1] == false)
                {
                    mTri.Add(mFakeX, mFakeY);
                    PadFakeGrid(mRingRightX[x][y], mRingRightY[x][y]);
                    
                    mTri.Add(mFakeX, mFakeY);
                    PadFakeGrid(mRingDownX[x][y], mRingDownY[x][y]);
                    
                    mTri.Add(x, y);
                }
            }
        }
    }
    
    
    for(int x = 1;x<SPLINE_GRID_SIZE-1;x++)
    {
        for(int y=1;y<SPLINE_GRID_SIZE-1;y++)
        {
            if(mSplineGridHit[x][y] && mSplineGridHit[x][y+1])
            {
                if(mSplineGridHit[x-1][y] == false && mSplineGridHit[x-1][y+1] == false)
                {
                    aFakeX1=mFakeX;
                    aFakeY1=mFakeY;
                    
                    PadFakeGrid(mRingLeftX[x][y], mRingLeftY[x][y]);
                    
                    aFakeX2=mFakeX;
                    aFakeY2=mFakeY;
                    
                    PadFakeGrid(mRingLeftX[x][y+1], mRingLeftY[x][y+1]);
                    
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y);
                    
                    mTri.Add(x, y+1);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y);
                }
                
                if(mSplineGridHit[x+1][y] == false && mSplineGridHit[x+1][y+1] == false)
                {
                    aFakeX1=mFakeX;
                    aFakeY1=mFakeY;
                    
                    PadFakeGrid(mRingRightX[x][y], mRingRightY[x][y]);
                    
                    aFakeX2=mFakeX;
                    aFakeY2=mFakeY;
                    
                    PadFakeGrid(mRingRightX[x][y+1], mRingRightY[x][y+1]);
                    
                    
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y);
                    
                    
                    
                    mTri.Add(x, y+1);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y);
                }
            }
        }
    }
    
    
    
    for(int x = 1;x<SPLINE_GRID_SIZE-1;x++)
    {
        for(int y=1;y<SPLINE_GRID_SIZE-1;y++)
        {
            if(mSplineGridHit[x][y] && mSplineGridHit[x+1][y])
            {
                if(mSplineGridHit[x][y-1] == false && mSplineGridHit[x+1][y-1] == false)
                {
                    aFakeX1=mFakeX;
                    aFakeY1=mFakeY;
                    
                    PadFakeGrid(mRingUpX[x][y], mRingUpY[x][y]);
                    
                    aFakeX2=mFakeX;
                    aFakeY2=mFakeY;
                    
                    PadFakeGrid(mRingUpX[x+1][y], mRingUpY[x+1][y]);
                    
                    
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y);
                    
                    
                    
                    mTri.Add(x+1, y);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y);
                }
                
                if(mSplineGridHit[x][y+1] == false && mSplineGridHit[x+1][y+1] == false)
                {
                    aFakeX1=mFakeX;
                    aFakeY1=mFakeY;
                    
                    PadFakeGrid(mRingDownX[x][y], mRingDownY[x][y]);
                    
                    aFakeX2=mFakeX;
                    aFakeY2=mFakeY;
                    
                    PadFakeGrid(mRingDownX[x+1][y], mRingDownY[x+1][y]);
                    
                    
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y);
                    
                    
                    
                    mTri.Add(x+1, y);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y);
                }
            }
        }
    }
    
    
    
    for(int x = 1;x<SPLINE_GRID_SIZE-1;x++)
    {
        for(int y=1;y<SPLINE_GRID_SIZE-1;y++)
        {
            if(mSplineGridHit[x][y] && mSplineGridHit[x-1][y]  && mSplineGridHit[x][y-1])
            {
                if(mSplineGridHit[x-1][y-1] == false)
                {
                    aFakeX1=mFakeX;
                    aFakeY1=mFakeY;
                    
                    PadFakeGrid(mRingUpX[x-1][y], mRingUpY[x-1][y]);
                    
                    aFakeX2=mFakeX;
                    aFakeY2=mFakeY;
                    
                    PadFakeGrid(mRingLeftX[x][y-1], mRingLeftY[x][y-1]);
                    
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(aFakeX2, aFakeY2);
                    
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(x-1, y);
                    
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y-1);
                }
            }
            
            
            if(mSplineGridHit[x][y] && mSplineGridHit[x+1][y]  && mSplineGridHit[x][y-1])
            {
                if(mSplineGridHit[x+1][y-1] == false)
                {
                    aFakeX1=mFakeX;
                    aFakeY1=mFakeY;
                    
                    PadFakeGrid(mRingUpX[x+1][y], mRingUpY[x+1][y]);
                    
                    aFakeX2=mFakeX;
                    aFakeY2=mFakeY;
                    
                    PadFakeGrid(mRingRightX[x][y-1], mRingRightY[x][y-1]);
                    
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(aFakeX2, aFakeY2);
                    
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(x+1, y);
                    
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y-1);
                }
            }
            
            
            
            if(mSplineGridHit[x][y] && mSplineGridHit[x+1][y]  && mSplineGridHit[x][y+1])
            {
                if(mSplineGridHit[x+1][y+1] == false)
                {
                    aFakeX1=mFakeX;
                    aFakeY1=mFakeY;
                    
                    PadFakeGrid(mRingDownX[x+1][y], mRingDownY[x+1][y]);
                    
                    aFakeX2=mFakeX;
                    aFakeY2=mFakeY;
                    
                    PadFakeGrid(mRingRightX[x][y+1], mRingRightY[x][y+1]);
                    
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(aFakeX2, aFakeY2);
                    
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(x+1, y);
                    
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y+1);
                }
            }
            
            
            if(mSplineGridHit[x][y] && mSplineGridHit[x-1][y]  && mSplineGridHit[x][y+1])
            {
                if(mSplineGridHit[x-1][y+1] == false)
                {
                    aFakeX1=mFakeX;
                    aFakeY1=mFakeY;
                    
                    PadFakeGrid(mRingDownX[x-1][y], mRingDownY[x-1][y]);
                    
                    aFakeX2=mFakeX;
                    aFakeY2=mFakeY;
                    
                    PadFakeGrid(mRingLeftX[x][y+1], mRingLeftY[x][y+1]);
                    
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(aFakeX2, aFakeY2);
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX1, aFakeY1);
                    mTri.Add(x-1, y);
                    
                    mTri.Add(x, y);
                    mTri.Add(aFakeX2, aFakeY2);
                    mTri.Add(x, y+1);
                }
            }
        }
    }
    
    float aEdgeDist;
    for(int x=0;x<SPLINE_GRID_SIZE;x++)
    {
        for(int y=0;y<SPLINE_GRID_SIZE;y++)
        {
            if(mSplineGridHit[x][y])
            {
                
                aDiffX = mTriGridBaseX[x][y] - mSplineX[0];
                aDiffY = mTriGridBaseY[x][y] - mSplineY[0];
                
                aEdgeDist = aDiffX * aDiffX + aDiffY * aDiffY;
                if(aEdgeDist > 0.25f)aEdgeDist = sqrtf(aEdgeDist);
                
                for(int i=0;i<SPLINE_SAMPLES;i++)
                {
                    aDiffX = mTriGridBaseX[x][y] - mSplineX[i];
                    aDiffY = mTriGridBaseY[x][y] - mSplineY[i];
                    
                    aDist = aDiffX * aDiffX + aDiffY * aDiffY;
                    
                    if(aDist > 0.25f)aDist = sqrtf(aDist);
                    
                    if(aDist < aEdgeDist)aEdgeDist = aDist;
                }
                
                mTriGridEdgeDist[x][y] = aEdgeDist;
            }
        }
    }
    
    
    CalcDistances();
    UpdateAffine();
}

void JigglePoint::CalcDistances()
{
    
    float aDiffX, aDiffY, aDist;
    
    float aBestDist = 1.0f;
    
    for(int i=0;i<SPLINE_SAMPLES;i++)
    {
        aDiffX = mSplineX[i] - mCenterX;
        aDiffY = mSplineY[i] - mCenterY;
        aDist = aDiffX * aDiffX + aDiffY * aDiffY;
        if(aDist > 0.25f)aDist = sqrtf(aDist);
        
        if(aDist > aBestDist)aBestDist = aDist;
    }
    
    float aBestEdgeDist = 1.0f;
    float aEdgeDist;
    for(int x=0;x<SPLINE_GRID_SIZE;x++)
    {
        for(int y=0;y<SPLINE_GRID_SIZE;y++)
        {
            if(mSplineGridHit[x][y])
            {
                aEdgeDist = mTriGridEdgeDist[x][y];
                if(aEdgeDist > aBestEdgeDist)
                {
                    aBestEdgeDist = aEdgeDist;
                }
            }
        }
    }
    
    float aPercentCenter;
    float aPercentEdgeDist;
    float aMaxPercent = 0;
    
    for(int x=0;x<SPLINE_GRID_SIZE;x++)
    {
        for(int y=0;y<SPLINE_GRID_SIZE;y++)
        {
            if(mSplineGridHit[x][y])
            {
                aDiffX = mTriGridBaseX[x][y] - mCenterX;
                aDiffY = mTriGridBaseY[x][y] - mCenterY;
                
                aDist = aDiffX * aDiffX + aDiffY * aDiffY;
                if(aDist > 0.0125f)
                {
                    aDist = sqrtf(aDist);
                    
                    mPushAnimNudgeX[x][y] = aDiffX / aDist;
                    mPushAnimNudgeY[x][y] = aDiffY / aDist;
                }
                else
                {
                    mPushAnimNudgeX[x][y] = 0.0f;
                    mPushAnimNudgeY[x][y] = 0.0f;
                    
                }
                
                aPercentCenter = aDist / aBestDist;
                aPercentEdgeDist = mTriGridEdgeDist[x][y] / aBestEdgeDist;
                
                mTriGridEdgePercent[x][y] = (aPercentEdgeDist) * (aPercentCenter);
                
                aPercentEdgeDist = 1 - aPercentEdgeDist;
                aPercentEdgeDist = aPercentEdgeDist * aPercentEdgeDist * aPercentEdgeDist;
                aPercentEdgeDist = 1 - aPercentEdgeDist;
                
                //aPercentCenter *= aPercentCenter;
                
                if(mBulgeIndex == 1)
                {
                    aPercentCenter = aPercentCenter * aPercentCenter;
                }
                if(mBulgeIndex == 2)
                {
                    aPercentCenter = aPercentCenter * aPercentCenter * aPercentCenter;
                }
                
                aPercentCenter = 1 - (aPercentCenter);
                
                mTriGridPercent[x][y] = aPercentCenter;// * aPercentEdgeDist;
                
                if(aPercentEdgeDist < aPercentCenter)
                {
                    mTriGridPercent[x][y] = aPercentEdgeDist;
                }
                else
                {
                    mTriGridPercent[x][y] = aPercentCenter;
                }
                
                if(mTriGridPercent[x][y] > aMaxPercent)
                {
                    aMaxPercent = mTriGridPercent[x][y];
                }
                
            }
        }
    }
    
    
    if(aMaxPercent > 0.05f)
    {
        for(int x=0;x<SPLINE_GRID_SIZE;x++)
        {
            for(int y=0;y<SPLINE_GRID_SIZE;y++)
            {
                if(mSplineGridHit[x][y])
                {
                    //mTriGridPercent[x][y] /= aMaxPercent;
                }
            }
        }
    }
    
    mVBuffer.mColorCount=0;
    
    
    for(int i=0;i<mTri.mCount;i++)
    {
        int aXIndex = mTri.mX[i];
        int aYIndex = mTri.mY[i];
        
        float aPercet = mTriGridPercent[aXIndex][aYIndex];
        
        mVBuffer.AddRGBA(aPercet, (1.0f - aPercet) * 0.5f, 0, 0.5f);
    }
}

void JigglePoint::MultiTouch(int x, int y, void *pData)
{
    
}

void JigglePoint::MultiRelease(int x, int y, void *pData)
{
    
    //if(mTouch2==pData ||  mTouch==pData)
    //{
    //    mTouch=0;
    //    mTouch2=0;
    //}
    
    if(mSplineTouchIndex != -1)
    {
        if(mJiggleArea != 0)
        {
            if(mJiggleArea->mMode == MODE_EDIT)
            {
                if(mJiggleArea->mModeEdit == MODE_EDIT_SHAPE && mJiggleArea->mSelected == this)
                {
                    SolveSpline();
                    MeshSpline();
                }
            }
        }
    }
    
    mSplineDragging=false;
}

void JigglePoint::MultiDrag(int x, int y, void *pData)
{
    if(mTouch == pData)
    {
        if(mSplineDragging)
        {
            if(mSplineTouchIndex >= 0 && mSplineTouchIndex < mSplineBase.mPointCount)
            {
                float aX = 0.0f, aY = 0.0f;
                Transform(x + mPointDragStartX, y + mPointDragStartY, aX, aY);
                
                mSplineBase.SetPoint(mSplineTouchIndex, aX, aY);
                SolveSpline();
                
                //TODO: ???
                MeshSpline();
                
                //mDeformed=true;
            }
        }
    }
}

void JigglePoint::FlushMultiTouch()
{
    mTouch=0;
    mTouch2=0;
    mHolding=false;
}

float JigglePoint::ClosestControlPoint(float x, float y)
{
    float aDist = 100;
    float aX, aY;
    Transform(x, y, aX, aY);
    mSplineTouchIndex = mSplineBase.GetClosestControlIndex(aX, aY, aDist);
    
    if(mSplineTouchIndex >= 0)return aDist;
    else return 100000000.0f;
}

float JigglePoint::DistToCenter(float x, float y)
{
    float aX, aY;
    Transform(x, y, aX, aY);
    
    return (aX - mCenterX) * (aX - mCenterX) + (aY - mCenterY) * (aY - mCenterY);
}


void JigglePoint::PadFakeGrid(float pX, float pY)
{
    float aX, aY;
    
    Untransform(pX, pY, aX, aY, true);
    
    mTriGridX[mFakeX][mFakeY]=aX;
    mTriGridY[mFakeX][mFakeY]=aY;
    
    mTriGridBaseX[mFakeX][mFakeY]=pX;
    mTriGridBaseY[mFakeX][mFakeY]=pY;
    mSplineGridHit[mFakeX][mFakeY]=true;
    
    mFakeX++;
    if(mFakeX >= SPLINE_GRID_SIZE)
    {
        mFakeX=0;
        mFakeY++;
    }
}

void JigglePoint::ResetEllipse(int pCount)
{
    mDeformed = false;
    mShapeIndex = 1;
    
    if(pCount == -1)pCount=mSplineBase.mPointCount;
    
    mSplineBase.Reset();
    
    if(pCount < SPLINE_MIN_CONTROL)pCount=SPLINE_MIN_CONTROL;
    if(pCount > SPLINE_MAX_CONTROL)pCount=SPLINE_MAX_CONTROL;
    
    
    int aSplineCount = pCount;
    
    float aRadius = 100;
    
    if(gIsLargeScreen)
    {
        
    }
    else
    {
        aRadius = 50;
    }
    
    float aDegrees, aPercent;
    float aDirX, aDirY;
    
    
    for(int i=0;i<aSplineCount;i++)
    {
        aPercent = (float)i / (float)aSplineCount;
        aDegrees = aPercent * 360.0f;
        
        aDirX = Sin(aDegrees);
        aDirY = Cos(aDegrees);
        
        mSplineBase.Add(aDirX * aRadius * 0.85f, aDirY * aRadius * 1.15f);
    }
    
    SolveSpline();
    
    MeshSpline();
    
    UpdateAffine();
}

void JigglePoint::ResetDeformed(int pCount)
{
    
    mDeformed = false;
    
    mShapeIndex = 2;
    
    if(pCount == -1)pCount=mSplineBase.mPointCount;
    
    mSplineBase.Reset();
    
    mSplineBase.SetClosed(true);
    
    if(pCount < SPLINE_MIN_CONTROL)pCount=SPLINE_MIN_CONTROL;
    
    if(pCount > SPLINE_MAX_CONTROL)pCount=SPLINE_MAX_CONTROL;
    
    int aSplineCount = pCount;
    
    float aRadius = 100;
    
    if(gIsLargeScreen)
    {
        
    }
    else
    {
        aRadius = 50;
    }
    
    float aDegrees, aPercent;
    float aDirX, aDirY;
    
    float aSpingle = gRand.GetFloat(-0.65f,1.5f);
    for(int i=0;i<aSplineCount;i++)
    {
        aPercent = (float)i / (float)aSplineCount;
        aDegrees = aPercent * 360.0f;
        
        aDirX = Sin(aDegrees);
        aDirY = Cos(aDegrees);
        
        if(aDirY > 0)
        {
            //aDirY *= aDirY;
            aDirY *= 0.65f;
            
            
            
            mSplineBase.Add(aDirX * aRadius, (aDirY * 0.6666f) * aRadius + aRadius * 0.3333f);
            
        }
        else
        {
            mSplineBase.Add(aDirX * aRadius, aDirY * aRadius + aRadius * 0.3333f);
        }
        
        
    }
    
    SolveSpline();
    MeshSpline();
    UpdateAffine();
}

void JigglePoint::ResetCircle(int pCount)
{
    mDeformed = false;
    mShapeIndex = 0;
    
    if(pCount == -1)pCount=mSplineBase.mPointCount;
    
    mSplineBase.Reset();
    
    if(pCount < SPLINE_MIN_CONTROL)pCount=SPLINE_MIN_CONTROL;
    if(pCount > SPLINE_MAX_CONTROL)pCount=SPLINE_MAX_CONTROL;
    
    
    int aSplineCount = pCount;
    
    float aRadius = 100;
    
    if(gIsLargeScreen)
    {
        
    }
    else
    {
        aRadius = 50;
    }
    
    float aDegrees, aPercent;
    float aDirX, aDirY;
    
    
    for(int i=0;i<aSplineCount;i++)
    {
        aPercent = (float)i / (float)aSplineCount;
        aDegrees = aPercent * 360.0f;
        
        aDirX = Sin(aDegrees);
        aDirY = Cos(aDegrees);
        
        mSplineBase.Add(aDirX * aRadius, aDirY * aRadius);
    }
    
    SolveSpline();
    MeshSpline();
    UpdateAffine();
}

void JigglePoint::AddPoint()
{
    
    if(mSplineBase.mPointCount >= SPLINE_MAX_CONTROL)
    {
        return;
    }
    if(mSplineBase.mPointCount < 3)
    {
        if(mShapeIndex==2)ResetDeformed();
        else if(mShapeIndex==1)ResetEllipse();
        else ResetCircle();
        return;
    }
    
    if(mDeformed == false)
    {
        if(mShapeIndex==2)ResetDeformed(mSplineBase.mPointCount+1);
        else if(mShapeIndex==1)ResetEllipse(mSplineBase.mPointCount+1);
        else ResetCircle(mSplineBase.mPointCount+1);
        
        return;
    }
    
    if((mSplineTouchIndex >= 0 && mSplineTouchIndex <= mSplineBase.mPointCount))
    {
        
    }
    else
    {
        mSplineTouchIndex=0;
    }
    
    mSplineBase.Insert(mSplineTouchIndex, mSplineBase.GetX((float)mSplineTouchIndex-0.5f), mSplineBase.GetY((float)mSplineTouchIndex-0.5f));
    mSplineTouchIndex--;
    if(mSplineTouchIndex<0)mSplineTouchIndex=mSplineBase.mPointCount-1;
    
    SolveSpline();
    MeshSpline();
}

void JigglePoint::RemovePoint()
{
    if(mSplineBase.mPointCount <= SPLINE_MIN_CONTROL)
    {
        return;
    }
    if(mDeformed == false)
    {
        if(mShapeIndex==2)ResetDeformed(mSplineBase.mPointCount-1);
        else if(mShapeIndex==1)ResetEllipse(mSplineBase.mPointCount-1);
        else ResetCircle(mSplineBase.mPointCount-1);
        
        return;
    }
    
    if(mSplineTouchIndex >= 0 && mSplineTouchIndex < mSplineBase.mPointCount)
    {
        
    }
    else
    {
        mSplineTouchIndex=0;
    }
    
    mSplineBase.Delete(mSplineTouchIndex);
    //mSplineTouchIndex++;
    if(mSplineTouchIndex >= mSplineBase.mPointCount)
    {
        mSplineTouchIndex = 0;
    }
    
    SolveSpline();
    MeshSpline();
    //UpdateAffine();
    //CalcDistances();
}




bool JigglePoint::ContainsPoint(float x, float y)
{
    x -= mX;
    y -= mY;
    bool aIntersects = false;
    for(int aStart=0,aEnd=SPLINE_SAMPLES-1;aStart<SPLINE_SAMPLES;aEnd=aStart++)
    {
        if ((((mSplineAffineY[aStart]<=y) && (y<mSplineAffineY[aEnd]))||
             ((mSplineAffineY[aEnd]<=y) && (y<mSplineAffineY[aStart])))&&
            (x < (mSplineAffineX[aEnd] - mSplineAffineX[aStart])*(y - mSplineAffineY[aStart])
             /(mSplineAffineY[aEnd] - mSplineAffineY[aStart]) + mSplineAffineX[aStart]))
            aIntersects=!aIntersects;
    }
    return aIntersects;
}

float JigglePoint::DistanceToPoint(float x, float y)
{
    if(ContainsPoint(x, y))
    {
        return 0;
    }
    
    x -= mX;
    y -= mY;
    
    float aBestDist = 99999.0f * 99999.0f;
    
    float aDiffX, aDiffY, aDist;
    
    for(int i=0;i<SPLINE_SAMPLES;i++)
    {
        aDiffX = mSplineAffineX[i] - x;
        aDiffY = mSplineAffineY[i] - y;
        aDist = aDiffX * aDiffX + aDiffY * aDiffY;
        if(aDist < aBestDist)
        {
            aBestDist=aDist;
        }
    }
    
    if(aBestDist > 0.25f)aBestDist=sqrtf(aBestDist);
    
    return aBestDist;
}


void JigglePoint::SaveCurrentState()
{
    SavedFrameState *aFrameState=new SavedFrameState();
    
    aFrameState->mHoldFactor=mHoldFactor;
    aFrameState->mNippleX=mNippleX;
    aFrameState->mNippleY=mNippleY;
    aFrameState->mTwistRotation=mTwistRotation;
    aFrameState->mPunch=mPunch;
    
    mFrameStateList += aFrameState;
}

void JigglePoint::FlushFrameStates()
{
    FreeList(SavedFrameState, mFrameStateList);
}

void JigglePoint::GoToFrameState(int pIndex)
{
    if(pIndex < 0)pIndex=0;
    if(pIndex >= mFrameStateList.mCount)pIndex=(mFrameStateList.mCount-1);
    
    SavedFrameState *aFrameState = ((SavedFrameState*)mFrameStateList.Fetch(pIndex));
    
    if(aFrameState)
    {
        mHoldFactor=aFrameState->mHoldFactor;
        mNippleX=aFrameState->mNippleX;
        mNippleY=aFrameState->mNippleY;
        mTwistRotation=aFrameState->mTwistRotation;
        mPunch=aFrameState->mPunch;
    }
    
}

void JigglePoint::Accelerometer(float x, float y, float z, bool pReverse)
{
    mLastAccelX=mAccelX;
    mLastAccelY=mAccelY;
    
    mAccelX=x;
    mAccelY=z;
    
    if(mReceivedAccelData == false)
    {
        mReceivedAccelData=true;
        mLastAccelX=mAccelX;
        mLastAccelY=mAccelY;
    }
    
}


void JigglePoint::MovieExportTrimBefore(int pFrame)
{
    FList aNewList;
    for(int i=pFrame;i<mFrameStateList.mCount;i++)
    {
        aNewList += mFrameStateList.mData[i];
    }
    for(int i=0;i<pFrame;i++)
    {
        SavedFrameState *aFrameState = ((SavedFrameState *)mFrameStateList.mData[i]);
        delete aFrameState;
    }
    mFrameStateList.Clear();
    EnumList(SavedFrameState, aState, aNewList)
    {
        mFrameStateList += aState;
    }
}

void JigglePoint::MovieExportTrimAfter(int pFrame)
{
    FList aNewList;
    
    for(int i=0;i<=pFrame;i++)
    {
        aNewList += mFrameStateList.mData[i];
    }
    for(int i=pFrame+1;i<mFrameStateList.mCount;i++)
    {
        SavedFrameState *aFrameState = ((SavedFrameState *)mFrameStateList.mData[i]);
        delete aFrameState;
    }
    
    mFrameStateList.Clear();
    EnumList(SavedFrameState, aState, aNewList)
    {
        mFrameStateList += aState;
    }
}

void JigglePoint::AnimationCancel()
{
    if(mAnimationActive == true)
    {
        mAnimationActive = false;
        mNippleX=0;mNippleY=0;
        mNippleSpeedX=0;mNippleSpeedY=0;
        mTwistRotation = 0.0f;
        mTwistRotationSpeed = 0.0f;
        mPunch = 0.0f;
    }
}

void JigglePoint::AnimationRefresh(int pTick, int pTime)
{
    mAnimationRefresh = false;
    
    mMainAnimationLoop.AnimationRefresh(pTick, pTime);
}

void JigglePoint::AnimationUpdate(int pTick, int pTime)
{
    mNippleSpeedX=0;
    mNippleSpeedY=0;
    
    mAnimationActive = true;
    
    mTwistRotationSpeed = 0.0f;
    
    //if(gJiggle->mModeView == MODE_VIEW_ANIMATE)
    //{
    if(mAnimationRefresh == true)
    {
        AnimationRefresh(pTick, pTime);
        mAnimationRefresh = false;
    }
    
    
    
    
    int aTick = (pTick + mMainAnimationLoop.mAnimationFrameOffset);
    
    if(aTick < 0){aTick += pTime;}
    if(aTick > pTime){aTick -= pTime;}
    if((aTick >= 0) && (aTick < pTime))
    {
        mNippleX = mMainAnimationLoop.mInterpX[aTick];
        mNippleY = mMainAnimationLoop.mInterpY[aTick];
        
        //mTwistRotation = mInterpTwist[aTick];
        //SetPunch(mInterpBulge[aTick]);
        //mPunch = mInterpBulge[aTick];
    }
    
    
    
    
    
    mAnimationGuideSin1 += 2.0f;
    if(mAnimationGuideSin1 > 360)mAnimationGuideSin1 -= 360;
    
    mAnimationGuideSin2 -= 1.5f;
    if(mAnimationGuideSin2 > 0)mAnimationGuideSin2 += 360;
    
    
    mAnimationGuideX = Sin(mAnimationGuideSin1) * 0.5f * 50.0f;
    mAnimationGuideY = -Cos(mAnimationGuideSin1) * 1.25f * 50.0f;
    
    
    mAnimationGuideRadius = 60.0f + Sin(mAnimationGuideSin2) * 20.0f;
    
    
    //}
}


FXMLTag *JigglePoint::SaveXML()
{
    FXMLTag *aJiggleTag = new FXMLTag();
    
    aJiggleTag->SetName("jiggle_point");
    aJiggleTag->AddTag("x", FString(FloatToInt(mX)).c());
    aJiggleTag->AddTag("y", FString(FloatToInt(mY)).c());
    aJiggleTag->AddTag("scale", FString(FloatToInt(mScale)).c());
    aJiggleTag->AddTag("rotation", FString(FloatToInt(mRotation)).c());
    aJiggleTag->AddTag("speed", FString(FloatToInt(mMoveSpeedPercent)).c());
    aJiggleTag->AddTag("power", FString(FloatToInt(mMovePowerPercent)).c());
    aJiggleTag->AddTag("bulge_index", FString(mBulgeIndex).c());
    
    /*
     aJiggleTag->AddTag("continuous_mode", FString((int)(aJiggle->mContinuousMode)).c());
     aJiggleTag->AddTag("continuous_touch", FString((int)(aJiggle->mContinuousDidTouch)).c());
     aJiggleTag->AddTag("continuous_x", FString(FloatToInt(aJiggle->mContinuousStartX)).c());
     aJiggleTag->AddTag("continuous_y", FString(FloatToInt(aJiggle->mContinuousStartY)).c());
     aJiggleTag->AddTag("continuous_sin", FString(FloatToInt(aJiggle->mContinuousSin)).c());
     */
    
    FXMLTag *aSplineTag = new FXMLTag();
    aSplineTag->SetName("spline");
    *aJiggleTag += aSplineTag;
    
    
    for(int i=0;i<mSplineBase.mPointCount;i++)
    {
        FXMLTag *aControlPointTag=new FXMLTag();
        
        aControlPointTag->SetName("control_point");
        
        *aSplineTag += aControlPointTag;
        
        aControlPointTag->AddParamSafeFloat("x", mSplineBase.mX[i]);
        aControlPointTag->AddParamSafeFloat("y", mSplineBase.mY[i]);
        
    }
    
    return aJiggleTag;
}

void JigglePoint::LoadXML(FXMLTag *pTag)
{
    float aX, aY;
    float aScale, aRotation;
    float aSpeed, aPower;
    float aContinuousStartX, aContinuousStartY, aContinuousSin;
    bool aContinuousDidTouch;
    
    bool aContunuous;
    int aBulgeIndex;
    
    if(pTag)
    {
        aX = IntToFloat(FString(pTag->GetSubtagValue("x")).ToInt());
        aY = IntToFloat(FString(pTag->GetSubtagValue("y")).ToInt());
        
        aScale = IntToFloat(FString(pTag->GetSubtagValue("scale")).ToInt());
        aRotation = IntToFloat(FString(pTag->GetSubtagValue("rotation")).ToInt());
        
        aSpeed=IntToFloat(FString(pTag->GetSubtagValue("speed","0.5")).ToInt());
        aPower=IntToFloat(FString(pTag->GetSubtagValue("power","0.5")).ToInt());
        
        aBulgeIndex=FString(pTag->GetSubtagValue("bulge_index")).ToInt();
        
        aContunuous=FString(pTag->GetSubtagValue("continuous_mode")).ToBool();
        aContinuousDidTouch=FString(pTag->GetSubtagValue("continuous_touch")).ToBool();
        aContinuousStartX=IntToFloat(FString(pTag->GetSubtagValue("continuous_x")).ToInt());
        aContinuousStartY=IntToFloat(FString(pTag->GetSubtagValue("continuous_y")).ToInt());
        aContinuousSin=IntToFloat(FString(pTag->GetSubtagValue("continuous_sin")).ToInt());
        
        //JigglePoint *aJiggle = new JigglePoint();
        
        
        mSplineBase.Reset();
        
        mX = aX;
        mY = aY;
        
        mScale = aScale;
        mRotation = aRotation;
        
        mMoveSpeedPercent = aSpeed;
        mMovePowerPercent = aPower;
        
        mBulgeIndex = aBulgeIndex;
        
        EnumTagsMatching(pTag, aSplineTag , "spline")
        {
            EnumTagsMatching(aSplineTag, aControlPointTag, "control_point")
            {
                float aSplineX = aControlPointTag->GetParamSafeFloat("x");
                float aSplineY = aControlPointTag->GetParamSafeFloat("y");
                mSplineBase.Add(aSplineX, aSplineY);
            }
        }
        
        SolveSpline();
        MeshSpline();
        Draw();
        
    }
    
}



