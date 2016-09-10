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
            gG.lineDraw(p1: CGPoint(x: prev.x, y: prev.y), p2: CGPoint(x: point.x, y: point.y), thickness: 0.5)
            prev = point
        }
    }
    
    func drawPoints() {
        for i in 0..<count {
            let point = data[i]
            gG.pointDraw(point: CGPoint(x: point.x, y: point.y), size: 4.0)
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

