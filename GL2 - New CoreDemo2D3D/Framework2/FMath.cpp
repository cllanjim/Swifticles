//
//  FMath.cpp
//  CoreDemo
//
//  Created by Nick Raptis on 10/11/13.
//  Copyright (c) 2013 Union AdWorks Inc. All rights reserved.
//

#include "FMath.h"
#include "stdafx.h"

const float fmath_pi = 3.1415926535897932384626433832795028841968;

float fmath_radiansToDegrees(float pRadians)
{
    return pRadians * 57.2957795130823208767981548141052;
}

float fmath_degreesToRadians(float pDegrees)
{
    return pDegrees * 0.01745329251994329576923690768488;
}

float fmath_distance(float x1, float y1, float x2, float y2)
{
	float aXDiff=x1-x2;
	float aYDiff=y1-y2;
	return sqrtf(aXDiff*aXDiff+aYDiff*aYDiff);
}

float fmath_distanceSquared(float x1, float y1, float x2, float y2)
{
	float aXDiff=x1-x2;
	float aYDiff=y1-y2;
	return aXDiff*aXDiff+aYDiff*aYDiff;
}


float fmath_distanceSquared(float x1, float y1, float z1, float x2, float y2, float z2)
{
    float aXDiff=x1-x2;
	float aYDiff=y1-y2;
    float aZDiff=z1-z2;
	return aXDiff*aXDiff+aYDiff*aYDiff+aZDiff*aZDiff;
}

bool fmath_circleCircleIntersect(FVec2 pPos1, float pRadius1, FVec2 pPos2, float pRadius2)
{
	float aRadiiSum=pRadius1+pRadius2;
	return fmath_distanceSquared(pPos1,pPos2)<=aRadiiSum*aRadiiSum;
}

FVec2 AngleToVector(float pDegrees)
{
    return FVec2(fmath_sin(pDegrees),fmath_cos(pDegrees));
}

FVec3 AngleToFVec3D(float pDegrees)
{
    return FVec3(fmath_sin(pDegrees), fmath_cos(pDegrees), 0.0f);
}

bool fmath_isPowerOfTwo(int pNumber){return(pNumber&-pNumber)==pNumber;}

int fmath_closestPowerOfTwo(int pNumber)
{
	unsigned int aReturn=1;
	while((unsigned int)pNumber<aReturn&&aReturn!=0x40000000)aReturn=(aReturn<<1);
	return (int)aReturn;
}

int SideOfLine(float pTestX, float pTestY, float pLineX1, float pLineY1, float pLineX2, float pLineY2)
{
    float aCross = (pLineX2 - pLineX1) * (pTestY - pLineY1) - (pLineY2 - pLineY1) * (pTestX - pLineX1);
    if(aCross > 0)return 1;
    else if(aCross < 0)return -1;
    else return 0;
}

float fmath_sin(float pDegrees){return sin(fmath_degreesToRadians(pDegrees));}
float fmath_cos(float pDegrees){return cos(fmath_degreesToRadians(pDegrees));}
float fmath_tan(float pDegrees){return tan(fmath_degreesToRadians(pDegrees));}

float fmath_distanceBetweenAngles(float theDegrees1, float theDegrees2)
{
	float aDifference = theDegrees1 - theDegrees2;
	aDifference = (float)fmod(aDifference,360);
	if(aDifference < 0)aDifference+=360;
	if(aDifference > 180)return 360 - aDifference;
	else return -aDifference;
}

float fmath_faceTarget(float pOriginX, float pOriginY, float pTargetX, float pTargetY)//(FVec2 &pPos, FVec2 &pTarget)
{
	return fmath_radiansToDegrees(-atan2f(pOriginX - pTargetX, pOriginY - pTargetY));
}

float Trim(float pNum, float pMin, float pMax)
{
	float aReturn=pNum;
	if(aReturn<pMin)aReturn=pMin;
	if(aReturn>pMax)aReturn=pMax;
	return aReturn;
}

float MinC(float pNum, float pMin)
{
	if(pNum > pMin)return pNum;
	else return pMin;
}

float MaxC(float pNum, float pMax)
{
	if(pNum < pMax)return pNum;
	else return pMax;
}

bool TriangleIsClockwise(float pX1, float pY1, float pX2, float pY2, float pX3, float pY3)
{
    return (pX2-pX1)*(pY3-pY2)-(pX3-pX2)*(pY2-pY1) > 0;
}

bool QuadContainsPoint(float pPointX, float pPointY, float pX1, float pY1, float pX2, float pY2, float pX3, float pY3, float pX4, float pY4)
{
    float aX[4];
    float aY[4];
    
    aX[0]=pX1;
    aX[1]=pX2;
    aX[2]=pX3;
    aX[3]=pX4;
    
    aY[0]=pY1;
    aY[1]=pY2;
    aY[2]=pY3;
    aY[3]=pY4;
    
    bool aReturn = false;
	for(int aStart=0,aEnd=3;aStart<4;aEnd=aStart++)
	{
		if ((((aY[aStart]<=pPointY) && (pPointY<aY[aEnd]))||
             ((aY[aEnd]<=pPointY) && (pPointY<aY[aStart])))&&
			(pPointX < (aX[aEnd] - aX[aStart])*(pPointY - aY[aStart])
             /(aY[aEnd] - aY[aStart]) + aX[aStart]))
        {
			aReturn=!aReturn;
        }
    }
    
	return aReturn;
    
}

FVec2 PivotPoint(FVec2 pPoint, float pDegrees, FVec2 pCenter, float pScale)
{
    FVec2 aReturn;
    
    float aDiffX = pCenter.mX - pPoint.mX;
    float aDiffY = pCenter.mY - pPoint.mY;
    
    float aDist = aDiffX * aDiffX + aDiffY * aDiffY;
    
    if(aDist > 0.25f)
    {
        
        aDist=sqrtf(aDist);
        
        float aRotation = fmath_faceTarget(aDiffX, aDiffY);
        aRotation = pDegrees + aRotation;
        
        //aReturn.mX = pCenter.mX + fmath_sin(180.0f -aRotation) * pScale * aDist;
        //aReturn.mY = pCenter.mY + fmath_cos(180.0f -aRotation) * pScale * aDist;
        
        aReturn.mX = pCenter.mX + fmath_sin(aRotation) * pScale * aDist;
        aReturn.mY = pCenter.mY + fmath_cos(aRotation) * pScale * aDist;
    }
    else
    {
        aReturn = pPoint;
        
        aDiffX=0.0f;
        aDiffY=0.0f;
        
        aDist=0.0f;
    }
    return aReturn;
}

FVec2 PivotPoint(FVec2 pPoint, float pDegrees)
{
    return PivotPoint(pPoint, pDegrees, FVec2(0,0), 1.0f);
}

FVec3 Rotate3D(FVec3 pPoint, FVec3 pAxis, float pDegrees)
{
	FVec3 aCentroid=pPoint;
	FVec3 aDir=FVec3(pAxis.mX,pAxis.mY,pAxis.mZ);
	
	float aLength = aDir.Length();
	
	if(aLength > 0.015f)
	{
		aDir /= aLength;
	}
	else
	{
		aDir.mX=1;
		aDir.mY=0;
		aDir.mZ=0;
	}
	
	float aDirX=aDir.mX;
	float aDirY=aDir.mY;
	float aDirZ=aDir.mZ;
	
	float aX=aCentroid.mX;
	float aY=aCentroid.mY;
	float aZ=aCentroid.mZ;
	
	float aCos = fmath_cos(pDegrees);
	float aSin = fmath_sin(pDegrees);
	float aCosInv=1-aCos;
	
	float xy = aDirX*aDirY*aCosInv;
	float xz = aDirX*aDirZ*aCosInv;
	float yz = aDirY*aDirZ*aCosInv;
	
	float xs = aDirX*aSin;
	float ys = aDirY*aSin;
	float zs = aDirZ*aSin;
    
	aCentroid.mX = (aDirX*aDirX*aCosInv+aCos) * aX + (xy-zs) * aY + (xz+ys) * aZ;
	aCentroid.mY = (xy+zs) * aX + (aDirY*aDirY*aCosInv+aCos) * aY + (yz-xs) * aZ;
	aCentroid.mZ = (xz+ys) * aX + (yz-xs) * aY + (aDirZ*aDirZ*aCosInv+aCos) * aZ;
    
	return aCentroid;
}

float TriangleArea(float x1, float y1, float x2, float y2, float x3, float y3)
{
	return (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1);
}

bool Between(float x1, float y1, float x2, float y2, float x3, float y3)
{
	if (x1 != x2)return (x1 <= x3 && x3 <= x2) || (x1 >= x3 && x3 >= x2);
	else return (y1 <= y3 && y3 <= y2) || (y1 >= y3 && y3 >= y2);
}

bool SegmentsIntersect(FVec2 theStart1, FVec2 theEnd1, FVec2 theStart2, FVec2 theEnd2)
{
	float aArea1, aArea2, aArea3, aArea4;
	if((aArea1 = TriangleArea(theStart1.mX, theStart1.mY, theEnd1.mX, theEnd1.mY, theStart2.mX, theStart2.mY)) == 0)
	{
		if (Between(theStart1.mX, theStart1.mY, theEnd1.mX, theEnd1.mY, theStart2.mX, theStart2.mY))
		{
			return true;
		}
		else
		{
			if (TriangleArea(theStart1.mX, theStart1.mY, theEnd1.mX, theEnd1.mY, theEnd2.mX, theEnd2.mY) == 0)
			{
				if(Between(theStart2.mX, theStart2.mY, theEnd2.mX, theEnd2.mY, theStart1.mX, theStart1.mY))
				{
					return true;
				}
				if(Between (theStart2.mX, theStart2.mY, theEnd2.mX, theEnd2.mY, theEnd1.mX, theEnd1.mY))
				{
					return true;
				}
				return false;
			}
			else return false;
		}
	}
	if ((aArea2 = TriangleArea(theStart1.mX, theStart1.mY, theEnd1.mX, theEnd1.mY, theEnd2.mX, theEnd2.mY)) == 0)
	{
		return Between(theStart1.mX, theStart1.mY, theEnd1.mX, theEnd1.mY, theEnd2.mX, theEnd2.mY);
	}
	if ((aArea3 = TriangleArea(theStart2.mX, theStart2.mY, theEnd2.mX, theEnd2.mY, theStart1.mX, theStart1.mY)) == 0)
	{
		if (Between(theStart2.mX, theStart2.mY, theEnd2.mX, theEnd2.mY, theStart1.mX, theStart1.mY))
		{
			return true;
		}
		else
		{
			if (TriangleArea(theStart2.mX, theStart2.mY, theEnd2.mX, theEnd2.mY, theEnd1.mX, theEnd1.mY) == 0)
			{
				if(Between(theStart1.mX, theStart1.mY, theEnd1.mX, theEnd1.mY, theStart2.mX, theStart2.mY))
				{
					return true;
				}
				if(Between (theStart1.mX, theStart1.mY, theEnd1.mX, theEnd1.mY, theEnd2.mX, theEnd2.mY))
				{
					return true;
				}
				return false;
			}
			return false;
		}
	}
	if ((aArea4 = TriangleArea(theStart2.mX, theStart2.mY, theEnd2.mX, theEnd2.mY, theEnd1.mX, theEnd1.mY)) == 0)
	{
        return Between(theStart2.mX, theStart2.mY, theEnd2.mX, theEnd2.mY, theEnd1.mX, theEnd1.mY);
	}
	return (((aArea1 > 0) ^ (aArea2 > 0)) && ((aArea3 > 0) ^ (aArea4 > 0)));
}
