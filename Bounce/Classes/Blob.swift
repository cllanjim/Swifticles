//
//  Blob.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/22/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import OpenGLES

class Blob
{
    
    var spline = CubicSpline()
    
    var demoPos:CGFloat = 0.0
    
    var center:CGPoint = CGPoint(x: 256, y: 256)
    
    init() {
        spline.add(100, y: 100)
        spline.add(200, y: 100)
        spline.add(130, y: 160)
        
        spline.add(157, y: 90)
        
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
    
    
    
}