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
    var data = [(x:CGFloat, y:CGFloat)]()
    
    var count:Int { return _count }
    internal var _count:Int = 0
    
    func reset() {
        _count = 0
    }
    
    func clear() {
        reset()
        data.removeAll()
    }
    
    func add(x x:CGFloat, y:CGFloat) {
        set(_count, x: x, y: y)
    }
    
    
    func add(list list:PointList) {
        
        for i in 0..<list.count {
            add(x: list.data[i].x, y: list.data[i].y)
        }
        
        
        //for listData:(x:CGFloat, y:CGFloat) in list.data {
        //    add(x: listData.x, y: listData.y)
        //}
        
    }
    
    func set(index:Int, x:CGFloat, y:CGFloat) {
        if index >= _count {
            _count = index + 1
            let newCapacity = _count + _count / 2 + 1
            data.reserveCapacity(newCapacity)
            while data.count <= _count {
                data.append((0.0, 0.0))
            }
        }
        data[index] = (x, y)
    }
    
    
    func transform(scaleX scaleX:CGFloat, scaleY scaleY:CGFloat, rotation:CGFloat) {
        
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
        
        /*
        if(pRotation != 0.0f)
        {
            pRotation = pRotation * 0.01745329251994329576923690768488;
            float aX = 0.0f;
            float aY = 0.0f;
            float aDist = 0.0f;
            float aPivot = 0.0f;
            for(int i=0;i<mCount;i++)
            {
                aX = mX[i] * pScaleX;
                aY = mY[i] * pScaleY;
                aDist = aX * aX + aY * aY;
                
                if(aDist > SQRT_EPSILON)
                {
                    aDist = sqrtf(aDist);
                    aX /= aDist;
                    aY /= aDist;
                }
                aPivot = (pRotation - atan2f(-aX, -aY));
                mX[i] = (sin(aPivot)) * aDist;
                mY[i] = (-cos(aPivot)) * aDist;
            }
        }
        else
        {
            if(pScaleX != 1.0f)for(int i=0;i<mCount;i++)mX[i] *= pScaleX;
            if(pScaleY != 1.0f)for(int i=0;i<mCount;i++)mY[i] *= pScaleY;
        }
        */
    }
    
    func transform(scale scale:CGFloat, rotation:CGFloat) {
        transform(scaleX: scale, scaleY: scale, rotation: rotation)
    }
    
    func transform(translation translation:CGPoint) {
        
            for i in 0..<count {
                data[i].x = data[i].x + translation.x
                data[i].y = data[i].y + translation.y
            }
        
    }
    
    
    func drawEdges(closed closed:Bool) {
        guard count >= 2 else { return }
        var prev = data[0]
        var startIndex = 1
        if closed {
            prev = data[count - 1]
            startIndex = 0
        }
        for i in startIndex..<count {
            let point = data[i]
            gG.lineDraw(p1: CGPoint(x: prev.x, y: prev.y), p2: CGPoint(x: point.x, y: point.y), thickness: 0.5)
            prev = point
        }
    }
    
    func drawPoints() {
        for i in 0..<count {
            let point = data[i]
            gG.pointDraw(point: CGPoint(x: point.x, y: point.y))
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


void FPointList::Transform(float pX, float pY, float pScaleX, float pScaleY, float pRotation)
{
    TransformScaleRotate(pScaleX, pScaleY, pRotation);
    TransformTranslate(pX, pY);
}

void FPointList::TransformScaleRotate(float pScaleX, float pScaleY, float pRotation)
{
    if(pRotation != 0.0f)
    {
        pRotation = pRotation * 0.01745329251994329576923690768488;
        float aX = 0.0f;
        float aY = 0.0f;
        float aDist = 0.0f;
        float aPivot = 0.0f;
        for(int i=0;i<mCount;i++)
        {
            aX = mX[i] * pScaleX;
            aY = mY[i] * pScaleY;
            aDist = aX * aX + aY * aY;
            
            if(aDist > SQRT_EPSILON)
            {
                aDist = sqrtf(aDist);
                aX /= aDist;
                aY /= aDist;
            }
            aPivot = (pRotation - atan2f(-aX, -aY));
            mX[i] = (sin(aPivot)) * aDist;
            mY[i] = (-cos(aPivot)) * aDist;
        }
    }
    else
    {
        if(pScaleX != 1.0f)for(int i=0;i<mCount;i++)mX[i] *= pScaleX;
        if(pScaleY != 1.0f)for(int i=0;i<mCount;i++)mY[i] *= pScaleY;
    }
}

void FPointList::TransformTranslate(float pX, float pY)
{
    if(pX != 0)for(int i=0;i<mCount;i++)mX[i] += pX;
    if(pY != 0)for(int i=0;i<mCount;i++)mY[i] += pY;
}

void FPointList::Untransform(float pX, float pY, float pScaleX, float pScaleY, float pRotation)
{
    UntransformTranslate(pX, pY);
    
    if((pScaleX != 1.0f) || (pScaleY != 1.0f) || (pRotation != 0.0f))
    UntransformScaleRotate(pScaleX, pScaleY, pRotation);
}

void FPointList::UntransformScaleRotate(float pScaleX, float pScaleY, float pRotation)
{
    if((pScaleX < -0.01f) || (pScaleX > -0.01f) || (pScaleY < -0.01f) || (pScaleY > -0.01f))
    {
        TransformScaleRotate(1.0 / pScaleX, 1.0 / pScaleY, -pRotation);
    }
}

void FPointList::UntransformTranslate(float pX, float pY)
{
    TransformTranslate(-pX, -pY);
}

*/

