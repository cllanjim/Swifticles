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
    
    var center:CGPoint = CGPoint(x: 256, y: 256)
    
    
    var enabled: Bool {
        
        return true
    }
    
    func update() {
        
    }
    
    func draw() {
        gG.colorSet(r: 0.5, g: 0.8, b: 0.05)
        gG.rectDraw(x: Float(center.x - 6), y: Float(center.y - 6), width: 13, height: 13)
    }
    
    
    
}