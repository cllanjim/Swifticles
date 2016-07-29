#include "FSpline3D.h"
#include "stdafx.h"
#include <string>
#include <string.h>

FSpline3D::FSpline3D(void)
{
	mSize=0;
	mMax=0;
	mPointCount=0;
    
	mX=0;
	mY=0;
    mZ=0;
    
	mXCoef=0;
	mYCoef=0;
    mZCoef=0;
    
	mProperties=0;
    
	mTangent=0;
	mLength=0;
    
	mChanged=true;
}

FSpline3D::~FSpline3D(void)
{
	Clear();
}

void FSpline3D::Translate(float theXDistance, float theYDistance, float theZDistance)
{
	for(int i=0;i<mPointCount;i++)
	{
		mX[i]+=theXDistance;
		mY[i]+=theYDistance;
        mZ[i]+=theZDistance;
	}
}

void FSpline3D::Clear()
{
	delete[]mX;
	delete[]mXCoef;
	delete[]mTangent;
    
	mX=0;
	mY=0;
    mZ=0;
    
	mXCoef=0;
	mYCoef=0;
    mZCoef=0;
    
	mTangent=0;
	mSize=0;
	mPointCount=0;
	mMax=0;
	mProperties=0;
	mLength=0;
	mChanged=true;
}

void FSpline3D::Size(int size)
{
	if(size>0)
	{
		if(mSize!=size)
		{
			mChanged=true;
            
			float *aX;//=new float[size*5];
			float *aY;//=aX+size;
			float *aZ;
            
            aX=new float[size*3];
			aY=aX+size;
            aZ=aY+size;
            
			if(size<mPointCount)mPointCount=size;
			for(int i=0;i<mPointCount;i++)aX[i]=mX[i];
			for(int i=0;i<mPointCount;i++)aY[i]=mY[i];
            for(int i=0;i<mPointCount;i++)aZ[i]=mZ[i];
            
			if(mProperties&SPLINE_3D_MANUAL_TANGENTS)
			{
				float *aXTan=new float[size*3];
				float *aYTan=aXTan+size;
                float *aZTan=aYTan+size;
                
				float *aTan=aYTan+size;
				float *aXTanSource=mTangent;
				float *aYTanSource=aXTanSource+mSize;
                float *aZTanSource=aYTanSource+mSize;
                
				float *aTanSource=aYTanSource+mSize;
                
				if(mSize>size)mSize=size;
                
				for(int i=0;i<mSize;i++)aXTan[i]=aXTanSource[i];
				for(int i=0;i<mSize;i++)aYTan[i]=aYTanSource[i];
                for(int i=0;i<mSize;i++)aZTan[i]=aZTanSource[i];
                
				for(int i=0;i<mSize;i++)aTan[i]=aTanSource[i];
				for(int i=mSize;i<size;i++)aTan[i]=0;
				delete[]mTangent;
				mTangent=aXTan;
			}
            
			delete[]mX;
            
			mX=aX;
			mY=aY;
            mZ=aZ;
            
			mSize=size;
		}
	}
	else
	{
		Clear();
	}
}

void FSpline3D::Add(float x, float y, float z)
{
	if(mSize==mPointCount)Size(mSize+mSize/2+1);
    
	mX[mPointCount]=x;
	mY[mPointCount]=y;
    mZ[mPointCount]=z;
    
    mPointCount++;
	mChanged=true;
}

void FSpline3D::SetPoint(int theIndex,float x, float y, float z)
{
	if(theIndex<0||theIndex>=mPointCount)return;
    
	mX[theIndex]=x;
	mY[theIndex]=y;
    mZ[theIndex]=z;
    
	mChanged=true;
}

int FSpline3D::GetClosestControlIndex(float x, float y, float z, float &dist)
{
	dist=-1;
	int aReturn=-1;
	if(mPointCount>1)
	{
		aReturn=0;
		float aDiffX=mX[0]-x;
		float aDiffY=mY[0]-y;
        float aDiffZ=mZ[0]-z;
        
		dist=aDiffX*aDiffX+aDiffY*aDiffY+aDiffZ*aDiffZ;
		float aDist;
		for(int i=1;i<mPointCount;i++)
		{
			aDiffX=mX[i]-x;
			aDiffY=mY[i]-y;
            aDiffY=mZ[i]-z;
			aDist=aDiffX*aDiffX+aDiffY*aDiffY+aDiffZ*aDiffZ;
			if(aDist<dist)
			{
				dist=aDist;
				aReturn=i;
			}
		}
	}
	return aReturn;
}

void FSpline3D::Insert(int theIndex,float x, float y, float z)
{
	if(mSize==mPointCount)Size(mSize+mSize/2+1);
	//if(mProperties&SPLINE_3D_CLOSED&&mPointCount>0){Delete(mMax);mProperties&=~SPLINE_3D_CLOSED;}
	if(theIndex<0)theIndex=0;
	if(theIndex>mPointCount)theIndex=mPointCount;
	for(int i=mPointCount-1;i>=theIndex;i--)mX[i+1]=mX[i];
	for(int i=mPointCount-1;i>=theIndex;i--)mY[i+1]=mY[i];
	if(mProperties&SPLINE_3D_MANUAL_TANGENTS)
	{
		float*aTan=mTangent;
		for(int i=mSize-2;i>=theIndex;i--)aTan[i+1]=aTan[i];
		aTan+=mSize;
		for(int i=mSize-2;i>=theIndex;i--)aTan[i+1]=aTan[i];
		aTan+=mSize;
		for(int i=mSize-2;i>=theIndex;i--)aTan[i+1]=aTan[i];
		aTan[theIndex]=0;
	}
    
    mX[theIndex]=x;
	mY[theIndex]=y;
    mZ[theIndex]=z;
    
    mPointCount++;
	mChanged=true;
}

void FSpline3D::Delete(int theIndex)
{
	if(theIndex<0)return;
	if(theIndex<mPointCount)
	{
		for(int i=theIndex;i<mPointCount;i++)mX[i]=mX[i+1];
		for(int i=theIndex;i<mPointCount;i++)mY[i]=mY[i+1];
		if(mPointCount)mPointCount--;
		mChanged=true;
	}
	if(theIndex<mSize&&(mProperties&SPLINE_3D_MANUAL_TANGENTS))
	{
		float*aTan=mTangent;
		for(int i=theIndex;i<mSize;i++)aTan[i]=aTan[i+1];aTan+=mSize;
		for(int i=theIndex;i<mSize;i++)aTan[i]=aTan[i+1];aTan+=mSize;
		for(int i=theIndex;i<mSize;i++)aTan[i]=aTan[i+1];
		mChanged=true;
	}
}

void FSpline3D::SetTangent(int theIndex, float xtan, float ytan, float ztan)
{
	if(theIndex>=0)
	{
		if(theIndex>=mSize)Size(theIndex+theIndex/2+1);
		if(!(mProperties&SPLINE_3D_MANUAL_TANGENTS))
		{
			mProperties|=SPLINE_3D_MANUAL_TANGENTS;
			int aSize=mSize*3;
			mTangent=new float[aSize];
			for(int i=0;i<aSize;i++)mTangent[i]=0;
		}
        
		mTangent[theIndex]=xtan;
		mTangent[theIndex+mSize]=ytan;
        mTangent[theIndex+(mSize + mSize)]=ztan;
        
		mTangent[theIndex+(mSize<<1)]=1;//theIndex+mSize*2
		mChanged=true;
	}
}

void FSpline3D::Solve(float *theCoordinate,float*theDelta,float*theDerivative,float*theTemp,float*theCoef,bool linear,bool circular)
{
	if(mPointCount > 1)
	{
		float *aDer=mTangent+mSize+mSize;
		unsigned int aCoefOffStart=0;
		if(mPointCount==2&&((mProperties&SPLINE_3D_MANUAL_TANGENTS)!=0))
		{
			
			if(circular)
			{
				if(!aDer[0])theDerivative[0]=-theDerivative[1];
				if(!aDer[1])theDerivative[1]=-theDerivative[0];
				theCoef[aCoefOffStart++]=theDerivative[0];
				theCoef[aCoefOffStart++]=3*(theCoordinate[1]-theCoordinate[0])-2*theDerivative[0]-theDerivative[1];
				theCoef[aCoefOffStart++]=2*(theCoordinate[0]-theCoordinate[1])+theDerivative[0]+theDerivative[1];
				theCoef[aCoefOffStart++]=theDerivative[1];
				theCoef[aCoefOffStart++]=3*(theCoordinate[0]-theCoordinate[1])-2*theDerivative[1]-theDerivative[0];
				theCoef[aCoefOffStart++]=2*(theCoordinate[1]-theCoordinate[0])+theDerivative[1]+theDerivative[0];
			}
			else
			{
				if(!aDer[0])theDerivative[0]=0;
				if(!aDer[1])theDerivative[1]=0;
				theCoef[aCoefOffStart++]=theDerivative[0];
				theCoef[aCoefOffStart++]=3*(theCoordinate[1]-theCoordinate[0])-2*theDerivative[0]-theDerivative[1];
				theCoef[aCoefOffStart++]=2*(theCoordinate[0]-theCoordinate[1])+theDerivative[0]+theDerivative[1];
			}
		}
		else if(linear||mPointCount==2)
		{
			for(int i=1,j=0;i<mPointCount;j=i++)
			{
				theCoef[aCoefOffStart++]=theCoordinate[i]-theCoordinate[j];
				theCoef[aCoefOffStart++]=0;
				theCoef[aCoefOffStart++]=0;
			}
			if(circular)
			{
				theCoef[aCoefOffStart++]=theCoordinate[0]-theCoordinate[mPointCount-1];
				theCoef[aCoefOffStart++]=0;
				theCoef[aCoefOffStart++]=0;
			}
		}
		else
		{
			int aMax;
			int aMax1;
			if(circular)
			{
				aMax=mPointCount-1;
				aMax1=aMax-1;
				theDelta[1]=0.25f;
				theTemp[0]=0.25f*3*(theCoordinate[1]-theCoordinate[aMax]);
				float G=1.0f,H=4.0f,F=3.0f*(theCoordinate[0]-theCoordinate[aMax1]);
				for(int i=1;i<aMax;i++)
				{
					theDelta[i+1]=-0.25f*theDelta[i];
					theTemp[i]=0.25f*(3*(theCoordinate[i+1]-theCoordinate[i-1])-theTemp[i-1]);
					H=H-G*theDelta[i];
					F=F-G*theTemp[i-1];
					G=-0.25f*G;
				}
				H=H-(G+1)*(0.25f+theDelta[aMax]);
				theTemp[aMax]=F-(G+1)*theTemp[aMax1];
				if(!aDer[aMax])theDerivative[aMax]=theTemp[aMax]/H;
				if(!aDer[aMax1])theDerivative[aMax1]=theTemp[aMax1]-(0.25f+theDelta[aMax])*theDerivative[aMax];
				for(int i=aMax-2;i>=0;i--)
				{
					if(!aDer[i])
					{
						theDerivative[i]=theTemp[i]-0.25f*theDerivative[i+1]-theDelta[i+1]*theDerivative[aMax];
					}
				}
				int aIndex=aMax*3;
				theCoef[aIndex]=theDerivative[aMax];
				theCoef[aIndex+1]=3*(theCoordinate[0]-theCoordinate[aMax])-2*theDerivative[aMax]-theDerivative[0];
				theCoef[aIndex+2]=2*(theCoordinate[aMax]-theCoordinate[0])+theDerivative[aMax]+theDerivative[0];
			}
			else
			{
				aMax=mMax;
				aMax1=aMax-1;
				theDelta[0]=3.0f*(theCoordinate[1]-theCoordinate[0])*0.25f;
				for(int i=1;i<aMax;i++)theDelta[i]=(3.0f*(theCoordinate[i+1]-theCoordinate[i-1])-theDelta[i-1])*0.25f;
				theDelta[aMax]=(3.0f*(theCoordinate[aMax]-theCoordinate[aMax1])-theDelta[aMax1])*0.25f;
				if(!aDer[aMax])theDerivative[aMax]=theDelta[aMax];
				for(int i=aMax1;i>=0;i--)
				{
					if(!aDer[i])
					{
						theDerivative[i]=theDelta[i]-0.25f*theDerivative[i+1];
					}
				}
			}
			for(int i=0;i<aMax;i++)
			{
				theCoef[aCoefOffStart++]=theDerivative[i];
				theCoef[aCoefOffStart++]=3*(theCoordinate[i+1]-theCoordinate[i])-2*theDerivative[i]-theDerivative[i+1];
				theCoef[aCoefOffStart++]=2*(theCoordinate[i]-theCoordinate[i+1])+theDerivative[i]+theDerivative[i+1];
			}
		}
	}
}

void FSpline3D::Solve(float *theCoordinate,float*theDelta,float*theDerivative,float*theCoef,bool linear,bool circular)
{
	if(mPointCount > 1)
	{
		unsigned int aCoefOffStart=0;
		if(linear||mPointCount==2)
		{
			for(int i=1,j=0;i<mPointCount;j=i++)
			{
				theCoef[aCoefOffStart++]=theCoordinate[i]-theCoordinate[j];
				theCoef[aCoefOffStart++]=0;
				theCoef[aCoefOffStart++]=0;
			}
			if(circular)
			{
				theCoef[aCoefOffStart++]=theCoordinate[0]-theCoordinate[mPointCount-1];
				theCoef[aCoefOffStart++]=0;
				theCoef[aCoefOffStart++]=0;
			}
		}
		else
		{
			int aMax;
			int aMax1;
			if(circular)
			{
				aMax=mPointCount-1;
				aMax1=aMax-1;
				theDelta[1]=0.25f;
				theDerivative[0]=0.25f*3*(theCoordinate[1]-theCoordinate[aMax]);
				float G=1.0f,H=4.0f,F=3.0f*(theCoordinate[0]-theCoordinate[aMax1]);
				for(int i=1;i<aMax;i++)
				{
					theDelta[i+1]=-0.25f*theDelta[i];
					theDerivative[i]=0.25f*(3*(theCoordinate[i+1]-theCoordinate[i-1])-theDerivative[i-1]);
					H=H-G*theDelta[i];
					F=F-G*theDerivative[i-1];
					G=-0.25f*G;
				}
				H=H-(G+1)*(0.25f+theDelta[aMax]);
				theDerivative[aMax]=F-(G+1)*theDerivative[aMax1];
				theDerivative[aMax]=theDerivative[aMax]/H;
				theDerivative[aMax1]=theDerivative[aMax1]-(0.25f+theDelta[aMax])*theDerivative[aMax];
				for(int i=aMax-2;i>=0;i--)theDerivative[i]=theDerivative[i]-0.25f*theDerivative[i+1]-theDelta[i+1]*theDerivative[aMax];
				int aIndex=aMax*3;
				theCoef[aIndex]=theDerivative[aMax];
				theCoef[aIndex+1]=3*(theCoordinate[0]-theCoordinate[aMax])-2*theDerivative[aMax]-theDerivative[0];
				theCoef[aIndex+2]=2*(theCoordinate[aMax]-theCoordinate[0])+theDerivative[aMax]+theDerivative[0];
			}
			else
			{
				aMax=mMax;
				aMax1=aMax-1;
				theDelta[0]=3.0f*(theCoordinate[1]-theCoordinate[0])*0.25f;
				for(int i=1;i<aMax;i++)theDelta[i]=(3.0f*(theCoordinate[i+1]-theCoordinate[i-1])-theDelta[i-1])*0.25f;
				theDelta[aMax]=(3.0f*(theCoordinate[aMax]-theCoordinate[aMax1])-theDelta[aMax1])*0.25f;
				theDerivative[aMax]=theDelta[aMax];
				for(int i=aMax1;i>=0;i--)theDerivative[i]=theDelta[i]-0.25f*theDerivative[i+1];
			}
			for(int i=0;i<aMax;i++)
			{
				theCoef[aCoefOffStart++]=theDerivative[i];
				theCoef[aCoefOffStart++]=3*(theCoordinate[i+1]-theCoordinate[i])-2*theDerivative[i]-theDerivative[i+1];
				theCoef[aCoefOffStart++]=2*(theCoordinate[i]-theCoordinate[i+1])+theDerivative[i]+theDerivative[i+1];
			}
		}
	}
}


void FSpline3D::Solve(bool linear,bool circular)
{
	mChanged=false;
	delete[]mXCoef;
	mXCoef=0;
	mYCoef=0;
    mZCoef=0;
	mMax=0;
	mProperties&=~SPLINE_3D_CLOSED;
	mProperties&=~SPLINE_3D_LINEAR;
	if(mPointCount>1)
	{
		mMax=mPointCount-1;
		if(circular)
		{
			mProperties|=SPLINE_3D_CLOSED;
			mMax++;
		}
		Size(mPointCount);
		if(linear)mProperties|=SPLINE_3D_LINEAR;
		//if(linear||(mPointCount==2&&!(mProperties&SPLINE_3D_MANUAL_TANGENTS)))mProperties|=SPLINE_3D_LINEAR;
		mXCoef=new float[mMax*9];
		mYCoef=mXCoef+3*mMax;
        mZCoef=mYCoef+3*mMax;
		float *aStore=new float[mPointCount*3];
		if(mProperties&SPLINE_3D_MANUAL_TANGENTS)
		{
			Solve(mX,aStore,mTangent,aStore+mPointCount,mXCoef,linear,circular);
			Solve(mY,aStore,mTangent+mSize,aStore+mPointCount,mYCoef,linear,circular);
            Solve(mZ,aStore,mTangent+mSize,aStore+mPointCount,mZCoef,linear,circular);
		}
		else
		{
			Solve(mX,aStore,aStore+mPointCount,mXCoef,linear,circular);
			Solve(mY,aStore,aStore+mPointCount,mYCoef,linear,circular);
            Solve(mZ,aStore,aStore+mPointCount,mZCoef,linear,circular);
		}
		delete[]aStore;
	}
}

void FSpline3D::Tan(float pos, float &x, float &y, float &z)
{
	if(mChanged)Solve((mProperties&SPLINE_3D_LINEAR)!=0,(mProperties&SPLINE_3D_CLOSED)!=0);
	if(mXCoef)
	{
		int aIndex=(int)pos;
		if(pos<0){aIndex=0;pos=0;}
		if(aIndex>=mMax){aIndex=mMax-1;pos=(float)(aIndex+1);}
		float aPos=pos-(float)aIndex;
		float aPos2=aPos*aPos;
        
		aIndex=((aIndex<<1)+aIndex);//aIndex*3
        
		x=3.0f*mXCoef[aIndex+2]*aPos2+2.0f*mXCoef[aIndex+1]*aPos+mXCoef[aIndex];
        y=3.0f*mYCoef[aIndex+2]*aPos2+2.0f*mYCoef[aIndex+1]*aPos+mYCoef[aIndex];
        z=3.0f*mZCoef[aIndex+2]*aPos2+2.0f*mZCoef[aIndex+1]*aPos+mZCoef[aIndex];
        
		return;
	}
	x=0;
	y=0;
    z=0;
}

//We may use this to smooth curves -- and the curves are not all necessarily smooth.
//So, we will step back one and assume t=1 instead of staying in place with t=0.
void FSpline3D::Tan(int pos, float &x, float &y, float &z)
{
	if(mChanged)Solve((mProperties&SPLINE_3D_LINEAR)!=0,(mProperties&SPLINE_3D_CLOSED)!=0);
	if(mXCoef)
	{
		if(pos<=0)
		{
			x=mXCoef[0];
			y=mYCoef[0];//mMax*3
            z=mZCoef[0];//mMax*3
            
			return;
		}
		pos--;
		if(pos>=mMax)pos=mMax-1;
		pos=(pos<<1)+pos;//pos*3
        
		x=3.0f*mXCoef[pos+2]+2.0f*mXCoef[pos+1]+mXCoef[pos];
		y=3.0f*mYCoef[pos+2]+2.0f*mYCoef[pos+1]+mYCoef[pos];
        z=3.0f*mZCoef[pos+2]+2.0f*mZCoef[pos+1]+mZCoef[pos];
        
		return;
	}
    
	x=0;
	y=0;
    z=0;
}

float FSpline3D::GetX(float pos)
{
    if(mProperties&SPLINE_3D_CLOSED)
    {
        if(mMax > 0)
        {
            if(pos < 0 || pos > (float)mMax)
            {
                pos = fmodf(pos, mMax);
                if(pos < 0)
                {
                    pos += (float)mMax;
                }
            }
        }
    }
	if(mChanged)Solve((mProperties&SPLINE_3D_LINEAR)!=0,(mProperties&SPLINE_3D_CLOSED)!=0);
	if(mXCoef)
	{
		int aIndex=(int)pos;
		if(pos<0)
		{
			return*mX;
		}
		float aPos=pos-(float)aIndex;
		if(aIndex>=mMax)
		{
			aIndex=mMax-1;
			aPos=1;
		}
		float aPos2=aPos*aPos;
		float aPos3=aPos*aPos2;

		int aCoefIndex=((aIndex<<1)+aIndex);//aIndex*3
		//duuu+cuu+bu+a
		return mX[aIndex]+mXCoef[aCoefIndex]*aPos+mXCoef[aCoefIndex+1]*aPos2+mXCoef[aCoefIndex+2]*aPos3;
	}
	return 0;
}

float FSpline3D::GetY(float pos)
{
    if(mProperties&SPLINE_3D_CLOSED)
    {
        if(mMax > 0)
        {
            if(pos < 0 || pos > (float)mMax)
            {
                pos = fmodf(pos, mMax);
                if(pos < 0)
                {
                    pos += (float)mMax;
                }
            }
        }
    }
	if(mChanged)Solve((mProperties&SPLINE_3D_LINEAR)!=0,(mProperties&SPLINE_3D_CLOSED)!=0);
	if(mXCoef)
	{
		int aIndex=(int)pos;
		if(pos<0)
		{
			return*mY;
		}
		float aPos=pos-(float)aIndex;
		if(aIndex>=mMax)
		{
			aIndex=mMax-1;
			aPos=1;
		}
		float aPos2=aPos*aPos;
		float aPos3=aPos*aPos2;
		int aCoefIndex=((aIndex<<1)+aIndex);//+((mMax<<1)+mMax);
		//duuu+cuu+bu+a
		return mY[aIndex]+mYCoef[aCoefIndex]*aPos+mYCoef[aCoefIndex+1]*aPos2+mYCoef[aCoefIndex+2]*aPos3;
	}
	return 0;
}

float FSpline3D::GetZ(float pos)
{
    if(mProperties&SPLINE_3D_CLOSED)
    {
        if(mMax > 0)
        {
            if(pos < 0 || pos > (float)mMax)
            {
                pos = fmodf(pos, mMax);
                if(pos < 0)
                {
                    pos += (float)mMax;
                }
            }
        }
    }
	if(mChanged)Solve((mProperties&SPLINE_3D_LINEAR)!=0,(mProperties&SPLINE_3D_CLOSED)!=0);
	if(mXCoef)
	{
		int aIndex=(int)pos;
		if(pos<0)
		{
			return*mZ;
		}
		float aPos=pos-(float)aIndex;
		if(aIndex>=mMax)
		{
			aIndex=mMax-1;
			aPos=1;
		}
		float aPos2=aPos*aPos;
		float aPos3=aPos*aPos2;
		int aCoefIndex=((aIndex<<1)+aIndex);//+((mMax<<1)+mMax);
		//duuu+cuu+bu+a
		return mZ[aIndex]+mZCoef[aCoefIndex]*aPos+mZCoef[aCoefIndex+1]*aPos2+mZCoef[aCoefIndex+2]*aPos3;
	}
	return 0;
}

void FSpline3D::Get(float pos, float &x, float &y, float &z)
{
	if(mChanged)Solve((mProperties&SPLINE_3D_LINEAR)!=0,(mProperties&SPLINE_3D_CLOSED)!=0);
	if(mXCoef)
	{
		if(IsCircular())
		{
			if(pos<0||pos>(float)mMax)
			{
				pos=fmodf(pos,(float)mMax);
				if(pos<0)pos+=(float)mMax;
			}
		}
        
		int aIndex=(int)pos;
		if(pos<0)
		{
			x=*mX;
			y=*mY;
            z=*mZ;
			return;
		}
        
		float aPos=pos-(float)aIndex;
		if(aIndex>=mMax)
		{
			aIndex=mMax-1;
			aPos=1;
		}
        
		x=mX[aIndex];
		y=mY[aIndex];
        z=mZ[aIndex];
        
		aIndex=((aIndex<<1)+aIndex);//aIndex*3
		
        x+=(((mXCoef[aIndex+2]*aPos)+mXCoef[aIndex+1])*aPos+mXCoef[aIndex])*aPos;
		y+=(((mYCoef[aIndex+2]*aPos)+mYCoef[aIndex+1])*aPos+mYCoef[aIndex])*aPos;
        z+=(((mZCoef[aIndex+2]*aPos)+mZCoef[aIndex+1])*aPos+mZCoef[aIndex])*aPos;
		
        
        return;
	}
	x=0;
	y=0;
    z=0;
}

void FSpline3D::Get(int pos, float&x, float&y, float&z)
{
	if(mChanged)Solve((mProperties&SPLINE_3D_LINEAR)!=0,(mProperties&SPLINE_3D_CLOSED)!=0);
	if(mPointCount>0)
	{
		if(pos<0)
        {
            x=*mX;
            y=*mY;
            z=*mZ;
            
            return;
        }
		
		if(pos>=mPointCount)
		{
			if(mProperties&SPLINE_3D_CLOSED)
			{
				x=*mX;
                y=*mY;
                z=*mZ;
                
                
                return;
			}
			else
			{
				x=mX[mPointCount-1];
                y=mY[mPointCount-1];
                z=mZ[mPointCount-1];
                
                return;
			}
		}
        
		x=mX[pos];
        y=mY[pos];
        z=mZ[pos];
        
        return;
	}
    
	x=0;
	y=0;
    z=0;
}


FVec3 FSpline3D::Tan(float pPos)
{
    float aTanX,aTanY,aTanZ;
    Tan(pPos, aTanX, aTanY, aTanZ);
    return FVec3(aTanX, aTanY, aTanZ);
}

FVec3 FSpline3D::Perp(float pPos)
{
    FVec3 aTan = Tan(pPos);
    FVec3 aReferenceVector = FVec3(1.0f,1.0f,0);//-aTan.mX, -aTan.mY, -aTan.mZ);
    FVec3 aPerp;
    aPerp.mX = aTan.mY*aReferenceVector.mZ - aTan.mZ*aReferenceVector.mY;
    aPerp.mY = aTan.mZ*aReferenceVector.mX - aTan.mX*aReferenceVector.mZ;
    aPerp.mZ = aTan.mX*aReferenceVector.mY - aTan.mY*aReferenceVector.mX;
    return aPerp;
}

FVec3 FSpline3D::Perp(float pPos, float pAngle)
{
    return FVec3(0.0f, 0.0f, 0.0f);
}
