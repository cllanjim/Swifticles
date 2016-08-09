//
//  BounceViewController.swift
//  Bounce
//
//  Created by Nicholas Raptis on 8/7/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import GLKit
import OpenGLES

class BounceViewController : GLViewController {
    
    
    
    let sprite1 = Sprite()
    let sprite2 = Sprite()
    
    
    override func load() {
        
        sprite1.load(path: "checkbox_back_unchecked@2x.png")
        sprite2.load(path: "reg_btn_paste_down@2x.png")
        
    }
    
    override func update() {
        
    }
    
    override func draw() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let p = GLKMatrix4MakeOrtho(0.0, Float(width), Float(height), 0.0, -2048, 2048)
        gG.matrixProjectionSet(p)
        
        
        var m = GLKMatrix4MakeScale(0.85, 0.85, 0.85)
        
        //GLKMatrix4Identity
        
        //print("m1 = \(m.m)")
        
        
        //m = GLKMatrix4Scale(m, 0.85, 0.85, 0.85)
        
        //print("m2 = \(m.array)")
        
        
        //m = GLKMatrix4Rotate(m, 0.1, 0.7, 0.1, 0.25)
        
        gG.matrixModelViewSet(m)
        
        
        
        gG.blendEnable()
        gG.blendSetAlpha()
        
        gG.colorSet(r: 1.0, g: 0.25, b: 0.15, a: 1.0)
        gG.rectDraw(CGRect(x: 10, y: 10, width: 300, height: 300))
        
        gG.colorSet(a: 0.8)
        
        gG.rectDraw(x: 22.0, y: 220.0, width: 256.0, height: 256.0)
        
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
    
}