//
//  Blob.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/22/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import OpenGLES

public class Blob
{
    
    weak var touch:UITouch?
    
    var spline = CubicSpline()
    
    var demoPos:CGFloat = 0.0
    
    //Base = untransformed, no Base = transformed...
    var borderBase = PointList()
    var border = PointList()
    
    var center:CGPoint = CGPoint(x: 256, y: 256)
    var scale:CGFloat = 1.0
    var rotation:CGFloat = 0.0
    
    var selectable:Bool {
        return true
    }
    
    init() {
        spline.add(0.0, y: -100)
        spline.add(100, y: 0.0)
        spline.add(0.0, y: 100.0)
        spline.add(-100.0, y: 0.0)
        
        spline.linear = false
        spline.closed = true
        
        
    }
    
    var enabled: Bool {
        
        return true
    }
    
    func update() {
        
        demoPos += 0.06
        if demoPos > spline.maxPos {
            demoPos -= spline.maxPos
        }
        
    }
    
    func draw() {
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
            pos += 0.01
            
            
            
        }
        
        gG.colorSet(r: 0.25, g: 1.0, b: 1.0, a: 1.0)
        
        let point = spline.get(demoPos)
        gG.rectDraw(x: Float(point.x - 3.0), y: Float(point.y - 3.0), width: 7.0, height: 7.0)
        
    }
    
    func computeShape() {
        
        borderBase.reset()
        
        var threshDist = 12.0
        if gDevice.tablet { threshDist = 18 }
        
        threshDist = (threshDist * threshDist)
        
        var step = CGFloat(0.01)
        var prevPoint = spline.get(0.0)
        var lastPoint = spline.get(spline.maxPos)
        
        for pos:CGFloat in step.stride(to: CGFloat(spline.maxPos), by: step) {
            
            //let point =
            
        }
        
        
        
        computeAffine()
    }
    
    func computeAffine() {
        
        //borderBase
        
        
    }
    
    func transformPointTo(point point:CGPoint) -> CGPoint {
        return CGPoint(x: (point.x - center.x) / scale, y: (point.y - center.y) / scale)
    }
    
    func transformPointFrom(point point:CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scale + center.x, y: point.y * scale + center.y)
    }
    
    
    
}