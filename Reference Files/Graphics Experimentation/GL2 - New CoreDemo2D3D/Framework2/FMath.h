//
//  FMath.h
//  CoreDemo
//
//  Created by Nick Raptis on 10/11/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#ifndef FRAMEWORK_MATH_H
#define FRAMEWORK_MATH_H

#include "FVec2.h"
#include "FVec3.h"

extern const float fmath_pi;

float fmath_radiansToDegrees(float pRadians);
float fmath_degreesToRadians(float pDegrees);

float fmath_distance(float x1, float y1, float x2, float y2);
inline float fmath_distance(float x1, float y1, FVec2 p2){return fmath_distance(x1,y1,p2.mX,p2.mY);}
inline float fmath_distance(FVec2 p1, float x2, float y2){return fmath_distance(p1.mX,p1.mY,x2,y2);}
inline float fmath_distance(FVec2 p1, FVec2 p2){return fmath_distance(p1.mX,p1.mY,p2.mX,p2.mY);}

float fmath_distanceSquared(float x1, float y1, float x2, float y2);
inline float fmath_distanceSquared(float x1, float y1, FVec2 p2){return fmath_distanceSquared(x1,y1,p2.mX,p2.mY);}
inline float fmath_distanceSquared(FVec2 p1, float x2, float y2){return fmath_distanceSquared(p1.mX,p1.mY,x2,y2);}
inline float fmath_distanceSquared(FVec2 p1, FVec2 p2){return fmath_distanceSquared(p1.mX,p1.mY,p2.mX,p2.mY);}

float fmath_distanceSquared(float x1, float y1, float z1, float x2, float y2, float z2);
inline float fmath_distanceSquared(FVec3 p1, FVec3 p2){return fmath_distanceSquared(p1.mX,p1.mY,p1.mZ,p2.mX,p2.mY,p2.mZ);}

bool fmath_circleCircleIntersect(FVec2 pPos1, float pRadius1, FVec2 pPos2, float pRadius2);

FVec2 AngleToVector(float pDegrees);
FVec3 AngleToFVec3D(float pDegrees);

float fmath_sin(float pDegree);
float fmath_cos(float pDegrees);
float fmath_tan(float pDegrees);

bool fmath_isPowerOfTwo(int pNumber);

int fmath_closestPowerOfTwo(int pNumber);

float fmath_distanceBetweenAngles(float theDegrees1, float theDegrees2);

float fmath_faceTarget(float pOriginX, float pOriginY, float pTargetX=0, float pTargetY=0);
inline float fmath_faceTarget(FVec2 pPos, FVec2 pTarget=FVec2(0,0)){return fmath_faceTarget(pPos.mX, pPos.mY, pTarget.mX, pTarget.mY);}

FVec2 PivotPoint(FVec2 pPoint, float pDegrees, FVec2 pCenter, float pScale=1.0f);
FVec2 PivotPoint(FVec2 pPoint, float pDegrees);

float MinC(float pNum, float pMin);
float MaxC(float pNum, float pMax);
float Trim(float pNum, float pMin=-10000000.0f, float pMax=10000000.0f);

//(Bx - Ax) * (Cy - Ay) - (By - Ay) * (Cx - Ax)
int SideOfLine(float pTestX, float pTestY, float pLineX1, float pLineY1, float pLineX2, float pLineY2);

FVec3 Rotate3D(FVec3 pPoint, FVec3 pAxis, float pDegrees);

bool TriangleIsClockwise(float pX1, float pY1, float pX2, float pY2, float pX3, float pY3);

bool QuadContainsPoint(float pPointX, float pPointY, float pX1, float pY1, float pX2, float pY2, float pX3, float pY3, float pX4, float pY4);

float TriangleArea(float x1, float y1, float x2, float y2, float x3, float y3);
bool Between(float x1, float y1, float x2, float y2, float x3, float y3);
bool SegmentsIntersect(FVec2 theStart1, FVec2 theEnd1, FVec2 theStart2, FVec2 theEnd2);


#endif
