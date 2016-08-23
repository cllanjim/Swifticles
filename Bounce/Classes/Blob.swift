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
    
    
    var center:CGPoint = CGPoint(x: 256, y: 256)
    
    init() {
        spline.add(100, y: 100)
        spline.add(200, y: 100)
        spline.add(130, y: 160)
        
    }
    
    var enabled: Bool {
        
        return true
    }
    
    func update() {
        
    }
    
    func draw() {
        gG.colorSet(r: 0.5, g: 0.8, b: 0.05)
        gG.rectDraw(x: Float(center.x - 6), y: Float(center.y - 6), width: 13, height: 13)
        
        
        
        
        gG.colorSet(r: 1.0, g: 0.0, b: 0.5)
        for i in 0..<spline.controlPointCount {
            
            let controlPoint = spline.getControlPoint(i)
            gG.rectDraw(x: Float(controlPoint.x - 5), y: Float(controlPoint.y - 5), width: 11, height: 11)
            
        }
        
        gG.colorSet()
        
    }
    
    
    
}