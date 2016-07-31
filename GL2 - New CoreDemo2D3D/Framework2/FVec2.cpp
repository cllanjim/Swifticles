//
//  FVec2.cpp
//  SRT
//
//  Created by Nick Raptis on 10/8/13.
//  Copyright (c) 2013 Froggy Studios LLC. All rights reserved.
//

#include "FVec2.h"
#include "stdafx.h"

float FVec2::Length()
{
    float aLength = mX * mX + mY * mY;
    if(aLength > SQRT_EPSILON)aLength = sqrtf(aLength);
    return aLength;
}

float FVec2::LengthSquared()
{
    return mX * mX + mY * mY;
}

void FVec2::Normalize()
{
    float aLength = mX * mX + mY * mY;
    if(aLength > SQRT_EPSILON)
    {
        aLength = sqrtf(aLength);
        mX /= aLength;
        mY /= aLength;
    }
    else
    {
        mX = 0.0f;
        mY = -1.0f;
    }
}

/*
 inline float Dot(FVec2 &pVector){return mX*pVector.mX+mY*pVector.mY;}
 inline const float Cross(FVec2 &pVector){return mX*pVector.mY-mY*pVector.mX;}
 
 inline float LengthSquared(){return mX*mX+mY*mY;}
 inline float Length(){return sqrtf(mX*mX+mY*mY);}
 inline void SetLength(float pLength){Normalize();mX*=pLength;mY*=pLength;}
 inline void Normalize(){float aLen=Length();if(aLen>0){mX/=aLen;mY/=aLen;}}
 */



FVec2 FVec2Make(float x, float y)
{
    FVec2 v = { x, y };
    return v;
}

FVec2 FVec2MakeWithArray(float values[2])
{
    FVec2 v = { values[0], values[1] };
    return v;
}

FVec2 FVec2Negate(FVec2 vector)
{
    FVec2 v = { -vector.mX , -vector.mY };
    return v;
}

FVec2 FVec2Add(FVec2 vectorLeft, FVec2 vectorRight)
{
    FVec2 v = { vectorLeft.mX + vectorRight.mX,
        vectorLeft.mY + vectorRight.mY };
    return v;
}

FVec2 FVec2Subtract(FVec2 vectorLeft, FVec2 vectorRight)
{
    FVec2 v = { vectorLeft.mX - vectorRight.mX,
        vectorLeft.mY - vectorRight.mY };
    return v;
}

FVec2 FVec2Multiply(FVec2 vectorLeft, FVec2 vectorRight)
{
    FVec2 v = { vectorLeft.mX * vectorRight.mX,
        vectorLeft.mY * vectorRight.mY };
    return v;
}

FVec2 FVec2Divide(FVec2 vectorLeft, FVec2 vectorRight)
{
    FVec2 v = { vectorLeft.mX / vectorRight.mX,
        vectorLeft.mY / vectorRight.mY };
    return v;
}

FVec2 FVec2AddScalar(FVec2 vector, float value)
{
    FVec2 v = { vector.mX + value,
        vector.mY + value };
    return v;
}

FVec2 FVec2SubtractScalar(FVec2 vector, float value)
{
    FVec2 v = { vector.mX - value,
        vector.mY - value };
    return v;
}

FVec2 FVec2MultiplyScalar(FVec2 vector, float value)
{
    FVec2 v = { vector.mX * value,
        vector.mY * value };
    return v;
}

FVec2 FVec2DivideScalar(FVec2 vector, float value)
{
    FVec2 v = { vector.mX / value,
        vector.mY / value };
    return v;
}

FVec2 FVec2Maximum(FVec2 vectorLeft, FVec2 vectorRight)
{
    FVec2 max = vectorLeft;
    if (vectorRight.mX > vectorLeft.mX)
        max.mX = vectorRight.mX;
    if (vectorRight.mY > vectorLeft.mY)
        max.mY = vectorRight.mY;
    return max;
}

FVec2 FVec2Minimum(FVec2 vectorLeft, FVec2 vectorRight)
{
    FVec2 min = vectorLeft;
    if (vectorRight.mX < vectorLeft.mX)
        min.mX = vectorRight.mX;
    if (vectorRight.mY < vectorLeft.mY)
        min.mY = vectorRight.mY;
    return min;
}

FVec2 FVec2Normalize(FVec2 vector)
{
    float scale = 1.0f / FVec2Length(vector);
    FVec2 v = FVec2MultiplyScalar(vector, scale);
    return v;
}

float FVec2DotProduct(FVec2 vectorLeft, FVec2 vectorRight)
{
    return vectorLeft.mX * vectorRight.mX + vectorLeft.mY * vectorRight.mY;
}

float FVec2Length(FVec2 vector)
{
    return sqrt(vector.mX * vector.mX + vector.mY * vector.mY);
}

float FVec2Distance(FVec2 vectorStart, FVec2 vectorEnd)
{
    return FVec2Length(FVec2Subtract(vectorEnd, vectorStart));
}

FVec2 FVec2Lerp(FVec2 vectorStart, FVec2 vectorEnd, float t)
{
    FVec2 v = { vectorStart.mX + ((vectorEnd.mX - vectorStart.mX) * t),
        vectorStart.mY + ((vectorEnd.mY - vectorStart.mY) * t) };
    return v;
}

FVec2 FVec2Project(FVec2 vectorToProject, FVec2 projectionVector)
{
    float scale = FVec2DotProduct(projectionVector, vectorToProject) / FVec2DotProduct(projectionVector, projectionVector);
    FVec2 v = FVec2MultiplyScalar(projectionVector, scale);
    return v;
}