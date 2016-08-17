//
//  BounceViewController.swift
//  Bounce
//
//  Created by Nicholas Raptis on 8/7/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES

class BounceViewController : GLViewController {
    
    var landscape:Bool = false
    
    let sprite1 = Sprite()
    let sprite2 = Sprite()
    let sprite3 = Sprite()
    
    let background = Sprite()
    let backgroundTexture = Texture()
    
    
    var buffer = DrawTriangleBuffer()
    
    var tri1 = DrawTriangle()
    var tri2 = DrawTriangle()
    var tri3 = DrawTriangle()
    
    var screenRect:CGRect {
        if landscape {
            return CGRect(x: 0.0, y: 0.0, width: gDevice.landscapeWidth, height: gDevice.landscapeHeight)
        } else {
            return CGRect(x: 0.0, y: 0.0, width: gDevice.portraitWidth, height: gDevice.portraitHeight)
        }
    }
    
    func setUp(image image:UIImage, portraitOrientation:Bool) {
        
        print("BounceViewController.setUp(portraitOrientation:[\(portraitOrientation)])")
        
        landscape = !portraitOrientation
        
        backgroundTexture.load(image: image)
        background.load(texture: backgroundTexture)
        
        background.startX = 0.0
        background.startY = 0.0
        background.endX = screenRect.size.width
        background.endY = screenRect.size.height
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        if landscape {
            return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        } else {
            return [.LandscapeRight, .LandscapeLeft]
        }
        
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        if landscape {
            return UIInterfaceOrientation.LandscapeLeft
        } else {
            return UIInterfaceOrientation.Portrait
        }
    }
    
    override func load() {
        
        print("BounceViewController.load()")
        
        
        sprite3.load(path: "aaaa")
        sprite1.load(path: "rock")
        sprite2.load(path: "reg_btn_paste_down@2x.png")
        
        
        
        tri1.p1 = (40, 120, 0)
        tri1.t1 = (0.01, 0.02, 0.0)
        //tri1.c1 = (0.99, 0.975, 0.15, 0.25)
        
        tri1.p2 = (100, 160, 0)
        tri1.t2 = (0.99, 0.5, 0.0)
        //tri1.c2 = (0.99, 0.175, 0.77, 1.0)
        
        tri1.p3 = (65.0, 180, 0)
        tri1.t3 = (0.25, 1.0, 0.0)
        //tri1.c3 = (0.45, 0.67, 0.55, 1.0)
        
        
        
        tri2.p1 = (100, 160, 0)
        tri2.t1 = (0.0, 0.85, 0.0)
        tri2.c1 = (0.99, 0.175, 0.77, 1.0)
        
        tri2.p2 = (65.0, 180, 0)
        tri2.t2 = (0.55, 1.0, 0.0)
        tri2.c2 = (0.45, 0.67, 0.55, 1.0)
        
        
        tri2.p3 = (80.0, 240.0, 0)
        tri2.t3 = (1.0, 0.25, 0.0)
        tri2.c3 = (0.45, 0.67, 0.55, 1.0)
    }
    
    override func update() {
        
    }
    
    override func draw() {
        
        
            
        tri1.x1 += 0.5
        if tri1.x1 >= 120.0 {
            tri1.x1 = 20.0
        }
        
        
        
        
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
        
        /*
        gG.colorSet(r: 1.0, g: 0.25, b: 0.15, a: 1.0)
        gG.rectDraw(CGRect(x: 10, y: 10, width: 300, height: 300))
        
        gG.colorSet(r: 0.0, g: 1.0, b: 0.15, a: 1.0)
        gG.rectDraw(CGRect(x: 20, y: 10, width: 60, height: 340))
        
        gG.colorSet(r: 0.0, g: 0.0, b: 1.0, a: 1.0)
        gG.rectDraw(CGRect(x: 200, y: 200, width: 60, height: 60))
        
        
        gG.colorSet()
        gG.rectDraw(x: 22.0, y: 220.0, width: 336.0, height: 336.0)
        */
        
        gG.colorSet(r: 1.0, g: 1.0, b: 1.0, a: 1.0)
        gG.textureEnable()
        
        //sprite1.bind()
        
        
        for i in 0..<1000 {
            
        
        buffer.reset()
        //buffer.add(triangle: tri1)
        
        
        buffer.set(index: 2, triangle: tri2)
        buffer.set(index: 1, triangle: tri1)
        //buffer.add(triangle: tri1)
        
        
        //buffer.add(triangle: tri2)
        //buffer.add(triangle: tri3)
        buffer.draw(texture: gG.textureBlank())
        
            }
        
        
        //background.drawCentered(pos: CGPoint(x: screenRect.midX, y: screenRect.midY))
        background.draw()
        
        sprite2.drawCentered(pos: CGPoint(x: 0, y: 0))
        
        sprite1.drawCentered(pos: CGPoint(x: 170.0, y: 320.0))
        sprite1.drawCentered(pos: CGPoint(x: 50.0, y: 400.0))
        
        sprite2.drawCentered(pos: CGPoint(x: 200, y: 200))
        sprite2.drawCentered(pos: CGPoint(x: 100.0, y: 100))
        
        sprite3.drawCentered(pos: CGPoint(x: 118.0, y: 240.0))
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
    
}