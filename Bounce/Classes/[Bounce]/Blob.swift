//
//  Blob.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/22/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import OpenGLES

struct BlobGridNode {
    
    //Base = untransformed, no Base = transformed...
    var point:CGPoint = CGPointZero
    var pointBase:CGPoint = CGPointZero
    
    var inside:Bool = false
    var border:Bool = false
    
    var color:UIColor = UIColor.whiteColor()
    
}

public class Blob
{
    var grid = [[BlobGridNode]]()
    
    weak var touch:UITouch?
    
    var spline = CubicSpline()
    
    var demoPos:CGFloat = 0.0
    
    var valid:Bool = false
    
    //Base = untransformed, no Base = transformed...
    var borderBase = PointList()
    var border = PointList()
    
    var center:CGPoint = CGPoint(x: 256, y: 256) { didSet { needsComputeAffine = true } }
    var scale:CGFloat = 1.24 { didSet { needsComputeAffine = true } }
    var rotation:CGFloat = 0.33 { didSet { needsComputeAffine = true } }
    
    func setNeedsComputeShape() { needsComputeShape = true }
    internal var needsComputeShape:Bool = true
    func setNeedsComputeAffine() { needsComputeAffine = true }
    internal var needsComputeAffine:Bool = true
    
    internal var boundingBox:CGRect = CGRectZero
    
    var touchPoint:CGPoint = CGPointZero
    
    var enabled: Bool {
        return true
    }
    
    var selectable:Bool {
        return true
    }
    
    init() {
        spline.add(0.0, y: -100)
        spline.add(100, y: 0.0)
        spline.add(0.0, y: 100.0)
        
        //spline.add(-100.0, y: 0.0)
        
        
        spline.linear = false
        spline.closed = true
        
        computeShape()
    }
    
    func update() {
        
        demoPos += 0.06
        if demoPos > spline.maxPos {
            demoPos -= spline.maxPos
        }
        
    }
    
    func draw() {
        
        computeIfNeeded()
        
        gG.colorSet(r: 0.5, g: 0.8, b: 0.05)
        gG.rectDraw(x: Float(center.x - 6), y: Float(center.y - 6), width: 13, height: 13)
        
        
        
        gG.colorSet(r: 1.0, g: 0.0, b: 0.0)
        borderBase.drawEdges(closed: false)
        border.drawEdges(closed: true)
        
        gG.colorSet(r: 0.25, g: 0.88, b: 0.89)
        border.drawPoints()
        
        //gG.colorSet(r: 0.25, g: 0.15, b: 0.88, a: 0.22)
        //gG.rectDraw(border.getBoundingBox(padding: 5.0))
        
        
        gG.colorSet(r: 0.25, g: 1.0, b: 1.0, a: 1.0)
        
        let point = spline.get(demoPos)
        gG.rectDraw(x: Float(point.x - 3.0), y: Float(point.y - 3.0), width: 7.0, height: 7.0)
        
        
        for i in 0..<grid.count {
            for n in 0..<grid[i].count {
                
                gG.colorSet(color: grid[i][n].color)
                //gG.pointDraw(point: grid[i][n].pointBase, size: 4.0)
                gG.pointDraw(point: grid[i][n].point, size: 3.5)
            }
        }
        
        
        gG.colorSet(r: 1.0, g: 0.0, b: 0.5)
        for i in 0..<spline.controlPointCount {
            
            var controlPoint = spline.getControlPoint(i)
            
            controlPoint = transformPoint(point: controlPoint)
            
            gG.rectDraw(x: Float(controlPoint.x - 5), y: Float(controlPoint.y - 5), width: 11, height: 11)
        }
        
        
        gG.colorSet(color: UIColor.yellowColor())
        gG.pointDraw(point: touchPoint, size: 19.25)
        
        
    }
    
    func computeShape() {
        
        needsComputeShape = false
        valid = true
        
        computeBorder()
        
        guard borderBase.count > 4 else {
            valid = false
            return
        }
        
        boundingBox = borderBase.getBoundingBox(padding: 5.0)
        
        guard boundingBox.size.width > 10.0 && boundingBox.size.height > 10.0 else {
            valid = false
            return
        }
        
        computeGrid()
        
        
        computeAffine()
    }
    
    internal func computeBorder() {
        borderBase.reset()
        
        var threshDist = CGFloat(12.0)
        if gDevice.tablet { threshDist = 18 }
        
        threshDist = (threshDist * threshDist)
        
        let step = CGFloat(0.01)
        var prevPoint = spline.get(0.0)
        let lastPoint = spline.get(spline.maxPos)
        
        borderBase.add(x: prevPoint.x, y: prevPoint.y)
        for pos:CGFloat in step.stride(to: CGFloat(spline.maxPos), by: step) {
            let point = spline.get(pos)
            let diffX1 = point.x - prevPoint.x
            let diffY1 = point.y - prevPoint.y
            let diffX2 = point.x - lastPoint.x
            let diffY2 = point.y - lastPoint.y
            let dist1 = diffX1 * diffX1 + diffY1 * diffY1
            let dist2 = diffX2 * diffX2 + diffY2 * diffY2
            if dist1 > threshDist && dist2 > threshDist {
                borderBase.add(x: point.x, y: point.y)
                prevPoint = point
            }
        }
    }
    
    func computeGrid() {
        
        let minSize = min(boundingBox.size.width, boundingBox.size.height)
        let stepSize = minSize / 16.0
        //if stepSize >
        
        var countX = 0
        var countY = 0
        
        let leftX = boundingBox.origin.x
        let rightX = leftX + boundingBox.size.width
        for _ in leftX.stride(to: rightX, by: stepSize) {
            countX += 1
        }
        
        let topY = boundingBox.origin.y
        let bottomY = topY + boundingBox.size.height
        for _ in topY.stride(to: bottomY, by: stepSize) {
            countY += 1
        }
        
        grid = [[BlobGridNode]](count: countX, repeatedValue:[BlobGridNode](count: countY, repeatedValue: BlobGridNode()))
        
        for i in 0..<countX {
            
            let percentX = CGFloat(Double(i) / Double(countX - 1))
            let x = leftX + (rightX - leftX) * percentX
            
            for n in 0..<countY {
                
                let percentY = CGFloat(Double(n) / Double(countY - 1))
                let y = topY + (bottomY - topY) * percentY
                
                grid[i][n].pointBase = CGPoint(x: x, y: y)
                grid[i][n].color = UIColor(red: percentX, green: 0.5, blue: percentY, alpha: 1.0)
            }
        }
    }
    
    
    func computeAffine() {
        
        needsComputeAffine = false
        
        border.reset()
        border.add(list: borderBase)
        border.transform(scale: scale, rotation: rotation)
        border.transform(translation: center)
        
        
        
        for i in 0..<grid.count {
            
            for n in 0..<grid[i].count {
                
                grid[i][n].point = transformPoint(point: grid[i][n].pointBase)
                
                
                
                //gG.pointDraw(point: grid[i][n].pointBase, size: 4.0)
                
                //grid[i][n].pointBase = CGPoint(x: x, y: y)
                
                
                
            }
        }
        
        
        /*
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
        */
        
    }
    
    internal func computeIfNeeded() {
        if needsComputeShape { computeShape() }
        if needsComputeAffine { computeAffine() }
    }
    
    //class func
    
    func untransformPoint(point point:CGPoint) -> CGPoint {
        return BounceEngine.untransformPoint(point: point, translation: center, scale: scale, rotation: rotation)
    }
    
    func transformPoint(point point:CGPoint) -> CGPoint {
        
        //return BounceEngine.untransformPoint(point: point, translation: center, scale: scale, rotation: rotation)
        //return BounceEngine.transformPoint(point: CGPoint(x: point.x - center.x, y: point.y - center.y), scale: scale, rotation: rotation)
        
        return BounceEngine.transformPoint(point: point, translation: center, scale: scale, rotation: rotation)
    }
    
    /*
    void JigglePoint::Transform(float x, float y, float &pNewX, float &pNewY)
    {
    x -= mX;y -= mY;
    
    float aDiffX = -x;float aDiffY = -y;
    
    float aRot = FaceTarget(aDiffX, aDiffY);
    float aDist = aDiffX * aDiffX + aDiffY * aDiffY;
    
    if(aDist > 0.25f)
    {
    aDist = sqrtf(aDist);
    aDiffX /= aDist;aDiffY /= aDist;
    }
    else
    {
    aDiffX = 0;aDiffY = 0;
    }
    
    aRot -= mRotation;
    
    float aDirX = Sin(-aRot);
    float aDirY = Cos(-aRot);
    
    pNewX = aDirX * (aDist / mScale);
    pNewY = aDirY * (aDist / mScale);
    }
    
    void JigglePoint::Untransform(float x, float y, float &pNewX, float &pNewY, bool pSkipTranslate)
    {
    float aDiffX = x;float aDiffY = y;
    float aRot = FaceTarget(-aDiffX, -aDiffY);
    float aDist = aDiffX * aDiffX + aDiffY * aDiffY;
    
    if(aDist > 0.25f)
    {
    aDist = sqrtf(aDist);
    aDiffX /= aDist;aDiffY /= aDist;
    }
    else
    {
    aDiffX = 0;aDiffY = 0;
    }
    
    aRot += mRotation;
    
    float aDirX = Sin(-aRot);
    float aDirY = Cos(-aRot);
    
    pNewX = aDirX * (aDist * mScale);
    pNewY = aDirY * (aDist * mScale);
    
    if(pSkipTranslate == false)
    {
    pNewX += mX;
    pNewY += mY;
    }
    }
    */
    
    
}