//
//  LineSegment.swift
//  Bounce
//
//  Created by Nicholas Raptis on 9/4/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

struct LineIntersection {
    var intersects = false
    var point = CGPoint.zero
    var distance:CGFloat = 0.0
}

class LineSegment
{
    var x1:CGFloat = 0.0
    var y1:CGFloat = 0.0
    var x2:CGFloat = 0.0
    var y2:CGFloat = 0.0
    
    var deltaX:CGFloat {
        return x2 - x1
    }
    
    var deltaY:CGFloat {
        return y2 - y1
    }
    
    var p1:CGPoint {
        get {
            return CGPoint(x: x1, y: y1)
        }
        set {
            x1 = newValue.x
            y1 = newValue.y
        }
    }
    
    var p2:CGPoint {
        get {
            return CGPoint(x: x2, y: y2)
        }
        set {
            x2 = newValue.x
            y2 = newValue.y
        }
    }
    
    var direction:CGPoint {
        var dirX = deltaX
        var dirY = deltaY
        var lineLength = dirX * dirX + dirY * dirY
        if lineLength > Math.epsilon {
            lineLength = CGFloat(sqrtf(Float(lineLength)))
            dirX /= lineLength
            dirY /= lineLength
        } else {
            dirX = 0.0
            dirY = -1.0
        }
        return CGPoint(x: dirX, y: dirY)
    }
    
    var normal:CGPoint {
        let dir = direction
        return CGPoint(x: -dir.y, y: dir.x)
    }
    
    //This one never misses...
    class func SegmentsIntersect(l1:LineSegment, l2:LineSegment) -> Bool {
        
        return LineSegment.SegmentsIntersect(l1p1: l1.p1, l1p2: l1.p2, l2p1: l2.p1, l2p2: l2.p2)
        
        /*
        let area1 = TriangleArea(x1: l1.x1, y1: l1.y1, x2: l1.x2, y2: l1.y2, x3: l2.x1, y3: l2.y1)
        if(area1 == 0)
        {
            if(Between(x1: l1.x1, y1: l1.y1, x2: l1.x2, y2: l1.y2, x3: l2.x1, y3: l2.y1)) {
                return true
            } else {
                if(TriangleArea(x1: l1.x1, y1: l1.y1, x2: l1.x2, y2: l1.y2, x3: l2.x2, y3: l2.y2) == 0) {
                    if(Between(x1: l2.x1, y1: l2.y1, x2: l2.x2, y2: l2.y2, x3: l1.x1, y3: l1.y1)) { return true }
                    if(Between (x1: l2.x1, y1: l2.y1, x2: l2.x2, y2: l2.y2, x3: l1.x2, y3: l1.y2)) { return true }
                    return false
                }
                else { return false }
            }
        }
        let area2 = TriangleArea(x1: l1.x1, y1: l1.y1, x2: l1.x2, y2: l1.y2, x3: l2.x2, y3: l2.y2)
        if(area2 == 0) {
            return Between(x1: l1.x1, y1: l1.y1, x2: l1.x2, y2: l1.y2, x3: l2.x2, y3: l2.y2)
        }
        let area3 = TriangleArea(x1: l2.x1, y1: l2.y1, x2: l2.x2, y2: l2.y2, x3: l1.x1, y3: l1.y1)
        if(area3 == 0) {
            if(Between(x1: l2.x1, y1: l2.y1, x2: l2.x2, y2: l2.y2, x3: l1.x1, y3: l1.y1)) {
                return true
            } else {
                if(TriangleArea(x1: l2.x1, y1: l2.y1, x2: l2.x2, y2: l2.y2, x3: l1.x2, y3: l1.y2) == 0) {
                    if(Between(x1: l1.x1, y1: l1.y1, x2: l1.x2, y2: l1.y2, x3: l2.x1, y3: l2.y1)) { return true }
                    if(Between (x1: l1.x1, y1: l1.y1, x2: l1.x2, y2: l1.y2, x3: l2.x2, y3: l2.y2)) { return true }
                    return false
                }
                return false
            }
        }
        let area4 = TriangleArea(x1: l2.x1, y1: l2.y1, x2: l2.x2, y2: l2.y2, x3: l1.x2, y3: l1.y2)
        if(area4 == 0) {
            return Between(x1: l2.x1, y1: l2.y1, x2: l2.x2, y2: l2.y2, x3: l1.x2, y3: l1.y2)
        }
        return (((area1 > 0) != (area2 > 0)) && ((area3 > 0) != (area4 > 0)))
        */
    }
    
    class func SegmentsIntersect(l1p1:CGPoint, l1p2:CGPoint, l2p1:CGPoint, l2p2:CGPoint) -> Bool {
        let area1 = TriangleArea(x1: l1p1.x, y1: l1p1.y, x2: l1p2.x, y2: l1p2.y, x3: l2p1.x, y3: l2p1.y)
        if(area1 == 0)
        {
            if(Between(x1: l1p1.x, y1: l1p1.y, x2: l1p2.x, y2: l1p2.y, x3: l2p1.x, y3: l2p1.y)) {
                return true
            } else {
                if(TriangleArea(x1: l1p1.x, y1: l1p1.y, x2: l1p2.x, y2: l1p2.y, x3: l2p2.x, y3: l2p2.y) == 0) {
                    if(Between(x1: l2p1.x, y1: l2p1.y, x2: l2p2.x, y2: l2p2.y, x3: l1p1.x, y3: l1p1.y)) { return true }
                    if(Between (x1: l2p1.x, y1: l2p1.y, x2: l2p2.x, y2: l2p2.y, x3: l1p2.x, y3: l1p2.y)) { return true }
                    return false
                }
                else { return false }
            }
        }
        let area2 = TriangleArea(x1: l1p1.x, y1: l1p1.y, x2: l1p2.x, y2: l1p2.y, x3: l2p2.x, y3: l2p2.y)
        if(area2 == 0) {
            return Between(x1: l1p1.x, y1: l1p1.y, x2: l1p2.x, y2: l1p2.y, x3: l2p2.x, y3: l2p2.y)
        }
        let area3 = TriangleArea(x1: l2p1.x, y1: l2p1.y, x2: l2p2.x, y2: l2p2.y, x3: l1p1.x, y3: l1p1.y)
        if(area3 == 0) {
            if(Between(x1: l2p1.x, y1: l2p1.y, x2: l2p2.x, y2: l2p2.y, x3: l1p1.x, y3: l1p1.y)) {
                return true
            } else {
                if(TriangleArea(x1: l2p1.x, y1: l2p1.y, x2: l2p2.x, y2: l2p2.y, x3: l1p2.x, y3: l1p2.y) == 0) {
                    if(Between(x1: l1p1.x, y1: l1p1.y, x2: l1p2.x, y2: l1p2.y, x3: l2p1.x, y3: l2p1.y)) { return true }
                    if(Between (x1: l1p1.x, y1: l1p1.y, x2: l1p2.x, y2: l1p2.y, x3: l2p2.x, y3: l2p2.y)) { return true }
                    return false
                }
                return false
            }
        }
        let area4 = TriangleArea(x1: l2p1.x, y1: l2p1.y, x2: l2p2.x, y2: l2p2.y, x3: l1p2.x, y3: l1p2.y)
        if(area4 == 0) {
            return Between(x1: l2p1.x, y1: l2p1.y, x2: l2p2.x, y2: l2p2.y, x3: l1p2.x, y3: l1p2.y)
        }
        return (((area1 > 0) != (area2 > 0)) && ((area3 > 0) != (area4 > 0)))
    }
    
    internal class func TriangleArea(x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat, x3:CGFloat, y3:CGFloat) -> CGFloat {
        return (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1)
    }
    
    internal class func Between(x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat, x3:CGFloat, y3:CGFloat) -> Bool {
        if x1 != x2 {
            return (((x1 <= x3) && (x3 <= x2)) || ((x1 >= x3) && (x3 >= x2)))
        } else {
            return ((y1 <= y3) && (y3 <= y2)) || ((y1 >= y3) && (y3 >= y2))
        }
    }
    
    class func SegmentSegmentIntersection(l1:LineSegment, l2:LineSegment) -> LineIntersection {
        if LineSegment.SegmentsIntersect(l1: l1, l2: l2) {
            let planeOrigin = l2.p1
            let planeDir = l2.direction
            return LineSegment.LinePlaneIntersection(line: l1, planeX: planeOrigin.x, planeY: planeOrigin.y, planeDirX: planeDir.x, planeDirY: planeDir.y)
        }
        return LineIntersection()
    }
    
    class func LinePlaneIntersection(line:LineSegment, planeX:CGFloat, planeY:CGFloat, planeDirX:CGFloat, planeDirY:CGFloat) -> LineIntersection {
        var result = LineIntersection()
        var lineDirX = line.deltaX
        var lineDirY = line.deltaY
        var lineLength = lineDirX * lineDirX + lineDirY * lineDirY
        if lineLength > Math.epsilon {
            lineLength = CGFloat(sqrtf(Float(lineLength)))
            lineDirX /= lineLength
            lineDirY /= lineLength
        } else {
            lineDirX = 0.0
            lineDirY = -1.0
        }
        let lineNormX = -lineDirY
        let lineNormY = lineDirX
        let numer:CGFloat = lineNormX * planeX + lineNormY * planeY - Math.dotProduct(x1: line.x1, y1: line.y1, x2: lineNormX, y2: lineNormY)
        let denom:CGFloat = planeDirX * lineNormX + planeDirY * lineNormY
        if (denom < -Math.epsilon) || (denom > Math.epsilon) {
            let dist = -(numer / denom)
            result.intersects = true
            result.point = CGPoint(x: planeX + planeDirX * dist, y: planeY + planeDirY * dist)
            result.distance = dist
        }
        return result
    }
    
    class func SegmentClosestPoint(line:LineSegment, point:CGPoint) -> CGPoint {
        var result = CGPoint(x: line.x1, y: line.y1)
        let factor1X = (point.x - line.x1)
        let factor1Y = (point.y - line.y1)
        let lineDiffX = line.deltaX
        let lineDiffY = line.deltaY
        var factor2X = lineDiffX
        var factor2Y = lineDiffY
        var lineLength = lineDiffX * lineDiffX + lineDiffY * lineDiffY
        if(lineLength > Math.epsilon) {
            lineLength = CGFloat(sqrtf(Float(lineLength)))
            factor2X /= lineLength
            factor2Y /= lineLength
            let scalar = factor2X * factor1X + factor2Y * factor1Y;
            if scalar < 0.0 {
                result.x = line.x1
                result.y = line.y1
            } else if scalar > lineLength {
                result.x = line.x2;
                result.y = line.y2;
            } else {
                result.x = line.x1 + factor2X * scalar;
                result.y = line.y1 + factor2Y * scalar;
            }
        }
        return result
    }
}

/*
 #include "core_includes.h"
 #include "FLine.h"
 
 #define PHYSICS_DOT(x1,y1,x2,y2)((x1)*(x2)+(y1)*(y2))
 #define PHYSICS_CROSS(x1,y1,x2,y2)((x1)*(y2)-(x2)*(y1))
 
 FLine::FLine(float x1,float y1,float x2,float y2)
 {
 Make(x1,y1,x2,y2);
 }
 
 FLine::FLine()
 {
 Make(0,0,0,0);
 }
 
 FLine::~FLine()
 {
 
 }
 
 void FLine::Make(float x1,float y1,float x2,float y2)
 {
 mX1=x1;
 mY1=y1;
 
 mX2=x2;
 mY2=y2;
 
 mDiffX=mX2-mX1;
 mDiffY=mY2-mY1;
 
 mLength=mDiffX*mDiffX+mDiffY*mDiffY;
 
 if(mLength > SQRT_EPSILON)
 {
 mLength=sqrtf(mLength);
 
 mDirX=mDiffX/mLength;
 mDirY=mDiffY/mLength;
 }
 else
 {
 mLength=0;
 
 mDiffX=1;
 mDiffY=0;
 
 mDirX=mDiffX;
 mDirY=mDiffY;
 }
 
 mNormalX = -mDirY;
 mNormalY = mDirX;
 
 mCross=(-PHYSICS_DOT(mX1,mY1,mNormalX,mNormalY));
 }
 
 bool FLine::SegmentSegmentIntersection(float pL_1_x1, float pL_1_y1, float pL_1_x2, float pL_1_y2,
 float pL_2_x1, float pL_2_y1, float pL_2_x2, float pL_2_y2,
 float &pCollideX, float &pCollideY, float &pCollideDistance)
 {
 float aPlaneX = pL_2_x1;
 float aPlaneY = pL_2_y1;
 
 float aPlaneDirX = pL_2_x2 - pL_2_x1;
 float aPlaneDirY = pL_2_y2 - pL_2_y1;
 
 float aPlaneLength = (aPlaneDirX * aPlaneDirX) + (aPlaneDirY * aPlaneDirY);
 
 if(aPlaneLength >= 0.1f)
 {
 aPlaneLength = sqrtf(aPlaneLength);
 
 aPlaneDirX /= aPlaneLength;
 aPlaneDirY /= aPlaneLength;
 }
 
 bool aReturn = false;
 
 if(SegmentPlaneIntersection(pL_1_x1, pL_1_y1, pL_2_x2, pL_2_y2, aPlaneX, aPlaneY, aPlaneDirX, aPlaneDirY, pCollideX, pCollideY, pCollideDistance))
 {
 aReturn = true;
 }
 
 return aReturn;
 
 }
 
 bool FLine::SegmentPlaneIntersection(float pL_1_x1, float pL_1_y1, float pL_1_x2, float pL_1_y2,
 float pPlaneX, float pPlaneY, float pPlaneDirX, float pPlaneDirY,
 float &pCollideX, float &pCollideY, float &pCollideDistance)
 {
 
 float aLineSpanX = pL_1_x2 - pL_1_x1;
 float aLineSpanY = pL_1_y2 - pL_1_y1;
 
 float aLineLength = aLineSpanX * aLineSpanX + aLineSpanY * aLineSpanY;
 
 float aLineDirX = aLineSpanX;
 float aLineDirY = aLineSpanY;
 
 if(aLineLength > SQRT_EPSILON)
 {
 aLineLength = sqrtf(aLineLength);
 aLineDirX /= aLineLength;
 aLineDirY /= aLineLength;
 }
 else
 {
 aLineDirX = 0;
 aLineDirY = -1;
 }
 
 float aLineNormX = -aLineDirY;
 float aLineNormY = aLineDirX;
 
 float aLineCross = (-PHYSICS_DOT(pL_1_x1, pL_1_y1, aLineNormX, aLineNormY));
 
 float aDenom = pPlaneDirX * aLineNormX + pPlaneDirY * aLineNormY;
 float aNumer = aLineNormX * pPlaneX + aLineNormY * pPlaneY + aLineCross;
 
 if((aDenom < (-SQRT_EPSILON)) || (aDenom > SQRT_EPSILON))
 {
 float aDist = -(aNumer/aDenom);
 
 pCollideX = pPlaneX + pPlaneDirX * aDist;
 pCollideY = pPlaneY + pPlaneDirY * aDist;
 pCollideDistance = aDist;
 
 FLine aLine;
 aLine.Make(pL_1_x1, pL_1_y1, pL_1_x2, pL_1_y2);
 
 float aClosestCollideX = pCollideX;
 float aClosestCollideY = pCollideY;
 
 if(FLine::SegmentClosestPoint(pL_1_x1, pL_1_y1, pL_1_x2, pL_1_y2, pCollideX, pCollideY, aClosestCollideX, aClosestCollideY))
 {
 return true;
 }
 }
 
 return false;
 }
 
 bool FLine::SegmentClosestPoint(float pLineX1, float pLineY1, float pLineX2, float pLineY2, float pPointX, float pPointY, float &pClosestX, float &pClosestY)
 {
 bool aReturn = false;
 
 pClosestX = pLineX1;
 pClosestY = pLineY1;
 
 float factor1X = (pPointX - pLineX1);
 float factor1Y = (pPointY - pLineY1);
 
 float factor2X = pLineX2 - pLineX1;
 float factor2Y = pLineY2 - pLineY1;
 
 
 float aLineDiffX = (pLineX2 - pLineX1);
 float aLineDiffY = (pLineY2 - pLineY1);
 
 float aLineLength = (aLineDiffX * aLineDiffX) + (aLineDiffY * aLineDiffY);
 
 if(aLineLength > SQRT_EPSILON)
 {
 aLineLength = sqrtf(aLineLength);
 
 factor2X /= aLineLength;
 factor2Y /= aLineLength;
 
 float scalar = factor2X * factor1X + factor2Y * factor1Y;
 
 if(scalar < 0)
 {
 pClosestX = pLineX1;
 pClosestY = pLineY1;
 }
 else if(scalar > aLineLength)
 {
 pClosestX = pLineX2;
 pClosestY = pLineY2;
 }
 else
 {
 
 pClosestX = pLineX1 + factor2X * scalar;
 pClosestY = pLineY1 + factor2Y * scalar;
 
 aReturn = true;
 }
 }
 
 return aReturn;
 }
 
 bool FLine::SegmentRayIntersection(float pL_1_x1, float pL_1_y1, float pL_1_x2, float pL_1_y2,
 float pRayX, float pRayY, float pRayDirX, float pRayDirY, float pRayLength,
 float &pCollideX, float &pCollideY, float &pCollideDistance)
 {
 FLine aLine;
 
 aLine.Make(pL_1_x1, pL_1_y1, pL_1_x2, pL_1_y2);
 
 
 
 float aPlaneDist = aLine.RayPlaneDist(pRayX, pRayY, pRayDirX, pRayDirY);
 
 if((aPlaneDist > pRayLength) || (aPlaneDist < 0.0f))
 {
 return false;
 }
 
 pCollideX = pRayX + pRayDirX * aPlaneDist;
 pCollideY = pRayY + pRayDirY * aPlaneDist;
 
 pCollideDistance = aPlaneDist;
 
 return true;
 }
 
 
 float FLine::RayPlaneDist(float x, float y, float pDirX, float pDirY)
 {
 float aDenom=pDirX*mNormalX+pDirY*mNormalY;
 if(aDenom <= SQRT_EPSILON && aDenom>=0)return 0;
 if(aDenom >= SQRT_EPSILON && aDenom<=0)return 0;
 float aCosAlpha=mCross;
 float aNumer=mNormalX*x+mNormalY*y + aCosAlpha;
 return -(aNumer/aDenom);
 }
 
 void FLine::ClosestPoint(float x, float y, float &pClosestX, float &pClosestY)
 {
 pClosestX = mX1;
 pClosestY = mY1;
 
 float factor1X = (x - mX1);
 float factor1Y = (y - mY1);
 
 float factor2X = mX2 - mX1;
 float factor2Y = mY2 - mY1;
 
 float aLength = mLength;
 
 if(aLength > SQRT_EPSILON)
 {
 factor2X /= mLength;
 factor2Y /= mLength;
 
 float scalar=factor2X*factor1X+factor2Y*factor1Y;
 
 if(scalar<0)
 {
 pClosestX = mX1;
 pClosestY = mY1;
 }
 else if(scalar>mLength)
 {
 pClosestX = mX2;
 pClosestY = mY2;
 }
 else
 {
 pClosestX=mX1+factor2X*scalar;
 pClosestY=mY1+factor2Y*scalar;
 }
 }
 }
 
 float FLine::GetDist(float x, float y, int &pIndex)
 {
 float aDiffX, aDiffY, aDist1, aDist2;
 
 aDiffX=x-mX1;
 aDiffY=y-mY1;
 aDist1=aDiffX*aDiffX+aDiffY*aDiffY;
 aDiffX=x-mX2;
 aDiffY=y-mY2;
 aDist2=aDiffX*aDiffX+aDiffY*aDiffY;
 
 float aDist;
 
 if(aDist1<aDist2)
 {
 pIndex=0;
 aDist=aDist1;
 }
 else
 {
 pIndex=1;
 aDist=aDist2;
 }
 
 if(aDist > SQRT_EPSILON)
 {
 //aDist = SquareRoot(aDist);
 aDist = sqrtf(aDist);
 
 }
 else
 {
 aDist=0;
 }
 
 return aDist;
 
 }
 
 int FLine::GetPoint(float x, float y, float pDist)
 {
 int aReturn=-1;
 
 float aDiffX, aDiffY, aDist1, aDist2;
 
 aDiffX=x-mX1;
 aDiffY=y-mY1;
 
 aDist1=aDiffX*aDiffX+aDiffY*aDiffY;
 
 aDiffX=x-mX2;
 aDiffY=y-mY2;
 
 aDist2=aDiffX*aDiffX+aDiffY*aDiffY;
 
 if(aDist1<aDist2)
 {
 if(aDist1 < pDist*pDist)
 {
 aReturn=0;
 }
 }
 else
 {
 if(aDist2 < pDist*pDist)
 {
 aReturn=1;
 }
 }
 
 return aReturn;
 
 }
 
 void FLine::SetPoint(int pIndex, float x, float y)
 {
 if(pIndex==0)Make(x,y,mX2,mY2);
 else Make(mX1,mY1,x,y);
 }
 
 void FLine::Draw()
 {
 Graphics::SetColor(0, 0, 0);
 
 Graphics::DrawLine(mX1, mY1, mX2, mY2);
 
 }
 
 */









