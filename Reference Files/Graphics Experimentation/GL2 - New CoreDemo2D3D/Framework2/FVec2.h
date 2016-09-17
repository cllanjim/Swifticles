//
//  FVec2.h
//  SRT
//
//  Created by Nick Raptis on 10/8/13.
//  Copyright (c) 2013 Froggy Studios LLC. All rights reserved.
//

#ifndef FRAMEWORK_VEC_2
#define FRAMEWORK_VEC_2

class FVec2
{
public:
	FVec2(){mX=0;mY=0;}
	FVec2(const float pX, const float pY) {mX=pX;mY=pY;}
	FVec2(const float pX, const int pY) {mX=pX;mY=(float)pY;}
	FVec2(const int pX, const float pY) {mX=(float)pX;mY=pY;}
	FVec2(const int pX, const int pY) {mX=(float)pX;mY=(float)pY;}
	FVec2(const FVec2 &pFVec2) {*this=pFVec2;}
	
	inline FVec2 &operator=(const FVec2 &pFVec2) {if (this!=&pFVec2) {mX=pFVec2.mX;mY=pFVec2.mY;}return *this;}
	inline FVec2 &operator=(float &pValue) {mX=pValue;mY=pValue;return *this;}
	inline FVec2 &operator=(int &pValue) {mX=(float)pValue;mY=(float)pValue;return *this;}
	
	inline bool	operator==(const FVec2 &pFVec2) {return (mX==pFVec2.mX)&(mY==pFVec2.mY);}
	inline bool	operator!=(const FVec2 &pFVec2) {return (mX!=pFVec2.mX)|(mY!=pFVec2.mY);}
	
	inline const FVec2	operator*(const FVec2 &pFVec2) const {return FVec2(mX*pFVec2.mX,mY*pFVec2.mY);}
	inline FVec2 &operator*=(const FVec2 &pFVec2) {mX*=pFVec2.mX;mY*=pFVec2.mY;return *this;}
	inline const FVec2 operator*(const float pFloat) const {return FVec2(mX*pFloat,mY*pFloat);}
	inline FVec2 &operator*=(const float pFloat) {mX*=pFloat;mY*=pFloat;return *this;}
	inline const FVec2	operator/(const FVec2 &pFVec2) const {return FVec2(mX/pFVec2.mX,mY/pFVec2.mY);}
	inline FVec2 &operator/=(const FVec2 &pFVec2) {mX/=pFVec2.mX;mY/=pFVec2.mY;return *this;}
	inline const FVec2 operator/(const float pFloat) const {return FVec2(mX/pFloat,mY/pFloat);}
	inline FVec2 &operator/=(const float pFloat) {mX/=pFloat;mY/=pFloat;return *this;}
	inline const FVec2 operator+(const FVec2 &pFVec2) const {return FVec2(mX+pFVec2.mX,mY+pFVec2.mY);}
	inline FVec2 &operator+=(const FVec2 &pFVec2) {mX+=pFVec2.mX;mY+=pFVec2.mY;return *this;}
	inline const FVec2 operator+(const float pFloat) const {return FVec2(mX+pFloat,mY+pFloat);}
	inline FVec2 &operator+=(const float pFloat) {mX+=pFloat;mY+=pFloat;return *this;}
	inline const FVec2 operator-(const FVec2 &pFVec2) const {return FVec2(mX-pFVec2.mX,mY-pFVec2.mY);}
	inline FVec2 &operator-=(const FVec2 &pFVec2) {mX-=pFVec2.mX;mY-=pFVec2.mY;return *this;}
	inline const FVec2 operator-(const float pFloat) const {return FVec2(mX-pFloat,mY-pFloat);}
	inline FVec2 & operator-=(const float pFloat) {mX-=pFloat;mY-=pFloat;return *this;}
	inline const FVec2 operator-() const {return FVec2(-mX,-mY);}
    
    float                               Length();
    float                               LengthSquared();
    
    void                                Normalize();
    
    float                               mX;
	float                               mY;
    
    
    /*
	inline float Dot(FVec2 &pVector){return mX*pVector.mX+mY*pVector.mY;}
	inline const float Cross(FVec2 &pVector){return mX*pVector.mY-mY*pVector.mX;}
    
	inline float LengthSquared(){return mX*mX+mY*mY;}
	inline float Length(){return sqrtf(mX*mX+mY*mY);}
	inline void SetLength(float pLength){Normalize();mX*=pLength;mY*=pLength;}
	inline void Normalize(){float aLen=Length();if(aLen>0){mX/=aLen;mY/=aLen;}}
    */
    
};

FVec2 FVec2Make(float x, float y);
FVec2 FVec2MakeWithArray(float values[2]);
FVec2 FVec2Negate(FVec2 vector);
FVec2 FVec2Add(FVec2 vectorLeft, FVec2 vectorRight);
FVec2 FVec2Subtract(FVec2 vectorLeft, FVec2 vectorRight);
FVec2 FVec2Multiply(FVec2 vectorLeft, FVec2 vectorRight);
FVec2 FVec2Divide(FVec2 vectorLeft, FVec2 vectorRight);
FVec2 FVec2AddScalar(FVec2 vector, float value);
FVec2 FVec2SubtractScalar(FVec2 vector, float value);
FVec2 FVec2MultiplyScalar(FVec2 vector, float value);
FVec2 FVec2DivideScalar(FVec2 vector, float value);
FVec2 FVec2Maximum(FVec2 vectorLeft, FVec2 vectorRight);
FVec2 FVec2Minimum(FVec2 vectorLeft, FVec2 vectorRight);
FVec2 FVec2Normalize(FVec2 vector);
float FVec2DotProduct(FVec2 vectorLeft, FVec2 vectorRight);
float FVec2Length(FVec2 vector);
float FVec2Distance(FVec2 vectorStart, FVec2 vectorEnd);
FVec2 FVec2Lerp(FVec2 vectorStart, FVec2 vectorEnd, float t);
FVec2 FVec2Project(FVec2 vectorToProject, FVec2 projectionVector);

#endif
