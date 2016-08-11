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
    let sprite3 = Sprite()
    
    
    
    var buffer = DrawTriangleBuffer()
    
    var tri1 = DrawTriangle()
    var tri2 = DrawTriangle()
    var tri3 = DrawTriangle()
    
    
    override func load() {
        
        sprite3.load(path: "aaaa")
        sprite1.load(path: "checkbox_back_unchecked@2x.png")
        sprite2.load(path: "reg_btn_paste_down@2x.png")
        
        
        
        tri1.p1 = (40, 120, 0)
        tri1.t1 = (0.01, 0.02, 0.0)
        tri1.c1 = (0.99, 0.975, 0.15, 0.5)
        
        tri1.p2 = (250, 90, 0)
        tri1.t2 = (0.01, 0.02, 0.0)
        tri1.c2 = (0.99, 0.975, 0.15, 0.5)
        
        tri1.p3 = (140.0, 120, 0)
        tri1.t3 = (0.01, 0.02, 0.0)
        tri1.c3 = (0.99, 0.975, 0.15, 0.5)
        
        
        
        
        
        //x = 40.0
        //tri1.y = 120.0
        //tri1.u = 0.0
        //tri1.v = 0.0
        //tri1.w = 0.0
        
        
        
        
        buffer.add(triangle: tri1)
        buffer.add(triangle: tri2)
        buffer.add(triangle: tri3)
        
        
        
    }
    
    override func update() {
        
    }
    
    override func draw() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let p = GLKMatrix4MakeOrtho(0.0, Float(width), Float(height), 0.0, -2048, 2048)
        gG.matrixProjectionSet(p)
        
        
        //var m = GLKMatrix4MakeScale(0.85, 0.85, 0.85)
        var m = GLKMatrix4Identity
        
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
        
        gG.colorSet(r: 0.0, g: 1.0, b: 0.15, a: 1.0)
        gG.rectDraw(CGRect(x: 20, y: 10, width: 60, height: 340))
        
        gG.colorSet(r: 0.0, g: 0.0, b: 1.0, a: 1.0)
        gG.rectDraw(CGRect(x: 200, y: 200, width: 60, height: 60))
        
        
        gG.colorSet()
        
        //gG.rectDraw(x: 22.0, y: 220.0, width: 256.0, height: 256.0)
        
        gG.colorSet()
        
        
        
        //sprite2.drawCentered(pos: CGPoint(x: 0, y: 0))
        
        sprite1.drawCentered(pos: CGPoint(x: 1.0, y: 0.0))
        sprite1.drawCentered(pos: CGPoint(x: 100.0, y: 0.0))
        
        sprite2.drawCentered(pos: CGPoint(x: 200, y: 200))
        sprite2.drawCentered(pos: CGPoint(x: 100.0, y: 100))
        
        sprite3.drawCentered(pos: CGPoint(x: 118.0, y: 240.0))
        
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
    
}