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

class BounceViewController : GLViewController, UIGestureRecognizerDelegate {
    
    var landscape:Bool = false
    
    let background = Sprite()
    let backgroundTexture = Texture()
    
    var panRecognizer:UIPanGestureRecognizer!
    var pinchRecognizer:UIPinchGestureRecognizer!
    
    var panRecognizerTouchCount:Int = 0
    var pinchRecognizerTouchCount:Int = 0
    
    var gestureCancelTimer:Int = 0
    
    var gestureTouchCenter:CGPoint = CGPointZero
    
    //var screenTranslation:CGPoint = CGPointZero
    //var screenScale:CGFloat = 1.0
    
    var screenTranslation:CGPoint = CGPoint(x: 110.0, y: 200.0)
    var screenScale:CGFloat = 1.35
    
    
    var gestureStartTranslate:CGPoint = CGPointZero
    var gestureStartScale:CGFloat = 1.0
    
    var gestureStartScreenTouch:CGPoint = CGPointZero
    var gestureStartImageTouch:CGPoint = CGPointZero
    
    
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
        
        
//        sprite3.load(path: "aaaa")
//        sprite1.load(path: "rock")
//        sprite2.load(path: "reg_btn_paste_down@2x.png")
//        
//        
//        
//        tri1.p1 = (40, 120, 0)
//        tri1.t1 = (0.01, 0.02, 0.0)
//        //tri1.c1 = (0.99, 0.975, 0.15, 0.25)
//        
//        tri1.p2 = (100, 160, 0)
//        tri1.t2 = (0.99, 0.5, 0.0)
//        //tri1.c2 = (0.99, 0.175, 0.77, 1.0)
//        
//        tri1.p3 = (65.0, 180, 0)
//        tri1.t3 = (0.25, 1.0, 0.0)
//        //tri1.c3 = (0.45, 0.67, 0.55, 1.0)
//        
//        
//        
//        tri2.p1 = (100, 160, 0)
//        tri2.t1 = (0.0, 0.85, 0.0)
//        tri2.c1 = (0.99, 0.175, 0.77, 1.0)
//        
//        tri2.p2 = (65.0, 180, 0)
//        tri2.t2 = (0.55, 1.0, 0.0)
//        tri2.c2 = (0.45, 0.67, 0.55, 1.0)
//        
//        
//        tri2.p3 = (80.0, 240.0, 0)
//        tri2.t3 = (1.0, 0.25, 0.0)
//        tri2.c3 = (0.45, 0.67, 0.55, 1.0)
//        
//        
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ImageImportViewController.didPan(_:)))
        panRecognizer.delegate = self
        panRecognizer.maximumNumberOfTouches = 2
        view.addGestureRecognizer(panRecognizer)
        
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        pinchRecognizer.delegate = self
        view.addGestureRecognizer(pinchRecognizer)
    }
    
    override func update() {
        if gestureCancelTimer > 0 {
            gestureCancelTimer = gestureCancelTimer - 1
            if gestureCancelTimer <= 0 {
                panRecognizer.enabled = true
                pinchRecognizer.enabled = true
            }
        }
    }
    
    override func draw() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let screenMat = Matrix.createOrtho(left: 0.0, right: Float(width), bottom: Float(height), top: 0.0, nearZ: -2048, farZ: 2048)
        
        var viewMat = screenMat.clone()
        
        
        //viewMat = GLKMatrix4Multiply(viewMat, GLKMatrix4MakeTranslation(Float(screenTranslation.x), Float(screenTranslation.y), 0.0))
        
        
        //viewMat = GLKMatrix4Translate(viewMat, Float(screenTranslation.x), Float(screenTranslation.y), 0.0)
        //print("VM2 = \(viewMat.m)")
        //viewMat = GLKMatrix4Scale(viewMat, Float(screenScale), Float(screenScale), Float(screenScale))
        //print("VM3 = \(viewMat.m)")
        
        viewMat.translate(GLfloat(screenTranslation.x), GLfloat(screenTranslation.y), 0.0)
        viewMat.scale(Float(screenScale))
        
        
        gG.matrixProjectionSet(viewMat)
        
        
        
        //var m = GLKMatrix4MakeScale(0.85, 0.85, 0.85)
        //var m = Matrix()
        //gG.matrixModelViewSet(m)
        
        
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
        
        //background.drawCentered(pos: CGPoint(x: screenRect.midX, y: screenRect.midY))
        background.draw()
        
        //sprite2.drawCentered(pos: CGPoint(x: 0, y: 0))
        //sprite1.drawCentered(pos: CGPoint(x: 170.0, y: 320.0))
        //sprite1.drawCentered(pos: CGPoint(x: 50.0, y: 400.0))
        //sprite2.drawCentered(pos: CGPoint(x: 200, y: 200))
        //sprite2.drawCentered(pos: CGPoint(x: 100.0, y: 100))
        //sprite3.drawCentered(pos: CGPoint(x: 118.0, y: 240.0))
        
        gG.colorSet(r: 0.0, g: 1.0, b: 0.0)
        gG.rectDraw(CGRect(x: gestureStartScreenTouch.x - 4, y: gestureStartScreenTouch.y - 4, width: 9, height: 9))
        
        
        gG.matrixProjectionSet(screenMat)
        
        
        gG.colorSet(r: 1.0, g: 0.0, b: 0.0)
        gG.rectDraw(CGRect(x: gestureStartScreenTouch.x - 3, y: gestureStartScreenTouch.y - 3, width: 7, height: 7))
        
        //var gestureStartScreenTouch:CGPoint = CGPointZero
        //var gestureStartImageTouch:CGPoint = CGPointZero
        
        
        gG.lineDraw(p1:CGPoint(x: 100.0, y: 100.0), p2:CGPoint(x: 200.0, y: 500.0), thickness:8.0)
        
    }
    
    
    
    //var gestureStartScreenTouch:CGPoint = CGPointZero
    //var gestureStartImageTouch:CGPoint = CGPointZero
    
    func transformPointToImage(screenPoint screenPoint:CGPoint) -> CGPoint {
        
        
        return CGPoint(x: screenPoint.x * screenScale + screenTranslation.x, y: screenPoint.y * screenScale + screenTranslation.y)
    }
    
    func transformPointToScreen(imagePoint imagePoint:CGPoint) -> CGPoint {
        
        return CGPoint(x: (imagePoint.x - screenTranslation.x) / screenScale, y: (imagePoint.y - screenTranslation.y) / screenScale)
    }
    
    func gestureBegan(pos:CGPoint) {
        
        //var gestureStartScreenTouch:CGPoint = CGPointZero
        //var gestureStartImageTouch:CGPoint = CGPointZero
        
        gestureStartScreenTouch = pos
        gestureStartImageTouch =
            //transformPointToScreen(imagePoint: pos)
            transformPointToImage(screenPoint: pos)
        
        
        
        //startImageTouchCenter = imageView.convertPoint(pos, fromView: view)
        
        pinchRecognizer.scale = 1.0
        panRecognizer.setTranslation(CGPointZero, inView: view)
        
        
        gestureStartTranslate = CGPoint(x: screenTranslation.x, y: screenTranslation.y)
        gestureStartScale = screenScale
        
        //startScale = scale
        //startRotation = rotation
    }
    
    
    func updateTransform() {
        
        return
            
            /*
            
        screenTranslation.x = 0.0
        screenTranslation.y = 0.0
        
        let newImageTouchCenter = transformPointToImage(screenPoint: gestureTouchCenter)
        
        
        //transformPointToScreen(imagePoint: gestureTouchCenter)
        
        
        screenTranslation.x = (newImageTouchCenter.x - gestureStartImageTouch.x)
        screenTranslation.y = (newImageTouchCenter.y - gestureStartImageTouch.y)
        
        //t = CATransform3DTranslate(t, translation.x, translation.y, 0.0)
        
        //var new
        
        //var
        
        
        //gestureTouchCenter
        
        */
        /*
        var t = CATransform3DIdentity
        t = CATransform3DScale(t, scale, scale, scale)
        t = CATransform3DRotate(t, rotation, 0.0, 0.0, 1.0)
        imageView.layer.transform = t
        
        //Re-center the image at the center of our touch
        //within the object, based on initial touch within object.
        let newImageTouchCenter = imageView.convertPoint(touchCenter, fromView: view)
        translation.x = newImageTouchCenter.x - startImageTouchCenter.x
        translation.y = newImageTouchCenter.y - startImageTouchCenter.y
        t = CATransform3DTranslate(t, translation.x, translation.y, 0.0)
        
        imageView.layer.transform = t
        */
    }
    
    
    var allowGestures:Bool {
        if gestureCancelTimer > 0 {
            return false
        }
        return true
    }
    
    
    
    func didPanMainThread(gr:UIPanGestureRecognizer) -> Void {
        
        if allowGestures == false {
            cancelAllGestureRecognizers()
            return
        }
        
        gestureTouchCenter = gr.locationInView(self.view)
        switch gr.state {
        case .Began:
            gestureBegan(gestureTouchCenter)
            panRecognizerTouchCount = gr.numberOfTouches()
            break
        case .Changed:
            if panRecognizerTouchCount != gr.numberOfTouches() {
                if gr.numberOfTouches() > panRecognizerTouchCount {
                    panRecognizerTouchCount = gr.numberOfTouches()
                    gestureBegan(gestureTouchCenter)
                }
                else {
                    cancelAllGestureRecognizers()
                }
            }
            break
        default:
            cancelAllGestureRecognizers()
            break
        }
        
        //screenTranslation = CGPoint(x: gestureTouchCenter.x, y: gestureTouchCenter.y)
        
        
        //if allowTransform() {
            updateTransform()
        //}
    }
    
    
    
    func didPinchMainThread(gr:UIPinchGestureRecognizer) -> Void {
        
        
        if allowGestures == false {
            cancelAllGestureRecognizers()
            return
        }
        
        gestureTouchCenter = gr.locationInView(self.view)
        switch gr.state {
        case .Began:
            
                gestureBegan(gestureTouchCenter)
                gestureStartScale = screenScale
                pinchRecognizerTouchCount = gr.numberOfTouches()
            
            break
        case .Changed:
            
            if pinchRecognizerTouchCount != gr.numberOfTouches() {
                if gr.numberOfTouches() > pinchRecognizerTouchCount {
                    pinchRecognizerTouchCount = gr.numberOfTouches()
                    gestureBegan(gestureTouchCenter)
                }
                else {
                    cancelAllGestureRecognizers()
                }
            }
            break
        default:
            cancelAllGestureRecognizers()
            break
        }
        
        //if allowTransform() {
            screenScale = gestureStartScale * gr.scale
            updateTransform()
        //}
        
    }
    
    func cancelAllGestureRecognizers() {
        gestureCancelTimer = 5
        panRecognizer.enabled = false
        pinchRecognizer.enabled = false
    }
    
    func didPan(gr:UIPanGestureRecognizer) -> Void {
        self.performSelectorOnMainThread(#selector(ImageImportViewController.didPanMainThread(_:)), withObject: gr, waitUntilDone: true, modes: [NSRunLoopCommonModes])
    }
    
    func didPinch(gr:UIPinchGestureRecognizer) -> Void {
        self.performSelectorOnMainThread(#selector(didPinchMainThread(_:)), withObject: gr, waitUntilDone: true, modes: [NSRunLoopCommonModes])
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
    
}