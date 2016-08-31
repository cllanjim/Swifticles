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
    
}

public class Blob
{
    var node = [[BlobGridNode]]()
    
    weak var touch:UITouch?
    
    var spline = CubicSpline()
    
    var demoPos:CGFloat = 0.0
    
    //Base = untransformed, no Base = transformed...
    var borderBase = PointList()
    var border = PointList()
    
    var center:CGPoint = CGPoint(x: 256, y: 256) { didSet { needsComputeAffine = true } }
    var scale:CGFloat = 1.0 { didSet { needsComputeAffine = true } }
    var rotation:CGFloat = 0.0 { didSet { needsComputeAffine = true } }
    
    internal var needsComputeShape:Bool = true
    internal var needsComputeAffine:Bool = true
    
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
        
        
        
        
        gG.colorSet(r: 1.0, g: 0.0, b: 0.5)
        for i in 0..<spline.controlPointCount {
            
            let controlPoint = spline.getControlPoint(i)
            gG.rectDraw(x: Float(controlPoint.x - 2), y: Float(controlPoint.y - 2), width: 5, height: 5)
            
        }
        
        gG.colorSet(r: 0.25, g: 1.0, b: 1.0)
        var pos = CGFloat(0.0)
        while pos <= (spline.maxPos) {
            let point = spline.get(pos)
            gG.rectDraw(x: Float(point.x - 0.5), y: Float(point.y - 0.5), width: 1, height: 1)
            pos += 0.1
        }
        
        gG.colorSet(r: 1.0, g: 0.0, b: 0.0)
        borderBase.drawEdges(closed: false)
        border.drawEdges(closed: true)
        
        gG.colorSet(r: 0.25, g: 0.88, b: 0.89)
        border.drawPoints()
        
        gG.colorSet(r: 0.25, g: 1.0, b: 1.0, a: 1.0)
        
        let point = spline.get(demoPos)
        gG.rectDraw(x: Float(point.x - 3.0), y: Float(point.y - 3.0), width: 7.0, height: 7.0)
        
    }
    
    func computeShape() {
        
        needsComputeShape = false
        
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
        
        
        
        computeAffine()
    }
    
    func computeAffine() {
        
        needsComputeAffine = false
        
        border.reset()
        border.add(list: borderBase)
        
        border.transform(scale: scale, rotation: rotation)
        border.transform(translation: center)
        
        
        //border.add(x: <#T##CGFloat#>, y: <#T##CGFloat#>)
        
        //borderBase
        
    }
    
    internal func computeIfNeeded() {
        if needsComputeShape { computeShape() }
        if needsComputeAffine { computeAffine() }
    }
    
    func transformPointTo(point point:CGPoint) -> CGPoint {
        return CGPoint(x: (point.x - center.x) / scale, y: (point.y - center.y) / scale)
    }
    
    func transformPointFrom(point point:CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scale + center.x, y: point.y * scale + center.y)
    }
    
    
    
}