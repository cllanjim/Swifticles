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
    
    let engine = BounceEngine()
    
    var landscape:Bool = false
    
    var panRecognizer:UIPanGestureRecognizer!
    var pinchRecognizer:UIPinchGestureRecognizer!
    
    var panRecognizerTouchCount:Int = 0
    var pinchRecognizerTouchCount:Int = 0
    
    var zoomGestureCancelTimer:Int = 0
    
    var gestureTouchCenter:CGPoint = CGPointZero
    
    var screenTranslation:CGPoint = CGPointZero
    var screenScale:CGFloat = 1.0
    
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
    
    func setUp(image image:UIImage, sceneRect:CGRect, portraitOrientation:Bool) {
        
        print("BounceViewController.setUp(portraitOrientation:[\(portraitOrientation)])")
        
        landscape = !portraitOrientation
        
        engine.setUp(image: image, sceneRect:sceneRect, screenRect:screenRect)
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleZoomModeChange), name: String(BounceNotification.ZoomModeChanged), object: nil)
        //NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: String(BounceNotification.ZoomModeChanged), object: self))
        
    }
    
    func handleZoomModeChange() {
        print("handleZoomModeChange")
        engine.cancelAllTouches()
        cancelAllGestureRecognizers()
        engine.cancelAllGestures()
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
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ImageImportViewController.didPan(_:)))
        panRecognizer.delegate = self
        panRecognizer.maximumNumberOfTouches = 2
        panRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(panRecognizer)
        
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        pinchRecognizer.delegate = self
        pinchRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(pinchRecognizer)
    }
    
    override func update() {
        if zoomGestureCancelTimer > 0 {
            zoomGestureCancelTimer = zoomGestureCancelTimer - 1
            if zoomGestureCancelTimer <= 0 {
                panRecognizer.enabled = true
                pinchRecognizer.enabled = true
            }
        }
        
        engine.update()
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
        engine.draw()
        
        
        gG.matrixProjectionSet(screenMat)
        
    }
    
    func transformPointToImage(point:CGPoint) -> CGPoint {
        return CGPoint(x: (point.x - screenTranslation.x) / screenScale, y: (point.y - screenTranslation.y) / screenScale)
    }
    
    func transformPointToScreen(point:CGPoint) -> CGPoint {
        return CGPoint(x: point.x * screenScale + screenTranslation.x, y: point.y * screenScale + screenTranslation.y)
    }
    
    //MARK: Gesture stuff, pan, pinch, etc
    private var _allowZoomGestures:Bool {
        if zoomGestureCancelTimer > 0 {
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
        
        gestureTouchCenter = gr.locationInView(self.view)
        
        if engine.zoomMode {
            if _allowZoomGestures == false {
                cancelAllGestureRecognizers()
                return
            }
            
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
            if _allowZoomGestures {
                updateTransform()
            }
        } else {
            switch gr.state {
            case .Began:
                panRecognizerTouchCount = gr.numberOfTouches()
                break
            case .Changed:
                if panRecognizerTouchCount != gr.numberOfTouches() {
                    if gr.numberOfTouches() > panRecognizerTouchCount {
                        panRecognizerTouchCount = gr.numberOfTouches()
                        
                    }
                    else {
                        engine.cancelAllGestures()
                    }
                }
                break
            default:
                engine.cancelAllGestures()
                break
            }
        }
    }
    
    func didPinchMainThread(gr:UIPinchGestureRecognizer) -> Void {
        
        gestureTouchCenter = gr.locationInView(self.view)
        
        if engine.zoomMode {
            if _allowZoomGestures == false {
                cancelAllGestureRecognizers()
                return
            }
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
            if _allowZoomGestures {
                screenScale = gestureStartScale * gr.scale
                updateTransform()
            }
        } else {
            
            switch gr.state {
            case .Began:
                pinchRecognizerTouchCount = gr.numberOfTouches()
                
                break
            case .Changed:
                if pinchRecognizerTouchCount != gr.numberOfTouches() {
                    if gr.numberOfTouches() > pinchRecognizerTouchCount {
                        pinchRecognizerTouchCount = gr.numberOfTouches()
                        
                    }
                    else {
                        engine.cancelAllGestures()
                        break
                    }
                }
                break
            default:
                engine.cancelAllGestures()
                break
            }
        }
    }
    
    func cancelAllGestureRecognizers() {
        zoomGestureCancelTimer = 5
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if engine.zoomMode == false {
            for var touch:UITouch in touches {
                if touch.phase == .Began {
                    let location = touch.locationInView(view)
                    engine.touchDown(&touch, point: transformPointToImage(location))
                }
            }
        } else {
            engine.cancelAllTouches()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if engine.zoomMode == false {
            for var touch:UITouch in touches {
                if touch.phase == .Moved {
                    let location = touch.locationInView(view)
                    engine.touchMove(&touch, point: transformPointToImage(location))
                }
            }
        } else {
            engine.cancelAllTouches()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if engine.zoomMode == false {
            for var touch:UITouch in touches {
                if touch.phase == .Ended || touch.phase == .Cancelled {
                    let location = touch.locationInView(view)
                    engine.touchMove(&touch, point: transformPointToImage(location))
                }
            }
        } else {
            engine.cancelAllTouches()
        }
    }
    
    deinit {
        print("Deinit \(self)")
    }
}










