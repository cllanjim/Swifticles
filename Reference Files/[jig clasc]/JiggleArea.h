//
//  JiggleArea.h
//  Jiggle
//
//  Created by Nick Raptis on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#ifndef JIGGLE_AREA_H
#define JIGGLE_AREA_H

#include "GLApp.h"
#include "TriBuffer.h"
#include "SavedJiggle.h"
#include "JigglePoint.h"
#include "FImage.h"
#include "FSprite.h"
#include "FXML.h"
#include "FGestureView.h"
#include "SavedFrameState.h"

#define MODE_VIEW 0
#define MODE_EDIT 1
#define MODE_ANIM 2

//#define MODE_BOUNCE 2

//#define MODE_PAN 2

#define MODE_VIEW_TOUCH 0
#define MODE_VIEW_SHAKE 1

#define MODE_EDIT_AFFINE 0
#define MODE_EDIT_SHAPE 1
#define MODE_EDIT_CENTER 2

#define MODE_ANIM_PLAY 0
#define MODE_ANIM_GUIDE 1
#define MODE_ANIM_TWIDDLE 2


//class JigglePoint;
class JiggleArea : public FGestureView
{
public:
    JiggleArea();
    virtual ~JiggleArea();
    
    GLApp                                           *mApp;
    
    void                                            SetUp(float pX, float pY, float pWidth, float pHeight);
    
    virtual void                                    Update();
	virtual void                                    Draw();
    
    bool                                            AllowAction();
    
    int                                             mMode;
    int                                             mModeEdit;
    int                                             mModeView;
    int                                             mModeAnim;
    
    void                                            SetMode(int pMode);
    void                                            SetMode(int pMode, int pSubmode);
    
    void                                            DeleteAll();
    void                                            DeleteSelected();
    
    
    virtual void                                    TouchDown(float pX, float pY, void *pData){mTouchX = pX;mTouchY = pY; MultiTouch(pX, pY, pData);Touch(pX, pY);}
    virtual void                                    TouchMove(float pX, float pY, void *pData){mTouchX = pX;mTouchY = pY;MultiDrag(pX, pY, pData);Drag(pX, pY);}
    virtual void                                    TouchUp(float pX, float pY, void *pData){MultiRelease(pX, pY, pData);Release(pX, pY);}
    virtual void                                    TouchFlush(){FlushMultiTouch();}
    
    void                                            Touch(int x, int y);
    void                                            Drag(int x, int y);
    void                                            Release(int x, int y);
    
    void                                            MultiTouch(int x, int y, void *pData);
    void                                            MultiRelease(int x, int y, void *pData);
    void                                            MultiDrag(int x, int y, void *pData);
    void                                            FlushMultiTouch();
    
    virtual void                                    Accelerometer(float x, float y, float z, bool pReverse);
    
    void                                            SamplePoint(float x, float y, float &u, float &v);
    //void                                          SamplePointRetina(float x, float y, float &u, float &v);
    
    
    void                                            SetImage(FImage *pImage);
    void                                            SetImage(unsigned int *pData, int pWidth, int pHeight);
    
    bool                                            mPanning;
    float                                           mPanStartX;
    float                                           mPanStartY;
    
    //void                                          StartPinch();
    //void                                          EndPinch(float pScale);
    
    bool                                            mPinching;
    float                                           mPinchStartScale;
    
    //void                                          StartRotate();
    //void                                          EndRotate(float pDegrees);
    
    bool                                            mRotating;
    float                                           mRotateStartRotation;
    void                                            CheckGestures();
    
    
    
    
    //Gesture Functions...
    virtual void                                    PanBegin(float pX, float pY);
    virtual void                                    Pan(float pX, float pY);
    virtual void                                    PanEnd(float pX, float pY, float pSpeedX, float pSpeedY);
    
    virtual void                                    PinchBegin(float pScale);
    virtual void                                    Pinch(float pScale);
    virtual void                                    PinchEnd(float pScale);
    
    virtual void                                    RotateStart(float pRotation);
    virtual void                                    Rotate(float pRotation);
    virtual void                                    RotateEnd(float pRotation);
    
    
    
    bool                                            mPanAndZoom;
    void                                            PanAndZoomSet(bool pState);
    
    
    
    FImage                                          mImage;
    FSprite                                         mSprite;
    FTexture                                        *mTexture;
    int                                             mImageWidth;
    int                                             mImageHeight;
    int                                             mImageOffsetX;
    int                                             mImageOffsetY;
    float                                           mStartU,mStartV,mEndU,mEndV;
    void                                            KillGestures();
    
    JigglePoint                                     *GetClosest(int x, int y, float pDist=50);
    
    FList                                           mAddList;
    
    FList                                           mList;
    FList                                           mKillList;
    FList                                           mDeleteList;
    
    JigglePoint                                     *mSelected;
    JigglePoint                                     *mLastSelected;
    JigglePoint                                     *mLastSelectedIncludingNull;
    
    
    JigglePoint                                     *SelectAny();
    
    void                                            Select(JigglePoint* pSelect);
    void                                            Deselect();
    
    float                                           mGlobalScale;
    float                                           mGlobalTranslateX;
    float                                           mGlobalTranslateY;
    bool                                            mGlobalScaleEdit;
    
    float                                           mGlobalScaleTarget;
    float                                           mGlobalTranslateXTarget;
    float                                           mGlobalTranslateYTarget;
    bool                                            mGlobalTranslateEdit;
    
    float                                           mGlobalScaleStart;
    float                                           mGlobalTranslateXStart;
    float                                           mGlobalTranslateYStart;
    
    
    void                                            AddPoint(int pType);
    
    void                                            Save(FString pName, int pIndex, const char *pAutoSaveName=0);
    void                                            Load(int pIndex);
    
    void                                            LoadAuto();
    void                                            SaveAuto();
    
    void                                            LoadDemo(int pIndex);
    void                                            LoadXML(FString pPath);
    
    float                                           mTranslateX;
    float                                           mTranslateY;
    
    
    
    bool                                            mRebind;
    
    int                                             mCurrentFileIndex;
    FString                                         mCurrentFileName;
    
    
    SavedJiggle                                     *FetchList(int pIndex);
    SavedJiggle                                     *FetchJiggle(int pIndex);
    
    //Spline Ones..
    void                                            SelectedResetCircle(){if(mSelected)mSelected->ResetCircle();}
    
    void                                            SelectedResetEllipse(){if(mSelected)mSelected->ResetEllipse();}
    void                                            SelectedResetDeformed(){if(mSelected)mSelected->ResetDeformed();}
    
    void                                            SelectedAddPoint(){if(mSelected)mSelected->AddPoint();}
    void                                            SelectedRemovePoint(){if(mSelected)mSelected->RemovePoint();}
    
    void                                            SelectedResetCenter(){if(mSelected)mSelected->ResetCenter();}
    void                                            SelectedSetBulge(int pIndex){if(mSelected)mSelected->SetBulge(pIndex);}
    
    void                                            SelectedSetJiggleSpeed(float pPercent);
    void                                            SelectedSetJigglePower(float pPercent);
    
    
    void                                            SelectedSetIgnore(bool pState){if(mSelected)mSelected->SetIgnore(pState);}
    
    bool                                            mTargetAll;
    
    //float                           mStereoscopicSpreadMin;
    //float                           mStereoscopicSpreadMax;
    //float                           mStereoscopicWhite;
    //float                           mStereoscopicAlphaMin;
    //float                           mStereoscopicAlphaMax;
    
    
    bool                                            mDisplayImage;
    bool                                            mFadeImage;
    
    bool                                            mDisplayCenters;
    bool                                            mDisplayMarkers;
    bool                                            mDisplayGrid;
    bool                                            mDisplayWeights;
    bool                                            mDisplayEdgePercent;
    bool                                            mDisplayAnimationMarkers;
    
    
    
    void                            RecordStart();
    void                            RecordStop();
    void                            RecordClear();
    bool                            mRecording;
    int                             mRecordFrameCount;
    
    void                            MovieExportPreviewStart(bool pAutoPlay=true);
    void                            MovieExportPreviewStop();
    void                            MovieExportPreviewFrameJump(int pIndex);
    void                            MovieExportPreviewFrameJumpPercent(float pPercent);
    void                            MovieExportPreviewFrameNext();
    void                            MovieExportPreviewFramePrev();
    void                            MovieExportPreviewFrameNext10();
    void                            MovieExportPreviewFramePrev10();
    
    bool                            mRecordMode;
    bool                            mRecordPreviewAutoPlay;
    int                             mRecordFrame;
    bool                            mRecordPreviewAutoSlow;
    int                             mRecordPreviewAutoSlowTimer;
    bool                            mRecordExporting;
    bool                            mRecordExportCancel;
    int                             mRecordExportQuality;
    bool                            MovieExportTrimAfter();
    bool                            MovieExportTrimBefore();
    
    int                             mAnimationTime;
    int                             mAnimationFrame;
    bool                            mAnimationTargetAll;
    
    
    bool                            mAnimationPlaying;
    
    bool                            mAnimationSlow;
    int                             mAnimationSlowTick;
    
    
    
    
    
};

extern JiggleArea *gJiggle;

#endif



