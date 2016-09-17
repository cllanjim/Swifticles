//
//  ImageImportViewController.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/22/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ImageImportViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var imageView:UIImageView!
    
    var updateTimer:NSTimer?
    
    
    func allowTransform() -> Bool {
        if cancelTimer > 0 {
            return false
        }
        return true
    }
    
    func cancelAll() {
        //Set the timer before .enabled = false, otherwise .enabled will generate calls..
        cancelTimer = 5
        
        panRecognizer.enabled = false
        pinchRecognizer.enabled = false
        rotRecognizer.enabled = false
    }
    
    
    var panRecognizer:UIPanGestureRecognizer!;//(target: self, action: #selector(ImageImportViewController.didPan(_:)))
    var pinchRecognizer:UIPinchGestureRecognizer!;//(target: self, action: #selector(didPinch(_:)))
    var rotRecognizer:UIRotationGestureRecognizer!;//(target: self, action: #selector(ImageImportViewController.didRotate(_:)))
    
    var panRecognizerTouchCount:Int = 0
    var pinchRecognizerTouchCount:Int = 0
    var rotRecognizerTouchCount:Int = 0
    
    
    var cancelTimer:Int = 0
    
    var starTouchCenter:CGPoint = CGPointZero
    var startImageTouchCenter:CGPoint = CGPointZero
    var startRotation:CGFloat = 0.0
    var startScale:CGFloat = 1.0
    
    var touchCenter = CGPointZero
    
    
    var translation:CGPoint = CGPointZero
    var rotation:CGFloat = 0.0
    var scale:CGFloat = 1.0
    
    var pivot:Bool = false
    
    
    func updateTransform() {
        var t = CGAffineTransformIdentity
        t = CGAffineTransformScale(t, scale, scale)
        t = CGAffineTransformRotate(t, rotation)
        imageView.transform = t
        
        //Re-center the image at the center of our touch
        //within the object, based on initial touch within object.
        let newImageTouchCenter = imageView.convertPoint(touchCenter, fromView: view)
        translation.x = newImageTouchCenter.x - startImageTouchCenter.x
        translation.y = newImageTouchCenter.y - startImageTouchCenter.y
        t = CGAffineTransformTranslate(t, translation.x, translation.y)
        imageView.transform = t
    }
    
    func gestureBegan(pos:CGPoint) {
        starTouchCenter = pos
        startImageTouchCenter = imageView.convertPoint(pos, fromView: view)
        pinchRecognizer.scale = 1.0
        rotRecognizer.rotation = 0.0
        panRecognizer.setTranslation(CGPointZero, inView: view)
        startScale = scale
        startRotation = rotation
    }
    
    func didPan(gr:UIPanGestureRecognizer) -> Void {
        self.performSelectorOnMainThread(#selector(ImageImportViewController.didPanMainThread(_:)), withObject: gr, waitUntilDone: true, modes: [NSRunLoopCommonModes])
    }
    
    func didPanMainThread(gr:UIPanGestureRecognizer) -> Void {
        touchCenter = gr.locationInView(self.view)
        switch gr.state {
        case .Began:
            gestureBegan(touchCenter)
            panRecognizerTouchCount = gr.numberOfTouches()
            break
        case .Changed:
            if panRecognizerTouchCount != gr.numberOfTouches() {
                if gr.numberOfTouches() > panRecognizerTouchCount {
                    panRecognizerTouchCount = gr.numberOfTouches()
                    gestureBegan(touchCenter)
                }
                else {
                    cancelAll()
                }
            }
            break
        default:
            cancelAll()
            break
        }
        if allowTransform() {
            updateTransform()
        }
    }
    
    
    
    func didPinch(gr:UIPinchGestureRecognizer) -> Void {
        self.performSelectorOnMainThread(#selector(didPinchMainThread(_:)), withObject: gr, waitUntilDone: true, modes: [NSRunLoopCommonModes])
    }
    
    func didPinchMainThread(gr:UIPinchGestureRecognizer) -> Void {
        touchCenter = gr.locationInView(self.view)
        switch gr.state {
        case .Began:
            if allowTransform() {
                gestureBegan(touchCenter)
                startScale = scale
                pinchRecognizerTouchCount = gr.numberOfTouches()
            }
            break
        case .Changed:

            if pinchRecognizerTouchCount != gr.numberOfTouches() {
                if gr.numberOfTouches() > pinchRecognizerTouchCount {
                    pinchRecognizerTouchCount = gr.numberOfTouches()
                    gestureBegan(touchCenter)
                }
                else {
                    cancelAll()
                }
            }
            break
        default:
            cancelAll()
            break
        }
        if allowTransform() {
            scale = startScale * gr.scale
            updateTransform()
        }
    }
    
    
    func didRotate(gr:UIRotationGestureRecognizer) -> Void {
        self.performSelectorOnMainThread(#selector(didRotateMainThread(_:)), withObject: gr, waitUntilDone: true, modes: [NSRunLoopCommonModes])
    }
    func didRotateMainThread(gr:UIRotationGestureRecognizer) -> Void {
        touchCenter = gr.locationInView(self.view)
        switch gr.state {
        case .Began:
            if allowTransform() {
                gestureBegan(touchCenter)
                startRotation = rotation
                rotRecognizerTouchCount = gr.numberOfTouches()
            }
            break
        case .Changed:
            if rotRecognizerTouchCount != gr.numberOfTouches() {
                if gr.numberOfTouches() > rotRecognizerTouchCount {
                    rotRecognizerTouchCount = gr.numberOfTouches()
                    gestureBegan(touchCenter)
                }
                else {
                    cancelAll()
                }
            }
            break
        default:
            cancelAll()
            break
        }
        
        
        if allowTransform() {
            rotation = startRotation + gr.rotation
            updateTransform()
        }
    }
    
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func constrainImageToImportSize(image:UIImage, screenSize:CGSize) -> UIImage {
        
        return image
    }
    
    func setUp(image:UIImage?, screenSize:CGSize) {
        
        print("SetUp Img[\(image?.size.width)x\(image?.size.height)] Size[\(screenSize.width)x\(screenSize.height)]")
        
        if image != nil && screenSize.width > 64 && screenSize.height > 64 {
            
            let importImage:UIImage = constrainImageToImportSize(image!, screenSize: screenSize)
            imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: importImage.size.width, height: importImage.size.height))
            
            imageView.image = importImage
            //imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.addSubview(imageView)
            
            
            
            panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ImageImportViewController.didPan(_:)))
            panRecognizer.delegate = self
            panRecognizer.maximumNumberOfTouches = 2
            //panRecognizer.delaysTouchesEnded = false
            self.view.addGestureRecognizer(panRecognizer)
            
            pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
            pinchRecognizer.delegate = self
            self.view.addGestureRecognizer(pinchRecognizer)
            
            rotRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(ImageImportViewController.didRotate(_:)))
            rotRecognizer.delegate = self
            
            self.view.addGestureRecognizer(rotRecognizer)
            
            updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0/60.0, target: self, selector: #selector(ImageImportViewController.update), userInfo: nil, repeats: true)
            
        }
    }
    
    func update() {
        if cancelTimer > 0 {
            cancelTimer = cancelTimer - 1
            if cancelTimer <= 0 {
                panRecognizer.enabled = true
                pinchRecognizer.enabled = true
                rotRecognizer.enabled = true
            }
        }
    }
    
}

















