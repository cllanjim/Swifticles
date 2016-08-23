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
    
    
    //
    
    var zoomMode:Bool = false
    
    //
    
    
    
    var blobs = [Blob]()
    
    var selectedBlob:Blob?
    
    var landscape:Bool = false
    
    let background = Sprite()
    let backgroundTexture = Texture()
    
    var panRecognizer:UIPanGestureRecognizer!
    var pinchRecognizer:UIPinchGestureRecognizer!
    
    var panRecognizerTouchCount:Int = 0
    var pinchRecognizerTouchCount:Int = 0
    
    var gestureCancelTimer:Int = 0
    
    var gestureTouchCenter:CGPoint = CGPointZero
    
    var screenTranslation:CGPoint = CGPointZero
    var screenScale:CGFloat = 1.0
    
    var gestureStartTranslate:CGPoint = CGPointZero
    var gestureStartScale:CGFloat = 1.0
    
    var gestureStartScreenTouch:CGPoint = CGPointZero
    var gestureStartImageTouch:CGPoint = CGPointZero
    
    
    var activeRect:CGRect = CGRectZero {
        didSet {
            background.startX = activeRect.origin.x
            background.startY = activeRect.origin.y
            background.endX = activeRect.size.width
            background.endY = activeRect.size.height
        }
    }
    
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
        
        
        activeRect = CGRect(x: 50, y: 50, width: screenRect.size.width * 0.75, height: screenRect.size.width * 0.75)
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        if landscape {
            return [.LandscapeRight, .LandscapeLeft]
        } else {
            return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
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
        
        for blob:Blob in blobs {
            if blob.enabled { blob.update() }
        }
        
    }
    
    override func draw() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let screenMat = Matrix.createOrtho(left: 0.0, right: Float(width), bottom: Float(height), top: 0.0, nearZ: -2048, farZ: 2048)
        
        gG.matrixProjectionSet(screenMat)
        gG.colorSet(r: 0.25, g: 0.15, b: 0.33)
        gG.rectDraw(x: 0.0, y: 0.0, width: Float(screenRect.size.width), height: Float(screenRect.size.height))
        
        
        let viewMat = screenMat.clone()
        viewMat.translate(GLfloat(screenTranslation.x), GLfloat(screenTranslation.y), 0.0)
        viewMat.scale(Float(screenScale))
        gG.matrixProjectionSet(viewMat)
        
        //var m = Matrix()
        //gG.matrixModelViewSet(m)
        
        gG.blendEnable()
        gG.blendSetAlpha()
        
        gG.colorSet(r: 1.0, g: 1.0, b: 1.0, a: 1.0)
        gG.textureEnable()
        
        //background.drawCentered(pos: CGPoint(x: screenRect.midX, y: screenRect.midY))
        background.draw()
        
        gG.colorSet(r: 1.0, g: 0.25, b: 1.0, a: 0.25)
        gG.rectDraw(x: Float(activeRect.origin.x - 10), y: Float(activeRect.origin.y - 10), width: Float(activeRect.size.width + 20), height: Float(activeRect.size.height + 20))
        
        for blob:Blob in blobs {
            if blob.enabled { blob.draw() }
        }
        
        
        gG.matrixProjectionSet(screenMat)
        
    }
    
    
    
    func addBlob() {
        
        let blob = Blob()
        blobs.append(blob)
        selectedBlob = blob
        
        blob.center.x = activeRect.origin.x + 50
        blob.center.y = activeRect.origin.y + activeRect.size.height / 2.0
        
        
        //blob
        
        //selectedBlob
        
        
        
    }
    
    func transformPointToImage(point:CGPoint) -> CGPoint {
        return CGPoint(x: (point.x - screenTranslation.x) / screenScale, y: (point.y - screenTranslation.y) / screenScale)
    }
    
    func transformPointToScreen(point:CGPoint) -> CGPoint {
        return CGPoint(x: point.x * screenScale + screenTranslation.x, y: point.y * screenScale + screenTranslation.y)
    }
    
    //MARK: Gesture stuff, pan, pinch, etc
    
    private var _allowGestures:Bool {
        if gestureCancelTimer > 0 {
            return false
        }
        return true
    }
    
    func updateTransform() {
        screenTranslation = CGPointZero
        let gestureStart = transformPointToScreen(gestureStartImageTouch)
        screenTranslation.x = (gestureTouchCenter.x - gestureStart.x)
        screenTranslation.y = (gestureTouchCenter.y - gestureStart.y)
    }
    
    func gestureBegan(pos:CGPoint) {
        gestureStartScreenTouch = pos
        gestureStartImageTouch = transformPointToImage(pos)
        
        pinchRecognizer.scale = 1.0
        panRecognizer.setTranslation(CGPointZero, inView: view)
        
        gestureStartTranslate = CGPoint(x: screenTranslation.x, y: screenTranslation.y)
        gestureStartScale = screenScale
    }
    
    func didPanMainThread(gr:UIPanGestureRecognizer) -> Void {
        if _allowGestures == false {
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
        if _allowGestures {
            updateTransform()
        }
    }
    
    func didPinchMainThread(gr:UIPinchGestureRecognizer) -> Void {
        if _allowGestures == false {
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
        if _allowGestures {
            screenScale = gestureStartScale * gr.scale
            updateTransform()
        }
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










