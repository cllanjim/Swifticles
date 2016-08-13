//
//  ImageImportViewController.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/22/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ImageImportViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBarBottom: UIToolbar!
    
    deinit {
        print("ImageImportViewController.deinit()")
    }
    
    
    var imageView:UIImageView!
    var updateTimer:NSTimer?
    
    var cropView = UIView(frame: CGRectZero)
    var cropViewOutsideU = UIView(frame: CGRectZero)
    var cropViewOutsideR = UIView(frame: CGRectZero)
    var cropViewOutsideD = UIView(frame: CGRectZero)
    var cropViewOutsideL = UIView(frame: CGRectZero)
    
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        let imageCenter = imageView.convertPoint(cropView.center, fromView: view)
        var imageTransform = imageView.transform
        
        coordinator.animateAlongsideTransition({ [weak weakSelf = self] (id:UIViewControllerTransitionCoordinatorContext) in
            if let checkSelf = weakSelf {
                checkSelf.cropView.frame = checkSelf.getCropRect(size)
                checkSelf.placeCropOutside()
                
                let newImageCenter = checkSelf.imageView.convertPoint(checkSelf.cropView.center, fromView: checkSelf.view)
                checkSelf.translation.x = newImageCenter.x - imageCenter.x
                checkSelf.translation.y = newImageCenter.y - imageCenter.y
                imageTransform = CGAffineTransformTranslate(imageTransform, checkSelf.translation.x, checkSelf.translation.y)
                checkSelf.imageView.transform = imageTransform
            }
        }, completion: nil)
    }
    
    
    func allowTransform() -> Bool {
        if cancelTimer > 0 {
            return false
        }
        return true
    }
    
    func cancelAll() {
        cancelTimer = 5
        panRecognizer.enabled = false
        pinchRecognizer.enabled = false
        rotRecognizer.enabled = false
    }
    
    
    var panRecognizer:UIPanGestureRecognizer!;
    var pinchRecognizer:UIPinchGestureRecognizer!;
    var rotRecognizer:UIRotationGestureRecognizer!;
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateTimer?.invalidate()
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0/60.0, target: self, selector: #selector(ImageImportViewController.update), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
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
    
    func constrainImageToImportSize(importImage importImage:UIImage, screenSize:CGSize) -> UIImage? {
        
        let importScale = gDevice.importScale
        
        //let importMaxWidth = Double(gDevice.portraitWidth) * Double(importScale)
        //let importMaxHeight = Double(gDevice.portraitHeight) * Double(importScale)
        
        let importMaxWidth = Double(screenSize.width) * Double(importScale)
        let importMaxHeight = Double(screenSize.height) * Double(importScale)
        
        let widthRatio = importMaxWidth / Double(importImage.size.width)
        let heightRatio = importMaxHeight / Double(importImage.size.height)
        
        let ratio = max(widthRatio, heightRatio)
        
        print("Import MaxSize[\(widthRatio)x\(heightRatio)]\n  wRat:\(widthRatio) hRat:\(heightRatio)")
        
        let importWidth = CGFloat(Int(Double(importImage.size.width) * ratio + 0.5))
        let importHeight = CGFloat(Int(Double(importImage.size.height) * ratio + 0.5))
        
        print("Import Final Size: \(importWidth)x\(importHeight)")
        
        return importImage.resize(CGSize(width: importWidth, height: importHeight))
        
    }
    
    func setUp(importImage importImage:UIImage?, screenSize:CGSize) {
        
        if let image = importImage where screenSize.width > 64 && screenSize.height > 64 {
            
            if let image = self.constrainImageToImportSize(importImage: image, screenSize: screenSize) {
                
                imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
                imageView.image = image
                imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                view.addSubview(imageView)
                
                panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ImageImportViewController.didPan(_:)))
                panRecognizer.delegate = self
                panRecognizer.maximumNumberOfTouches = 2
                view.addGestureRecognizer(panRecognizer)
                
                pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
                pinchRecognizer.delegate = self
                view.addGestureRecognizer(pinchRecognizer)
                
                rotRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(ImageImportViewController.didRotate(_:)))
                rotRecognizer.delegate = self
                view.addGestureRecognizer(rotRecognizer)

                
                
                cropView.frame = getCropRect(screenSize)
                view.addSubview(cropView)
                
                cropView.backgroundColor = UIColor.clearColor()
                cropView.layer.borderColor = UIColor.whiteColor().CGColor
                cropView.layer.borderWidth = 3
                
                view.addSubview(cropViewOutsideU)
                view.addSubview(cropViewOutsideR)
                view.addSubview(cropViewOutsideD)
                view.addSubview(cropViewOutsideL)
                
                var outsideColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75)
                
                cropViewOutsideU.backgroundColor = outsideColor
                cropViewOutsideR.backgroundColor = outsideColor
                cropViewOutsideD.backgroundColor = outsideColor
                cropViewOutsideL.backgroundColor = outsideColor
                
                
                placeCropOutside()
                
                
                
                self.view.bringSubviewToFront(toolBarBottom)
                self.view.bringSubviewToFront(navigationBar)
            }
        }
    }
    
    func getCropRect(size: CGSize) -> CGRect {
        
        var activeBorder = 10.0
        if gDevice.tablet {
            activeBorder = 30.0
        }
        
        let activeTop = (navigationBar.frame.size.height + navigationBar.frame.origin.y) + CGFloat(activeBorder)
        let activeBottom = size.height - (toolBarBottom.frame.size.height + CGFloat(activeBorder))
        let activeWidth = size.width - (CGFloat(activeBorder * 2))
        let activeHeight = (activeBottom - activeTop)
        let activeCenter = CGPoint(x: size.width / 2.0, y: activeTop + activeHeight / 2.0)

        
        let cropWidth = activeWidth
        let cropHeight = activeHeight
        
        return CGRect(x: activeCenter.x - cropWidth / 2.0, y: activeCenter.y - cropHeight / 2.0, width: cropWidth, height: cropHeight)
    }
    
    func placeCropOutside() {
        
        cropViewOutsideU.frame = CGRectMake(cropView.frame.origin.x, 0.0, cropView.frame.size.width, cropView.frame.origin.y)
        cropViewOutsideR.frame = CGRectMake(cropView.frame.maxX, 0.0, view.frame.size.width - cropView.frame.maxX, view.frame.size.height)
        cropViewOutsideD.frame = CGRectMake(cropView.frame.origin.x, cropView.frame.maxY, cropView.frame.size.width, view.frame.height - cropView.frame.maxY)
        cropViewOutsideL.frame = CGRectMake(0.0, 0.0, cropView.frame.origin.x, view.frame.size.height)
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

















