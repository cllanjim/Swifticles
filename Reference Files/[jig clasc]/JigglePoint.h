#ifndef JIGGLE_POINT_H
#define JIGGLE_POINT_H

#define JIGGLE_TYPE_CIRCLE 0

#define SPLINE_SAMPLES 512

#define SPLINE_GRID_SIZE 28

#define SPLINE_MAX_CONTROL 30
#define SPLINE_MIN_CONTROL 4






#include "TriBuffer.h"
#include "FSpline.h"
#include "FVertexBuffer.h"
#include "FPointList.h"
#include "LineTracer.h"
#include "JiggleAnimationLoop.h"
#include "FXML.h"

class MainMenu;
class JiggleArea;

class JigglePoint
{
public:
    JigglePoint();
    ~JigglePoint();
    
    void                            Update();
    void                            Draw();
    
    void                            DrawMarkers(bool pSelected, float pOpacity);
    void                            DrawAnimMarkers(bool pSelected, float pOpacity);
    
    void                            DrawGrid();
    void                            DrawPercentageGrid();
    
    void                            DrawCenters();
    
    void                            UpdateAffine();
    
    FXMLTag                         *SaveXML();
    void                            LoadXML(FXMLTag *pTag);
    
    
    JiggleArea                      *mJiggleArea;
    MainMenu                        *mMainMenu;
    
    void                            MovieExportTrimBefore(int pFrame);
    void                            MovieExportTrimAfter(int pFrame);
    
    void                            MultiTouch(int x, int y, void *pData);
    void                            MultiRelease(int x, int y, void *pData);
    void                            MultiDrag(int x, int y, void *pData);
    void                            FlushMultiTouch();
    
    float                           ClosestControlPoint(float x, float y);
    float                           DistToCenter(float x, float y);
    
    void                            Reset();
    
    void                            Transform(float x, float y, float &pNewX, float &pNewY);
    void                            Untransform(float x, float y, float &pNewX, float &pNewY, bool pSkipTranslate=false);
    
    void                           SetCenter(float x, float y);
    
    bool                           ContainsPoint(float x, float y);
    float                                  DistanceToPoint(float x, float y);
    
    void                           AddScale(float pAmount){SetScale(mScale+pAmount);}
    void                           SetScale(float pScale);
    
    void                           AddRotation(float pAmount){SetRotation(mRotation+pAmount);}
    void                           SetRotation(float pRotation);
    
    void                           SetPunch(float pPunch);
    
    void                           AddTranslation(float x, float y){SetTranslation(mX+x, mY+y);}
    void                           SetTranslation(float x, float y);
    
    FList                                  mFrameStateList;
    
    void                           SaveCurrentState();
    void                           FlushFrameStates();
    void                           GoToFrameState(int pIndex);
    
    void                           SetHoldNipple(float x, float y);
    void                           Accelerometer(float x, float y, float z, bool pReverse);
    
    
    FTexture                        *mTexture;
    
    float                           mX, mY;
    float                           mScale;
    
    float                           mCenterX, mCenterY;
    
    
    float                           mRotation;
    

    int                            mDrawSkipFudge;
    
    int                            mFreshTimer;
    float                          mFreshFade;
    float                          mFreshSin;
    
    
    float                          mTwistRotation;
    float                          mTwistRotationSpeed;
    
    float                          mPunch;
    float                          mPunchSpeed;
    
    float                          mBoxLeft;
    float                          mBoxRight;
    float                          mBoxTop;
    float                          mBoxBottom;
    
    
    float                          mPointDragStartX;
    float                          mPointDragStartY;
    
    
    FSpline                         mSplineBase;
    int                            mSplineTouchIndex;
    
    bool                           mSplineDragging;
    
    void                           *mTouch;
    void                           *mTouch2;
    
    int                            mTouchX1;
    int                            mTouchY1;
    int                            mTouchX2;
    int                            mTouchY2;
    
    void                           AddTriangle(int x1, int y1, int x2, int y2, int x3, int y3);
    void                           AddGimpTriangle(float x1, float y1, float x2, float y2, int pIndexX, int pIndexY);
    
    void                           SolveSpline();
    void                           MeshSpline();
    void                           CalcDistances();
    
    void                           ClosestPoint(float x1, float y1, float x2, float y2, float pLength, float x, float y, float &pClosestX, float &pClosestY);
    
    float                                  mSplineX[SPLINE_SAMPLES];
    float                                  mSplineY[SPLINE_SAMPLES];
    
    float                                  mSplineAffineX[SPLINE_SAMPLES];
    float                                  mSplineAffineY[SPLINE_SAMPLES];
    
    //float                                mSplineDirX[SPLINE_SAMPLES];
    //float                                mSplineDirY[SPLINE_SAMPLES];
    //float                                mSplineLength[SPLINE_SAMPLES];
    
    
    
    bool                                    mSplineGridHit[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    
    void                                    ClosestPointInDirection(int pGridX, int pGridY, int pDir, float &pClosestX, float &pClosestY);
    
    
    
    int                                     mDrawSkips;
    
    
    
    void                                    PadFakeGrid(float pX, float pY);
    
    int                                     mFakeX;
    int                                     mFakeY;
    
    float                                   mTriGridX[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    float                                   mTriGridY[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    float                                   mTriGridZ[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    
    float                                   mTriGridPercent[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    float                                   mTriGridEdgePercent[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    
    float                                   mTriGridDist[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE];
    float                                   mTriGridEdgeDist[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE];
    
    
    //float                                   mTriGridEdgeDist[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE];
    
    
    
    float                                   mTriGridAffineX[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    float                                   mTriGridAffineY[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    
    float                                   mTriGridBaseX[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    float                                   mTriGridBaseY[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    
    bool                                    mRingExists[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    
    float                                   mRingUpX[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE];
    float                                   mRingUpY[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE];
    
    float                                   mRingDownX[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE];
    float                                   mRingDownY[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE];
    
    float                                   mRingRightX[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE];
    float                                   mRingRightY[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE];
    
    float                                   mRingLeftX[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE];
    float                                   mRingLeftY[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE];
    
    float                                   mNippleSpeedSizeFactor;
    float                                   mNippleSpeedSizeFactorDrag;
    float                                   mNippleSpeedX, mNippleSpeedY;
    float                                   mNippleX, mNippleY;
    
    float                                   mAccelX, mAccelY, mLastAccelX, mLastAccelY;
    bool                                    mReceivedAccelData;
    
    float                                   mPushAnimNudgeX[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    float                                   mPushAnimNudgeY[SPLINE_GRID_SIZE][SPLINE_GRID_SIZE*2];
    
    
    
    
    
    bool                                    mSelectIgnore;
    
    bool                                    mHolding;
    
    bool                                    mDeformed;
    
    int                                     mShapeIndex;
    
    int                                     mKillTimer;
    
    int                                     mTouchStartX;
    int                                     mTouchStartY;
    
    int                                     mTouchStartMouseX;
    int                                     mTouchStartMouseY;
    
    
    FColor                                  mColorSplineControlPointOuter[3];
    FColor                                  mColorSplineControlPointInner[3];
    FColor                                  mColorSplineLine[3];
    FColor                                  mColorSplineFill[3];
    
    FColor                                  mColorSplineControlPointOuterSelected[3];
    FColor                                  mColorSplineControlPointInnerSelected[3];
    FColor                                  mColorSplineLineSelected[3];
    FColor                                  mColorSplineFillSelected[3];
    
    void                                    SetSplineCount(int pCount);
    
    void                                    SetBulge(int pBulgeIndex){mBulgeIndex=pBulgeIndex;CalcDistances();}
    int                                     mBulgeIndex;
    
    void                                    ResetCircle(int pCount=-1);
    
    void                                    ResetEllipse(int pCount=-1);
    void                                    ResetDeformed(int pCount=-1);
    
    void                                    AddPoint();
    void                                    RemovePoint();
    
    void                                    ResetCenter(){mCenterX=0;mCenterY=0;CalcDistances();}
    void                                    SetIgnore(bool pState){mSelectIgnore=pState;}
    
    
    TriBuffer                               mTri;
    
    float                                   mHoldFactor;
    
    LineTracer                              mLine;
    FVertexBuffer                           mVBuffer;
    
    float                                   mMoveSpeedPercent;
    float                                   mMovePowerPercent;
    
    
    
    
    void                                    AnimationUpdate(int pTick, int pTime);
    
    
    void                                    AnimationRefresh(int pTick, int pTime);
    void                                    AnimationCancel();
    
    JiggleAnimationLoop                     mMainAnimationLoop;
    
    bool                                    mAnimationActive;
    bool                                    mAnimationRefresh;
    
    
    float                                   mAnimationGuideX;
    float                                   mAnimationGuideY;
    
    float                                   mAnimationGuideRadius;
    float                                   mAnimationGuidePower;
    
    float                                   mAnimationGuideSin1;
    float                                   mAnimationGuideSin2;
    
    
    
    
};

#endif










