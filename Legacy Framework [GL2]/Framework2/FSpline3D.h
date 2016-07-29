#pragma once
#include "stdafx.h"
#include <math.h>

#define SPLINE_3D_LINEAR 0x001
#define SPLINE_3D_CLOSED 0x002
#define SPLINE_3D_MANUAL_TANGENTS 0x004
#define SPLINE_3D_EPSILON 0.0001f
#define SPLINE_3D_SHORT_STEP 0.01f


class FSpline3D
{
public:
	FSpline3D(void);
	virtual ~FSpline3D(void);

	//Add points to the spline.
	void					Add(float x,float y,float z);
    
	//Manually set the tangent of the spline at a given index.
	//(Do this before solving the spline - a smooth curve will
	//be generated that is 'tugged' in the direction of the tangent
	//by the magnitude of the tangent).
	//Note: The spline also uses more memory once this has been called.
	void					SetTangent(int theIndex,float xtan,float ytan,float ztan);
	
    //Maybe we wanna add a point AND set a tangent for it!
	inline void				Add(float x, float y, float z, float tanx, float tany, float tanz){Add(x,y,z);SetTangent(mPointCount-1,tanx,tany,tanz);}
    
	//Spline Editor functions!
	//Add a point at a given index. (later points
	//automatically pushed back)
	void					Insert(int theIndex,float x, float y, float z);
    
	//Change the position of a point already on the spline.
	void					SetPoint(int theIndex,float x, float y, float z);
    

	void					Translate(float theXDistance, float theYDistance, float theZDistance);


	//Removes the point/tangent at a given index.
	void					Delete(int theIndex);
    
	//
	//End editor functions!

	//Change the number of points the spline can hold.
	//If you Size() the spline the the number of points you will add
	//before you add them, it will be faster.
	//You can also remove end-points by shrinking the size.
	void					Size(int size);

	//Destroy the spline and free up memory.
	void					Clear();

	//Solve() or CalculateSpline() will generate the actual spline.
	//This should be called after all of the points are added and
	//all of the manual tangents are set!
	//
	//Circular means that the spline will be closed (The last point will be
	//connected to the first point by a smooth curve)
	//
	virtual void			Solve(bool linear=false,bool circular=false);
	//
	//***
	//Everything beyond this point should only be used
	//after Solve() or CalculateSpline() have been called!
	//***
	//
    
	//Fetch a point along the spline. [Min() to Max()] AKA [0 to mPointCount-1]
	//Get(2.5) will yield the point interpolated half-way
	//between the 2nd and 3rd points that were added.
	void					Get(float pos,float &x,float &y,float &z);
	void					Get(int pos,float &x,float &y,float &z);
    
	float					GetX(float pos);//{float aX,aY;Get(pos,aX,aY);return aX;}
	float					GetY(float pos);//{float aX,aY;Get(pos,aX,aY);return aY;}
    float					GetZ(float pos);//{float aX,aY;Get(pos,aX,aY);return aY;}
    
	//Framework specific.
	inline FVec3			Get(float pos){FVec3 aReturn;Get(pos,aReturn.mX,aReturn.mY,aReturn.mZ);return aReturn;}
    
    //
	int						GetClosestControlIndex(float x, float y, float z, float &dist);

	//Get the tangent of the spline at a given position.
	void					Tan(float pos, float &x, float &y, float &z);
	void					Tan(int pos, float &x, float &y, float &z);
    
    FVec3                   Tan(float pPos);
    FVec3                   Perp(float pPos);
    FVec3                   Perp(float pPos, float pAngle);
    
    
	//The maximum and minimum positions of the spline.
	//for(float i=Min();i<=Max();i+=0.1f){}
	inline float			Max(){if(mChanged)Solve((mProperties&SPLINE_3D_LINEAR)!=0,(mProperties&SPLINE_3D_CLOSED)!=0);return (float)mMax;}
	inline float			Min(){return 0.0f;}
	int						mMax;
    
	bool					mChanged;
    
	//Info about the spline's last calculation.
	inline bool				IsClosed(){return (mProperties&SPLINE_3D_CLOSED)!=0;}
	inline bool				IsCircular(){return IsClosed();}
	inline bool				IsLinear(){return (mProperties&SPLINE_3D_LINEAR)!=0;}
	inline bool				IsUsingManualTangents(){return (mProperties&SPLINE_3D_MANUAL_TANGENTS)!=0;}

	void					SetClosed(bool theState){mProperties&=(~SPLINE_3D_CLOSED);if(theState)mProperties|=SPLINE_3D_CLOSED;}
	void					SetLinear(bool theState){mProperties&=(~SPLINE_3D_LINEAR);if(theState)mProperties|=SPLINE_3D_LINEAR;}

	//Points that were added to the spline, stored as arrays of floats!
	float					*mX;
	float					*mY;
    float					*mZ;
    
    //Number of points that were added to the spline.
	int						mPointCount;
	inline int				PointCount(){return mPointCount;}
    
	void					Solve(float *theCoordinate,float*theDelta,float*theDerivative,float*theTemp,float*theCoef,bool linear,bool circular);
	void					Solve(float *theCoordinate,float*theDelta,float*theDerivative,float*theCoef,bool linear,bool circular);
	int						mSize;
    
	float					*mXCoef;
	float					*mYCoef;
    float					*mZCoef;
    
	float					*mTangent;
    
	float					mLength;
	unsigned int			mProperties;
    
};