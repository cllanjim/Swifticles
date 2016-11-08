//
//  PointList.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/29/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class PointList
{
    var data = [CGPoint]()
    
    var count:Int { return _count }
    internal var _count:Int = 0
    
    func reset() {
        _count = 0
    }
    
    func clear() {
        reset()
        data.removeAll()
    }
    
    func add(x:CGFloat, y:CGFloat) {
        set(_count, x: x, y: y)
    }
    
    func add(list:PointList) {
        for i in 0..<list.count {
            add(x: list.data[i].x, y: list.data[i].y)
        }
    }
    
    func set(_ index:Int, x:CGFloat, y:CGFloat) {
        if index >= _count {
            _count = index + 1
            let newCapacity = _count + _count / 2 + 1
            data.reserveCapacity(newCapacity)
            while data.count <= _count {
                data.append(CGPoint.zero)
            }
        }
        data[index].x = x
        data[index].y = y
    }
    
    
    func transform(scaleX:CGFloat, scaleY:CGFloat, rotation:CGFloat) {
        if rotation == 0 {
            for i in 0..<count {
                data[i].x = data[i].x * scaleX
                data[i].y = data[i].y * scaleY
            }
        } else {
            for i in 0..<count {
                var x = data[i].x * scaleX
                var y = data[i].y * scaleY
                var dist = x * x + y * y
                if dist > 0.01 {
                    dist = CGFloat(sqrtf(Float(dist)))
                    x /= dist
                    y /= dist
                }
                let pivotRotation = rotation - CGFloat(atan2f(Float(-x), Float(-y)))
                data[i].x = CGFloat(sinf(Float(pivotRotation))) * dist
                data[i].y = CGFloat(-cosf(Float(pivotRotation))) * dist
            }
        }
    }
    
    func transform(scale:CGFloat, rotation:CGFloat) {
        transform(scaleX: scale, scaleY: scale, rotation: rotation)
    }
    
    func transform(translation:CGPoint) {
        for i in 0..<count {
            data[i].x = data[i].x + translation.x
            data[i].y = data[i].y + translation.y
        }
    }
    
    func getMinX()->CGFloat {
        var left:CGFloat = 0.0
        if count > 0 { left = data[0].x }
        for i in 0..<count {
            if data[i].x < left { left = data[i].x }
        }
        return left
    }
    
    func getMaxX()->CGFloat {
        
        var right:CGFloat = 0.0
        if count > 0 { right = data[0].x }
        for i in 0..<count {
            if data[i].x > right { right = data[i].x }
        }
        return right
    }
    
    func getMinY()->CGFloat {
        var top:CGFloat = 0.0
        if count > 0 { top = data[0].y }
        for i in 0..<count {
            if data[i].y < top { top = data[i].y }
        }
        return top
    }
    
    func getMaxY()->CGFloat {
        var bottom:CGFloat = 0.0
        if count > 0 { bottom = data[0].y }
        for i in 0..<count {
            if data[i].y > bottom { bottom = data[i].y }
        }
        return bottom
    }
    
    func getBoundingBox(padding:CGFloat)->CGRect {
        let left = getMinX()
        let top = getMinY()
        return CGRect(x: (left - padding),
                      y: (top - padding),
                      width: ((getMaxX() - left) + padding * 2),
                      height: ((getMaxY() - top) + padding * 2))
    }
    
    func pointInside(point:CGPoint)->Bool {
        var result = false
        var index2 = count - 1
        for index1 in 0..<count {
            let yBetween = (data[index1].y <= point.y) && (point.y < data[index2].y) || (data[index2].y <= point.y) && (point.y < data[index1].y)
            let xIntersects = (point.x < (data[index2].x - data[index1].x) * (point.y - data[index1].y) / (data[index2].y - data[index1].y) + data[index1].x)
            if yBetween && xIntersects {
                result = !result;
            }
            index2 = index1
        }
        return result
    }
    
    func isSimple() -> Bool {
        
        if count > 2 {
            
            //var checkIndex: Int = count - 2
            //var probeIndex: Int = 0
            
            for i:Int in 1..<(count - 2) {
            //for(int i=1;i<mCount-2;i++)
            //{
                //for(int n=i+2; n<mCount; n++)
                //{
                
                for n in i+2..<count {
                    
                    if LineSegment.SegmentsIntersect(l1p1: data[i], l1p2: data[i-1], l2p1: data[n], l2p2: data[n-1]) {
                        return false
                    }
                    
                }
                
            }
            
            for i in 2..<(count - 1) {
                if LineSegment.SegmentsIntersect(l1p1: data[count - 1], l1p2: data[0], l2p1: data[i], l2p2: data[i - 1]) {
                    return false
                }
            }
            
            
            
            
        }
        
        
        return true
    }
    
    func closestPointSquared(point: CGPoint) -> (point:CGPoint, distanceSquared: CGFloat)? {
        var result: (point:CGPoint, distanceSquared: CGFloat)?
        if count > 0 {
            var diffX = data[0].x - point.x
            var diffY = data[0].y - point.y
            var dist = diffX * diffX + diffY * diffY
            var bestDist = dist
            result = (point:CGPoint(x: data[0].x, y: data[0].y), distanceSquared: dist)
            for i in 1..<count {
                let p = data[i]
                diffX = p.x - point.x
                diffY = p.y - point.y
                dist = diffX * diffX + diffY * diffY
                if dist < bestDist {
                    bestDist = dist
                    result!.distanceSquared = dist
                    result!.point = p
                }
            }
        }
        return result
    }
    
    func drawEdges(closed:Bool) {
        guard count >= 2 else { return }
        var prev = data[0]
        var startIndex = 1
        if closed {
            prev = data[count - 1]
            startIndex = 0
        }
        for i in startIndex..<count {
            let point = data[i]
            ShaderProgramMesh.shared.lineDraw(p1: CGPoint(x: prev.x, y: prev.y), p2: CGPoint(x: point.x, y: point.y), thickness: 0.5)
            prev = point
        }
    }
    
    func drawPoints() {
        for i in 0..<count {
            let point = data[i]
            ShaderProgramMesh.shared.pointDraw(point: CGPoint(x: point.x, y: point.y), size: 4.0)
        }
    }
    
}


/*
 
 bool FPointList::ContainsPoint(float pX, float pY)
 {
 bool aReturn = false;
 
 for(int aStart=0,aEnd=(mCount - 1);aStart<mCount;aEnd=aStart++)
 {
 if((((mY[aStart] <= pY) && (pY < mY[aEnd]))||
 ((mY[aEnd] <= pY) && (pY < mY[aStart])))&&
 (pX < (mX[aEnd] - mX[aStart]) * (pY - mY[aStart])
 / (mY[aEnd] - mY[aStart]) + mX[aStart]))
 {
 aReturn = !aReturn;
 }
 }
 
 return aReturn;
 }
 
 bool FPointList::IsClockwise()
 {
 float aAreaSum=0;
 for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)
 {
 aAreaSum+=CROSS_PRODUCT(mX[aStart], mY[aStart], mX[aEnd], mY[aEnd]);
 }
 return aAreaSum < 0;
 }
 
 */


/*
#include "StdAfx.h"

#include "poly.h"
#include "math.h"
#include "matrix.h"
#include "list.h"

Poly::Poly(void)
{
    mSize=0;
    mCount=0;
    mSub=0;
    mPoint=0;
    mPointBase=0;
}

Poly::~Poly(void)
{
    Clear();
}

void Poly::AddPoint(float theX, float theY)
{
    mCount++;
    if(mCount > mSize)Size(mCount * 2 + 1);
    mPointBase[mCount-1]=mPoint[mCount-1]=Point(theX,theY);
}

Poly::Interval Poly::FindInterval(Point *thePoints, int thePointCount, Point theAxis, Point theRelativeVelocity)
{
    Poly::Interval aReturn;
    //Project each point from poly to the axis using dot product!
    //Keep track of minimum value and maximum value, these represent
    //the interval that the polygon spans on this axis in 1D.
    float aDot = aReturn.mMin = aReturn.mMax = thePoints[0].Dot(theAxis);
    for(int i=1;i<thePointCount;i++)
    {
        aDot=thePoints[i].Dot(theAxis);
        if(aDot<aReturn.mMin)aReturn.mMin=aDot;
        else if(aDot>aReturn.mMax)aReturn.mMax=aDot;
    }
    
    float aVelocityAdjustment = theRelativeVelocity.Dot(theAxis);
    if (aVelocityAdjustment < 0)aReturn.mMin += aVelocityAdjustment;
    else aReturn.mMax += aVelocityAdjustment;
    
    return aReturn;
}

Poly::Interval Poly::FindInterval(Point *thePoints, int thePointCount, Point theAxis)
{
    Poly::Interval aReturn;
    //Project each point from poly to the axis using dot product!
    //Keep track of minimum value and maximum value, these represent
    //the interval that the polygon spans on this axis in 1D.
    float aDot = aReturn.mMin = aReturn.mMax = thePoints[0].Dot(theAxis);
    for(int i=1;i<thePointCount;i++)
    {
        aDot=thePoints[i].Dot(theAxis);
        if(aDot<aReturn.mMin)aReturn.mMin=aDot;
        else if(aDot>aReturn.mMax)aReturn.mMax=aDot;
    }
    return aReturn;
}

bool Poly::Intersects(Poly*thePoly)
{
    if(mCount<2 || thePoly->GetVertexCount()<2)return false;
    for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)
    {
        Point aEdge(mPoint[aEnd]-mPoint[aStart]);
        Point aAxis(Point(-aEdge.mY,aEdge.mX));
        if(!FindInterval(mPoint,mCount,aAxis).
            Intersects(FindInterval(thePoly->mPoint,thePoly->mCount,aAxis)))return false;
    }
    for(int aStart=0,aEnd=thePoly->mCount-1;aStart<thePoly->mCount;aEnd=aStart++)
    {
        Point aEdge(thePoly->mPoint[aEnd]-thePoly->mPoint[aStart]);
        Point aAxis(-aEdge.mY,aEdge.mX);
        if(!FindInterval(mPoint,mCount,aAxis).
            Intersects(FindInterval(thePoly->mPoint,thePoly->mCount,aAxis)))return false;
    }
    return true;
}

bool Poly::WillIntersect(Poly*thePoly,Point theVelocity1,Point theVelocity2,Point *theTranslationVector)
{
    if(mCount<2 || thePoly->GetVertexCount()<2)return false;
    
    //Get relative velocity.
    Point aRelativeVelocity = theVelocity2 - theVelocity1;
    
    float aMinDistance=5000;
    Point aTranslationAxis;
    
    //For each edge in the first polygon...
    for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)
    {
        //Pick separation axis perpindicular to edge!
        Point aEdge(mPoint[aEnd]-mPoint[aStart]);
        Point aAxis(-aEdge.mY,aEdge.mX);
        aAxis.Normalize();
        
        Interval aInt1=FindInterval(mPoint,mCount,aAxis,aRelativeVelocity);
        Interval aInt2=FindInterval(thePoly->mPoint,thePoly->mCount,aAxis);
        
        //Difference between each polygon along the current axis.
        //If this is <=0, they overlap on this axis, so we must keep
        //on checkin'!
        float aDistanceBetween=aInt1.DistanceBetween(aInt2);
        if(aDistanceBetween>0)
        {
            return false;
        }
        else
        {
            aDistanceBetween=(float)fabs(aDistanceBetween);
            if(aDistanceBetween < aMinDistance)
            {
                aMinDistance=aDistanceBetween;
                aTranslationAxis=aAxis;
                Point aDist(mCenter - thePoly->mCenter);
                if(aDist.Dot(aTranslationAxis)<0)aTranslationAxis=-aTranslationAxis;
            }
        }
    }
    
    //Repeat all this malarkey for the second polygon!
    for(int aStart=0,aEnd=thePoly->mCount-1;aStart<thePoly->mCount;aEnd=aStart++)
    {
        //Pick separation axis perpindicular to edge!
        Point aEdge(thePoly->mPoint[aEnd]-thePoly->mPoint[aStart]);
        Point aAxis(-aEdge.mY,aEdge.mX);
        aAxis.Normalize();
        
        Interval aInt1=FindInterval(mPoint,mCount,aAxis,aRelativeVelocity);
        Interval aInt2=FindInterval(thePoly->mPoint,thePoly->mCount,aAxis);
        
        //Difference between each polygon along the current axis.
        //If this is <=0, they overlap on this axis, so we must keep
        //on checkin'!
        float aDistanceBetween=aInt1.DistanceBetween(aInt2);
        if(aDistanceBetween>0)
        {
            return false;
        }
        else
        {
            aDistanceBetween=(float)fabs(aDistanceBetween);
            if(aDistanceBetween < aMinDistance)
            {
                aMinDistance=aDistanceBetween;
                aTranslationAxis=aAxis;
                Point aDist(mCenter - thePoly->mCenter);
                if(aDist.Dot(aTranslationAxis)<0)
                {
                    aTranslationAxis=-aTranslationAxis;
                }
            }
        }
    }
    
    if(theTranslationVector)
    {
        theTranslationVector->mX=aTranslationAxis.mX*aMinDistance;
        theTranslationVector->mY=aTranslationAxis.mY*aMinDistance;
    }
    return true;
}

void Poly::Transform(Matrix theMatrix)
{
    mMatrix=theMatrix;
    mCenter=mCenterBase+Point(mMatrix.mData.m30,mMatrix.mData.m31);
    for(int i=0; i<mCount; i++)
    {
        Point aPoint(mPointBase[i]-mCenterBase);
        mPoint[i]=Point(
            aPoint.mX*theMatrix.mData.m00+
            aPoint.mY*theMatrix.mData.m10+
            mCenter.mX,
            
            aPoint.mX*theMatrix.mData.m01+
            aPoint.mY*theMatrix.mData.m11+
            mCenter.mY);
    }
}

void Poly::Transform(Point theTranslate, float theRotation, float theScale)
{
    Matrix aMat;
    aMat.Rotate2D(theRotation);
    aMat.Scale(theScale);
    aMat.Translate(theTranslate);
    Transform(aMat);
}

float Poly::GetBoundingRadius()
{
    if(mCount>0)
    {
        float aMaxDist=gMath.Distance(mPointBase[0],mCenterBase);
        for(int i=1; i<mCount; i++)
        {
            float aDist=gMath.Distance(mPointBase[i],mCenterBase);
            if(aDist>aMaxDist)aMaxDist=aDist;
        }
        return aMaxDist;
    }
    else return 0;
}

Rect Poly::GetBoundingRect()
{
    if(mCount>0)
    {
        float aLeft,aRight,aTop,aBottom;
        aLeft=aRight=mPointBase[0].mX;
        aTop=aBottom=mPointBase[0].mY;
        for(int i=1;i<mCount;i++)
        {
            if(mPointBase[i].mX<aLeft)aLeft=mPointBase[i].mX;
            else if(mPointBase[i].mX>aRight)aRight=mPointBase[i].mX;
            
            if(mPointBase[i].mY<aTop)aTop=mPointBase[i].mY;
            else if(mPointBase[i].mY>aBottom)aBottom=mPointBase[i].mY;
        }
        return Rect(aLeft,aTop,max(0,aRight-aLeft),max(0,aBottom-aTop));
    }
    else return Rect(0,0,0,0);
}

Rect Poly::GetBoundingBox()
{
    if(mCount>0)
    {
        float aRadius=GetBoundingRadius();
        float aRadius2=aRadius+aRadius;
        return Rect(mCenterBase.mX-aRadius,mCenterBase.mY-aRadius,aRadius2,aRadius2);
    }
    else return Rect(0,0,0,0);
}

void Poly::Tidy()
{

    Point *aPointBase = mPointBase;
    Point *aPoint = mPoint;
    
    mPointBase=new Point[mCount];
    mPoint=new Point[mCount];
    
    for(int i=0; i<mCount; i++)
    {
        mPointBase[i]=aPointBase[i];
        mPoint[i]=aPoint[i];
    }
    
    if(aPointBase)delete[]aPointBase;
    if(aPoint)delete[]aPoint;
    
    mSize = mCount;
}

void Poly::Size(int theSize)
{
    Point *aPointBase = mPointBase;
    Point *aPoint = mPoint;
    mPointBase = new Point[theSize];
    mPoint = new Point[theSize];
    for(int i=0; i<mSize; i++)
    {
        mPointBase[i]=aPointBase[i];
        mPoint[i]=aPoint[i];
    }
    if(aPointBase)delete[]aPointBase;
    if(aPoint)delete[]aPoint;
    mSize = theSize;
}

void Poly::Draw()
{
    for(int aStart=0;aStart<mCount;aStart++)
    {
        gG.FillRect(mPoint[aStart].mX-2,mPoint[aStart].mY-2,5,5);
    }
    
    
    if(mSub)
    {
        for(int i=0;i<mSub->mCount;i++)
        {
            for(int aStart=0,aEnd=mSub->mList[i]->mCount-1;aStart<mSub->mList[i]->mCount;aEnd=aStart++)
            {
                gG.DrawLine(mPoint[mSub->mList[i]->mIndex[aStart]], mPoint[mSub->mList[i]->mIndex[aEnd]]);
            }
        }
    }
    else
    {
        for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)
        {
            gG.DrawLine(mPoint[aStart], mPoint[aEnd]);
        }
    }
}

Point Poly::GetCentroid()
{
    Point aCentroid;
    float aAreaSum=0;
    for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)
    {
        float aCross=(float)mPointBase[aStart].Cross(mPointBase[aEnd]);
        aAreaSum+=aCross;
        aCentroid+=Point((mPointBase[aStart].mX+mPointBase[aEnd].mX)*aCross,(mPointBase[aStart].mY+mPointBase[aEnd].mY)*aCross);
    }
    return aCentroid/(aAreaSum*3)+Point(mMatrix.mData.m30,mMatrix.mData.m31);
}

float Poly::GetInertia()
{
    float aNumerator=0;
    for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)
    {
        float aCross = (float)fabs(mPoint[aEnd].Cross(mPoint[aStart]));
        float aDotSum = (mPoint[aStart].Dot(mPoint[aStart]) + mPoint[aStart].Dot(mPoint[aEnd]) + mPoint[aEnd].Dot(mPoint[aEnd]));
        aNumerator += (aCross * aDotSum);
    }
    return aNumerator/12;
}

float Poly::GetArea()
{
    float aAreaSum=0;
    for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)
    {
        aAreaSum+=(float)fabs(mPoint[aStart].Cross(mPoint[aEnd]));
    }
    return aAreaSum/2;
}

bool Poly::Intersects(float theX, float theY)
{
    if(mCount < 2)return false;
    
    bool aReturn = false;
    for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)
    {
        if ((((mPoint[aStart].mY<=theY) && (theY<mPoint[aEnd].mY))||
            ((mPoint[aEnd].mY<=theY) && (theY<mPoint[aStart].mY)))&&
                (theX < (mPoint[aEnd].mX - mPoint[aStart].mX)*(theY - mPoint[aStart].mY)
                    /(mPoint[aEnd].mY - mPoint[aStart].mY) + mPoint[aStart].mX))
        aReturn=!aReturn;
    }
    return aReturn;
}

void Poly::Clear()
{
    delete[]mPoint;
    delete[]mPointBase;
    if(mSub)
    {
        mSub->Clear();
        delete mSub;
    }
    mSub=0;
    mSize=0;
    mCount=0;
    mMatrix.Reset();
    mPoint=0;
    mPointBase=0;
}

void Poly::Center()
{
    mCenterBase=GetCentroid();
    mCenter=mCenterBase;
}
CenterAt(Point thePoint);

void Poly::CenterAt(Point thePoint)
{
    Center();
    for(int i=0; i<mCount; i++)
    {
        mPointBase[i]-=(mCenterBase-thePoint);
    }
    mCenterBase=mCenter=thePoint;
}

void Poly::MakeRegular(Point theCenter, int theVertices, float theRadii)
{
    Clear();
    Size(theVertices);
    float aAdd=360.0f/(float)theVertices;
    for(float i=0;i<360;i+=aAdd)
    {
        AddPoint(gMath.AngleToVector(i)*theRadii+theCenter);
    }
}
bool Poly::Intersects(float theX, float theY, float theWidth, float theHeight)
{
    Point aRectPoint[4]={Point(theX,theY),Point(theX+theWidth,theY),Point(theX+theWidth,theY+theHeight),Point(theX,theY+theHeight)};
    for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)
    {
        Point aEdge(mPoint[aEnd]-mPoint[aStart]);
        Point aAxis(Point(-aEdge.mY,aEdge.mX));
        if(!FindInterval(mPoint,mCount,aAxis).
            Intersects(FindInterval(aRectPoint,4,aAxis)))return false;
    }
    if(!FindInterval(mPoint,mCount,Point(0,1)).Intersects(Interval(theY,aRectPoint[2].mY)))return false;
    if(!FindInterval(mPoint,mCount,Point(1,0)).Intersects(Interval(theX,aRectPoint[2].mX)))return false;
    return true;
}
bool Poly::Intersects(Line theLine)
{
    for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)
    {
        if(SegmentsIntersect(theLine.mPoint[0],theLine.mPoint[1],mPoint[aStart],mPoint[aEnd]))
        return true;
    }
    return false;
}

bool Poly::Intersects(Point theCenter, Point theRadii)
{
    for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)
    {
        if(gMath.EllipseIntersectLine(theCenter,theRadii,Line(mPoint[aStart],mPoint[aEnd])))return true;
    }
    return false;
}

bool Poly::IsClockwise(Point aStart, Point aMiddle, Point aEnd)
{
    return (aMiddle.mX-aStart.mX)*(aEnd.mY-aMiddle.mY)-(aEnd.mX-aMiddle.mX)*(aMiddle.mY-aStart.mY) > 0;
}

bool Poly::IsClockwise()
{
    float aAreaSum=0;
    for(int aStart=0,aEnd=mCount-1;aStart<mCount;aEnd=aStart++)aAreaSum+=mPoint[aStart].Cross(mPoint[aEnd]);
    return aAreaSum < 0;
}

bool Poly::IsConvex()
{
    if(mCount<=3)return true;
    bool aCW=IsClockwise(mPointBase[0],mPointBase[1],mPointBase[2]);
    for(int aEnd=0,aMiddle=mCount-1,aStart=mCount-2;aEnd<mCount;aEnd++)
    {
        if(aCW != IsClockwise(mPointBase[aStart],mPointBase[aMiddle],mPointBase[aEnd]))return false;
        aStart=aMiddle;
        aMiddle=aEnd;
    }
    return true;
}

void Poly::ReverseDirection()
{
    int aCeil=mCount-1;
    Point *aTemp=mPointBase;
    mPointBase=new Point[mCount];
    for(int i=0;i<=aCeil;i++)
    {
        mPointBase[i]=aTemp[aCeil-i];
    }
    delete[]aTemp;
}

void Poly::GetTriangle(int theIndex, Point *thePoint1, Point *thePoint2, Point *thePoint3)
{
    thePoint1->mX=mPoint[mSub->mList[theIndex]->mIndex[0]].mX;
    thePoint1->mY=mPoint[mSub->mList[theIndex]->mIndex[0]].mY;
    
    thePoint2->mX=mPoint[mSub->mList[theIndex]->mIndex[1]].mX;
    thePoint2->mY=mPoint[mSub->mList[theIndex]->mIndex[1]].mY;
    
    thePoint3->mX=mPoint[mSub->mList[theIndex]->mIndex[2]].mX;
    thePoint3->mY=mPoint[mSub->mList[theIndex]->mIndex[2]].mY;
}

void Poly::Triangulate()
{
    if(mSub)
    {
        mSub->Clear();
        delete mSub;
        mSub=0;
    }
    
    if(mCount < 3)
    {
        return;
    }
    
    mSub=new SubPolyList();
    
    int aCount=mCount;
    //List of indeces that are still to be considered.
    int *aIndex=new int[aCount];
    
    //If it's counterclockwise,
    //put the index list in reverse order!
    if(IsCounterClockwise())
    {
        int aCeil=aCount-1;
        for(int i=0;i<=aCeil;i++)aIndex[i]=aCeil-i;
    }
    else for(int i=0;i<aCount;i++)aIndex[i]=i;
    
    mSub->Size(mCount);
    
    SubPoly *aSub;
    bool aContinue=true;
    while(aCount>3 && aContinue)
    {
        aContinue=false;
        for(int i=0;i<aCount&&aCount>3;i++)
        {
            //If it's an ear, clip it off!
            if(IsEar(aIndex,aCount,i))
            {
                aContinue=true;
                
                int aNext=i+1;
                if(aNext==aCount)aNext=0;
                int aPrev=i-1;
                if(aPrev==-1)aPrev=aCount-1;
                
                //Triangle consists of this ear,
                //and the points before and after it.
                aSub=new SubPoly();
                aSub->mCount=3;
                aSub->mIndex=new int[3];
                aSub->mIndex[0]=aIndex[aPrev];
                aSub->mIndex[1]=aIndex[i];
                aSub->mIndex[2]=aIndex[aNext];
                *mSub+=aSub;
                
                //Remove the ear from the list.
                aCount--;
                for(int n=i;n<aCount;n++)aIndex[n]=aIndex[n+1];
            }
        }
    }
    
    //Add all remaining points, if all went
    //according to plan, this should be
    //3 points, the final triangle...
    
    aSub=new SubPoly();
    aSub->mCount=aCount;
    aSub->mIndex=new int[aCount];
    for(int i=0;i<aCount;i++)
    {
        aSub->mIndex[i]=aIndex[i];
    }
    *mSub+=aSub;
    
    mSub->Tidy();
    
    delete [] aIndex;
}

//If the point is clockwise or counterclockwise from all 3 pairs,
//it must be in the triangle! Hurray!
bool Poly::TriangleContainsPoint(Point theT1, Point theT2, Point theT3, Point thePoint)
{
    bool aDirection=(thePoint.mX-theT1.mX)*(theT2.mY-thePoint.mY)-(theT2.mX-thePoint.mX)*(thePoint.mY-theT1.mY) >=0;
    if(aDirection!=((thePoint.mX-theT2.mX)*(theT3.mY-thePoint.mY)-(theT3.mX-thePoint.mX)*(thePoint.mY-theT2.mY) >=0))return false;
    return aDirection==((thePoint.mX-theT3.mX)*(theT1.mY-thePoint.mY)-(theT1.mX-thePoint.mX)*(thePoint.mY-theT3.mY) >=0);
}

bool Poly::IsEar(int *theIndexList, int theVertexCount, int theIndex)
{
    int aNext=theIndex+1;
    if(aNext==theVertexCount)aNext=0;
    int aPrev=theIndex-1;
    if(aPrev==-1)aPrev=theVertexCount-1;
    
    //The triangle with second point at the middle vertex.
    Point aPrevPoint(mPointBase[theIndexList[aPrev]]);
    Point aMiddlePoint(mPointBase[theIndexList[theIndex]]);
    Point aNextPoint(mPointBase[theIndexList[aNext]]);
    
    //If it's a concave point, there's no way it's an ear!
    if(IsCounterClockwise(aPrevPoint,aMiddlePoint,aNextPoint))return false;
    
    //If the potential ear's triangle contains any other points from the
    //polygon, it's not an ear at all! Nuke the imposter!
    for(int i=0;i<theIndex-1;i++)
    {
        if(TriangleContainsPoint(aPrevPoint,aMiddlePoint,aNextPoint,mPointBase[theIndexList[i]]))
        {
            return false;
        }
    }
    for(int i=theIndex+2;i<theVertexCount;i++)
    {
        if(TriangleContainsPoint(aPrevPoint,aMiddlePoint,aNextPoint,mPointBase[theIndexList[i]]))
        {
            return false;
        }
    }
    return true;
}

void Poly::SubPolyList::Size(int theSize)
{
    SubPoly **aSub=mList;
    mList=new SubPoly*[theSize];
    for(int i=0; i<mSize; i++)
    {
        mList[i]=aSub[i];
    }
    delete[]aSub;
    mSize=theSize;
}

void Poly::SubPolyList::operator+=(SubPoly *theSubPoly)
{
    mCount++;
    if(mCount > mSize)Size(mCount * 2 + 1);
    mList[mCount-1]=theSubPoly;
}

void Poly::SubPolyList::Tidy()
{
    if(mCount == mSize)return;
    SubPoly **aSub=mList;
    mList=new SubPoly*[mCount];
    for(int i=0; i<mCount; i++)
    {
        mList[i]=aSub[i];
    }
    delete[]aSub;
    mSize=mCount;
}

void Poly::SubPolyList::Clear()
{
    for(int i=0;i<mCount;i++)delete mList[i];
    delete[]mList;
    mList=0;
    mCount=0;
    mSize=0;
}

inline float Poly::TriangleArea(float x1, float y1, float x2, float y2, float x3, float y3)
{
    return (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1);
}

inline bool Poly::Between(float x1, float y1, float x2, float y2, float x3, float y3)
{
    if (x1 != x2)return (x1 <= x3 && x3 <= x2) || (x1 >= x3 && x3 >= x2);
    else return (y1 <= y3 && y3 <= y2) || (y1 >= y3 && y3 >= y2);
}

bool Poly::SegmentsIntersect(Point theStart1, Point theEnd1, Point theStart2, Point theEnd2)
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

bool Poly::Diagonal(int theIndex1, int theIndex2)
{
    if(abs(theIndex1 - theIndex2) <= 1)return true;
    if(theIndex1 > theIndex2)
    {
        int aHold=theIndex1;
        theIndex1=theIndex2;
        theIndex2=aHold;
    }
    for(int i=1;i<theIndex1;i++)
    {
        if(SegmentsIntersect(mPointBase[theIndex1], mPointBase[theIndex2], mPointBase[i-1], mPointBase[i]))return false;
    }
    for(int i=theIndex1+2;i<theIndex2;i++)
    {
        if(SegmentsIntersect(mPointBase[theIndex1], mPointBase[theIndex2], mPointBase[i-1], mPointBase[i]))return false;
    }
    for(int i=theIndex2+2;i<mCount;i++)
    {
        if(SegmentsIntersect(mPointBase[theIndex1], mPointBase[theIndex2], mPointBase[i-1], mPointBase[i]))return false;
    }
    if(theIndex1 != 0 && theIndex2 != mCount-1)
    {
        if(SegmentsIntersect(mPointBase[theIndex1], mPointBase[theIndex2], mPointBase[0], mPointBase[mCount-1]))return false;
    }
    return Intersects((mPointBase[theIndex1] + mPointBase[theIndex2]) / 2);
}

bool Poly::IsSimple()
{
    for(int i=1;i<mCount-2;i++)
    {
        for(int n=i+2; n<mCount; n++)
        {
            if(SegmentsIntersect(mPointBase[i], mPointBase[i-1],
                                 mPointBase[n], mPointBase[n-1]))
            {
                return false;
            }
        }
    }
    for(int i=2; i<mCount-1; i++)
    {
        if(SegmentsIntersect(mPointBase[mCount-1],mPointBase[0],
                             mPointBase[i],mPointBase[i-1]))
        {
            return false;
        }
    }
    return true;
}

void Poly::Decompose()
{
    if(mSub)
    {
        mSub->Clear();
        delete mSub;
        mSub=0;
    }
    
    if(mCount <= 3)
    {
        return;
    }
    
    mSub=new SubPolyList();
    mSub->Size(mCount);
    
    //Stack of unprocecced sub-polygons that may or may
    //not be convex.
    List aStack;
    aStack.GuaranteeSize(mCount);
    
    //List of indeces that are on the
    //convex partition of the polygon we
    //will be considering.
    int *aOnPolyList=new int[mCount];
    //Every time we find a point that's off of
    //the concex sub polygon, it goes here.
    int *aOffPolyList=new int[mCount];
    
    //First sub-polygon to consider is the
    //whole fucking thing.
    SubPoly *aWholePoly = new SubPoly();
    aWholePoly->mCount=mCount;
    aWholePoly->mIndex=new int[mCount];
    for(int i=0;i<mCount;i++)
    {
        aWholePoly->mIndex[i]=i;
    }
    aStack+=aWholePoly;
    
    //Until the stack is empty...!
    while(aStack.mCount > 0)
    {
        //Pop the top sub polygon off the stack and rape it.
        SubPoly *aSub=((SubPoly*)aStack.Last());
        aStack.mCount--;
        
        //Triangles require no extra work.
        if(aSub->mCount<=3)
        {
            *mSub+=aSub;
            continue;
        }
        
        //This counts the number of clockwise and counter-
        //clockwise kinks on the current sub poly.
        int aStart=aSub->mCount-2;
        int aMiddle=aSub->mCount-1;
        int aEnd=0;
        int aCWCount=0;
        int aCCWCount=0;
        while(aEnd<aSub->mCount)
        {
            if(IsClockwise(mPointBase[aSub->mIndex[aStart]],mPointBase[aSub->mIndex[aMiddle]],mPointBase[aSub->mIndex[aEnd]]))
            {
                aCWCount++;
            }
            else
            {
                aCCWCount++;
            }
            aStart=aMiddle;
            aMiddle=aEnd;
            aEnd++;
        }
        
        //If it's convex after this inspection, add it!
        if(aCCWCount <= 0 || aCWCount <= 0)
        {
            *mSub+=aSub;
            continue;
        }
        
        //If it's clockwise, reverse it!
        if(aCCWCount > aCWCount)
        {
            int *aTemp=aSub->mIndex;
            aSub->mIndex=new int[aSub->mCount];
            int aCeil=aSub->mCount-1;
            for(int i=0;i<=aCeil;i++)aSub->mIndex[i]=aTemp[aCeil-i];
            delete[]aTemp;
        }
        
        //We arbitrarily pick a starting index for our convex sub-polygon.
        aOnPolyList[0]=aSub->mIndex[0];
        //And the next index is part of it..
        aOnPolyList[1]=aSub->mIndex[1];
        
        aStart=0;
        aMiddle=1;
        aEnd=2;
        
        int aOnPolyIndex=2;
        int aOffPolyIndex=0;
        
        //For each vertex after the first two,
        //check if they're part of the convex polygon we're
        //constructing.
        while(aEnd<aSub->mCount-1)
        {
            bool aFound=false;
            
            /*What we figured out earlier from testing is that
             the next point will be part of the convex subolygon if
             1.) The kink [last point] [this] [first point] is CW
             2.) The kink [second last point] [last point] [this] is CW
             3.)A valid diagonal exists between the two points. A valid
             diagonal does not cross any edges and is inside of the polygon!*/
            
            if(IsClockwise(mPointBase[aSub->mIndex[aEnd]],
                           mPointBase[aSub->mIndex[0]],
                           mPointBase[aSub->mIndex[1]]))
            {
                if(IsClockwise(mPointBase[aSub->mIndex[aStart]],
                               mPointBase[aSub->mIndex[aMiddle]],
                               mPointBase[aSub->mIndex[aEnd]]))
                {
                    if(Diagonal(aSub->mIndex[0], aSub->mIndex[aEnd]))
                    {
                        //Add it to the list!
                        aOnPolyList[aOnPolyIndex]=aSub->mIndex[aEnd];
                        aOnPolyIndex++;
                        aFound=true;
                        aStart=aMiddle;
                        aMiddle=aEnd;
                        
                        //If we have some indeces from another sub poly that
                        //is not part of this, we end that sub poly and
                        //push it onto the stack.
                        if(aOffPolyIndex)
                        {
                            //All of this shit figured out through trial and error.
                            SubPoly *aNewSub = new SubPoly();
                            aNewSub->mCount=aOffPolyIndex+2;
                            aNewSub->mIndex=new int[aNewSub->mCount];
                            int aLastIndex=aOffPolyList[aOffPolyIndex-1];
                            int aFirstIndex=aOffPolyList[0];
                            
                            for(int i=0;i<aOffPolyIndex;i++)
                            {
                                aNewSub->mIndex[i+1]=aOffPolyList[i];
                            }
                            if(aFirstIndex > aLastIndex)
                            {
                                aNewSub->mIndex[aOffPolyIndex+1]=aLastIndex-1;
                                aNewSub->mIndex[0]=aFirstIndex+1;
                            }
                            else
                            {
                                aNewSub->mIndex[0]=aFirstIndex-1;
                                aNewSub->mIndex[aOffPolyIndex+1]=aLastIndex+1;
                            }
                            aStack+=aNewSub;
                            aOffPolyIndex=0;
                        }
                    }
                }
            }
            //If this point is not on the convex sub poly, we add it to the
            //list of indeces off of the "good" list.
            if(!aFound)
            {
                aOffPolyList[aOffPolyIndex]=aSub->mIndex[aEnd];
                aOffPolyIndex++;
            }
            aEnd++;
        }
        
        /*This is a special case for the last point...
         We follow the first two criterea still:
         
         1.) The kink [last point] [this] [first point] is CW
         2.) The kink [second last point] [last point] [this] is CW
         
         but since the last point is right next to the first, we already
         know the valid diagonal exists... it is part of the main polygon!*/
        
        bool aFound=false;
        if(IsClockwise(mPointBase[aSub->mIndex[aEnd]],
                       mPointBase[aSub->mIndex[0]],
                       mPointBase[aSub->mIndex[1]]))
        {
            if(IsClockwise(mPointBase[aSub->mIndex[aStart]],
                           mPointBase[aSub->mIndex[aMiddle]],
                           mPointBase[aSub->mIndex[aEnd]]))
            {
                aOnPolyList[aOnPolyIndex]=aSub->mIndex[aEnd];
                aOnPolyIndex++;
                aFound=true;
            }
        }
        if(!aFound)
        {
            aOffPolyList[aOffPolyIndex]=aSub->mIndex[aEnd];
            aOffPolyIndex++;
        }
        
        //If there are any lingering indeces on the "bad" polygon list,
        //we have about 50,000 cases to consider because the universe
        //is just not user friendly.
        
        //I don't really remember why each of these cases is as it is,
        //I figured most of them out through trial and error with educated guessing.
        if(aOffPolyIndex && aOnPolyIndex > 2)
        {
            SubPoly *aNewSub=new SubPoly();
            //The only thing consistent is the size of the new bad sub polygon.
            aNewSub->mCount=aOffPolyIndex+2;
            aNewSub->mIndex=new int[aNewSub->mCount];
            
            int aLastIndex=aOffPolyList[aOffPolyIndex-1];
            int aFirstIndex=aOffPolyList[0];
            
            //It's a backwards polygon!
            if(aFirstIndex >= aLastIndex)
            {
                //The last index is on the bad polygon.
                if(aFound)
                {
                    for(int i=0;i<aOffPolyIndex;i++)
                    {
                        aNewSub->mIndex[i+1]=aOffPolyList[i];
                    }
                    aNewSub->mIndex[0]=aFirstIndex+1;
                    aNewSub->mIndex[aOffPolyIndex+1]=aLastIndex-1;
                }
                    //Last index not on the bad polygon.
                else
                {
                    for(int i=0;i<aOffPolyIndex;i++)
                    {
                        aNewSub->mIndex[i+2]=aOffPolyList[i];
                    }
                    //Utter bullshit... No other cases need anything like this!
                    if(aSub->mIndex[aSub->mCount-1] > aSub->mIndex[0])
                    {
                        aNewSub->mIndex[1]=aSub->mIndex[aSub->mCount-1]-1;
                        aNewSub->mIndex[0]=aSub->mIndex[0];
                    }
                    else
                    {
                        aNewSub->mIndex[1]=aFirstIndex+1;
                        aNewSub->mIndex[0]=aSub->mIndex[0];
                    }
                    
                }
            }
                //It's a nice normal clockwise subpolygon!
            else
            {
                //The last index is on our bad poly.
                if(aFound)
                {
                    for(int i=0;i<aOffPolyIndex;i++)
                    {
                        aNewSub->mIndex[i+1]=aOffPolyList[i];
                    }
                    aNewSub->mIndex[0]=aFirstIndex-1;
                    aNewSub->mIndex[aOffPolyIndex+1]=aLastIndex+1;
                }
                    //The last index hain't on our bad poly.
                else
                {
                    for(int i=0;i<aOffPolyIndex;i++)
                    {
                        aNewSub->mIndex[i+2]=aOffPolyList[i];
                    }
                    aNewSub->mIndex[0]=aSub->mIndex[0];
                    aNewSub->mIndex[1]=aFirstIndex-1;
                }
            }
            //Push the bad polygon onto the stack to be
            //checked out.
            aStack+=aNewSub;
        }
        
        //Ahh, the fruit of our labour! A convex subpolygon
        //that is ripped out of a nonvex shit-gon.
        SubPoly *aNewConvexSub = new SubPoly();
        aNewConvexSub->mIndex=new int[aOnPolyIndex];
        aNewConvexSub->mCount=aOnPolyIndex;
        for(int i=0;i<aOnPolyIndex;i++)
        {
            aNewConvexSub->mIndex[i]=aOnPolyList[i];
        }
        *mSub+=aNewConvexSub;
        
        //Delete the polygon that we broke down since all its info exists in
        //small subpolygons now!
        delete aSub;
    }
    
    delete[]aOnPolyList;
    delete[]aOffPolyList;
    
    //This should always be true, but just as a precaution, let's
    //make sure we have at least two sub-polygons.
    
    if(mSub->mCount >= 2)
    {
        mSub->Tidy();
    }
    else
    {
        mSub->Clear();
        delete mSub;
        mSub=0;
    }
}

*/
