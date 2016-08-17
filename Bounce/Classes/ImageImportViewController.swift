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
    
    var imageCropped:UIImage?
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
        //let imageTransform = imageView.layer.transform
        
        coordinator.animateAlongsideTransition({ [weak weakSelf = self] (id:UIViewControllerTransitionCoordinatorContext) in
            if let checkSelf = weakSelf {
                checkSelf.cropView.frame = checkSelf.getCropRect(size)
                checkSelf.placeCropOutside()
                
                let newImageCenter = checkSelf.imageView.convertPoint(checkSelf.cropView.center, fromView: checkSelf.view)
                checkSelf.translation.x += (newImageCenter.x - imageCenter.x)// / checkSelf.scale
                checkSelf.translation.y += (newImageCenter.y - imageCenter.y)// / checkSelf.scale
                
                var t = CATransform3DIdentity
                //t = CATransform3DTranslate(t, translation.x, translation.y, 0.0)
                t = CATransform3DScale(t, checkSelf.scale, checkSelf.scale, checkSelf.scale)
                t = CATransform3DRotate(t, checkSelf.rotation, 0.0, 0.0, 1.0)
                t = CATransform3DTranslate(t, checkSelf.translation.x, checkSelf.translation.y, 0.0)
                
                
                
                //imageTransform = CGAffineTransformTranslate(imageTransform, checkSelf.translation.x, checkSelf.translation.y)
                //imageTransform = CATransform3DTranslate(imageTransform, checkSelf.translation.x, checkSelf.translation.y, 0.0)
                
                checkSelf.imageView.layer.transform = t//imageTransform
            }
            }, completion: nil)
    }
    
    
    func allowTransform() -> Bool {
        if cancelTimer > 0 {
            return false
        }
        return true
    }
    
    func cancelAllGestureRecognizers() {
        cancelTimer = 5
        panRecognizer.enabled = false
        pinchRecognizer.enabled = false
        rotRecognizer.enabled = false
    }
    
    var allowGestures:Bool = true
    
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
    
    //var pivot:Bool = false
    
    
    func updateTransform() {
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
        
        if allowGestures == false {
            cancelAllGestureRecognizers()
            return
        }
        
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
                    cancelAllGestureRecognizers()
                }
            }
            break
        default:
            cancelAllGestureRecognizers()
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
        
        if allowGestures == false {
            cancelAllGestureRecognizers()
            return
        }
        
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
                    cancelAllGestureRecognizers()
                }
            }
            break
        default:
            cancelAllGestureRecognizers()
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
        
        if allowGestures == false {
            cancelAllGestureRecognizers()
            return
        }
        
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
                    cancelAllGestureRecognizers()
                }
            }
            break
        default:
            cancelAllGestureRecognizers()
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
        
        let importMaxWidth = Double(screenSize.width) * Double(importScale)
        let importMaxHeight = Double(screenSize.height) * Double(importScale)
        
        let widthRatio = importMaxWidth / Double(importImage.size.width)
        let heightRatio = importMaxHeight / Double(importImage.size.height)
        
        let ratio = max(widthRatio, heightRatio)
        
        print("Import MaxSize[\(importMaxWidth)x\(importMaxHeight)]\n  wRat:\(widthRatio) hRat:\(heightRatio)")
        
        let importWidth = CGFloat(Int(Double(importImage.size.width) * ratio + 0.5))
        let importHeight = CGFloat(Int(Double(importImage.size.height) * ratio + 0.5))
        
        print("Import Final Size: \(importWidth)x\(importHeight)")
        
        return importImage.resize(CGSize(width: importWidth, height: importHeight))
    }
    
    func setUp(importImage importImage:UIImage?, screenSize:CGSize) {
        
        let done = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(clickNext(_:)))
        navigationItem.rightBarButtonItems = [done]
        
        if let image = importImage where screenSize.width > 64 && screenSize.height > 64 {
            if let image = self.constrainImageToImportSize(importImage: image, screenSize: screenSize) {
                
                imageView = UIImageView(frame: CGRect(x: (-image.size.width / 2.0), y: (-image.size.height / 2.0), width: image.size.width, height: image.size.height))
                imageView.image = image
                //imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
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
                cropView.layer.borderColor = UIColor(red: 0.88, green: 0.88, blue: 0.92, alpha: 0.92).CGColor
                cropView.layer.borderWidth = 2
                
                view.addSubview(cropViewOutsideU)
                view.addSubview(cropViewOutsideR)
                view.addSubview(cropViewOutsideD)
                view.addSubview(cropViewOutsideL)
                
                let outsideColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.685)
                
                cropViewOutsideU.backgroundColor = outsideColor
                cropViewOutsideR.backgroundColor = outsideColor
                cropViewOutsideD.backgroundColor = outsideColor
                cropViewOutsideL.backgroundColor = outsideColor
                
                placeCropOutside()
                
                self.view.bringSubviewToFront(toolBarBottom)
                self.view.bringSubviewToFront(navigationBar)
                
                
                resetFill()
                
                
                allowGestures = false
                imageView.alpha = 0.0
                let t = imageView.layer.transform
                
                imageView.layer.transform = CATransform3DScale(imageView.layer.transform, 0.925, 0.925, 0.925)
                allowGestures = false
                UIView.animateWithDuration(0.33, delay: 0.20, options: [], animations:
                    {[weak weakSelf = self] in
                        weakSelf?.imageView.alpha = 1.0
                        weakSelf?.imageView.layer.transform = t
                }){[weak weakSelf = self] (b) in
                    weakSelf?.allowGestures = true
                }
                
                
            }
        }
    }
    
    func getCropRect(size: CGSize) -> CGRect {
        var activeBorder = 10.0
        if gDevice.tablet { activeBorder = 30.0 }
        
        let activeTop = (navigationBar.frame.size.height + navigationBar.frame.origin.y) + CGFloat(activeBorder)
        let activeBottom = size.height - (toolBarBottom.frame.size.height + CGFloat(activeBorder))
        let activeWidth = size.width - (CGFloat(activeBorder * 2))
        let activeHeight = (activeBottom - activeTop)
        let activeCenter = CGPoint(x: size.width / 2.0, y: activeTop + activeHeight / 2.0)
        
        let widthRatio = activeWidth / size.width
        let heightRatio = activeHeight / size.height
        let ratio = min(widthRatio, heightRatio)
        
        let cropWidth = CGFloat(Int(size.width * ratio + 0.5))
        let cropHeight = CGFloat(Int(size.height * ratio + 0.5))
        
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
    
    func cropImage() -> UIImage? {
        
        if let checkImageView = imageView where cropView.bounds.size.width > 32 && cropView.bounds.size.height > 32 {
            if let checkImage = checkImageView.image where checkImage.size.width > 32 && checkImage.size.height > 32 {
                
                let image = checkImage//fixImageOrientation(image: checkImage)
                
                let imageCenter = imageView.convertPoint(CGPoint(x: imageView.bounds.midX, y: imageView.bounds.midY), toView: view)
                let imageShift = CGPoint(x: imageCenter.x - cropView.frame.midX, y: imageCenter.y - cropView.frame.midY)
                
                let cropScale = gDevice.scale
                
                let s1 = ((view.bounds.size.width) / cropView.bounds.size.width) * cropScale
                let s2 = ((view.bounds.size.height) / cropView.bounds.size.height) * cropScale
                let adjustScale = max(s1, s2)
                
                
                
                
                let resultWidth = view.bounds.size.width * cropScale
                let resultHeight = view.bounds.size.height * cropScale
                
                //UIGraphicsBeginImageContextWithOptions(CGSize(width: resultWidth, height: resultHeight), false, 1.0)
                //UIGraphicsBeginImageContextWithOptions(CGSize(width: resultWidth, height: resultHeight), false, 0.0)
                UIGraphicsBeginImageContext(CGSize(width: resultWidth, height: resultHeight))
                
                
                
                let context = UIGraphicsGetCurrentContext();
                
                //var alpha = CGFloat(1.0)
                //UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: alpha).set()
                //CGContextFillRect(context, CGRect(x: 0.0, y: 0.0, width: (resultWidth / 2.0), height: (resultHeight / 2.0)))
                //UIColor(red: 0.2, green: 1.0, blue: 0.2, alpha: alpha).set()
                //CGContextFillRect(context, CGRect(x: (resultWidth / 2.0), y: 0.0, width: (resultWidth / 2.0), height: (resultHeight / 2.0)))
                //UIColor(red: 0.2, green: 0.4, blue: 0.7, alpha: alpha).set()
                //CGContextFillRect(context, CGRect(x: 0.0, y: (resultHeight / 2.0), width: (resultWidth / 2.0), height: (resultHeight / 2.0)))
                //UIColor(red: 0.85, green: 0.90, blue: 0.125, alpha: alpha).set()
                //CGContextFillRect(context, CGRect(x: (resultWidth / 2.0), y: (resultHeight / 2.0), width: (resultWidth / 2.0), height: (resultHeight / 2.0)))

                
                
                CGContextTranslateCTM(context, (resultWidth / 2.0), (resultHeight / 2.0))
                CGContextScaleCTM(context, adjustScale, adjustScale)
                CGContextTranslateCTM(context, imageShift.x, imageShift.y)
                CGContextScaleCTM(context, scale, scale)
                CGContextRotateCTM(context, rotation)
                CGContextTranslateCTM(context, -(image.size.width / 2.0), -(image.size.height / 2.0))
                
                
                //And then for some reason, flip the whole thing horizontally.
                CGContextTranslateCTM(context, 0.0, image.size.height)
                CGContextScaleCTM(context, 1.0, -1.0)
                
                //CGContextSetAlpha(context, 0.75)
                CGContextDrawImage(context, CGRectMake(0.0, 0.0, image.size.width, image.size.height), image.CGImage)
                
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                
                print("RESULT W[\(resultImage.size.width)] H[\(resultImage.size.height)] Sc[\(resultImage.scale)]")
                
                return resultImage
            }
        }
        return nil
    }
    
    
    @IBAction func clickNext(sender: UIBarButtonItem) {
        
        if let resultImage = cropImage() {
            
            //imageCropped = resultImage
            
            if let navigationController = self.navigationController {
                
                var isPortrait = view.bounds.size.width < view.bounds.size.height
                
            
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let bounce = storyboard.instantiateViewControllerWithIdentifier("bounce") as! BounceViewController
                
                bounce.loadViewIfNeeded()
                
                bounce.setUp(image: resultImage, portraitOrientation: isPortrait)
                
                navigationController.setNavigationBarHidden(true, animated: true)
                
                navigationController.setViewControllers([bounce], animated: true)
            }
        }
    }
    
    func resetToScale(resetScale resetScale:CGFloat) {
        if let checkImageView = imageView {
            rotation = 0.0
            scale = resetScale
            translation = CGPoint(x: (cropView.frame.midX / scale), y: (cropView.frame.midY / scale))
            var t = CATransform3DIdentity
            t = CATransform3DScale(t, scale, scale, scale)
            t = CATransform3DRotate(t, rotation, 0.0, 0.0, 1.0)
            t = CATransform3DTranslate(t, translation.x, translation.y, 0.0)
            checkImageView.layer.transform = t
            imageView.layer.transform = t
        }
    }
    
    func resetFit() {
        if let checkImageView = imageView where cropView.frame.size.width > 16.0 && cropView.frame.size.height > 16.0 {
            let widthRatio = cropView.frame.size.width / checkImageView.bounds.size.width
            let heightRatio = cropView.frame.size.height / checkImageView.bounds.size.height
            resetToScale(resetScale: max(widthRatio, heightRatio))
        }
    }
    
    func resetFill() {
        if let checkImageView = imageView where cropView.frame.size.width > 16.0 && cropView.frame.size.height > 16.0 {
            let widthRatio = cropView.frame.size.width / checkImageView.bounds.size.width
            let heightRatio = cropView.frame.size.height / checkImageView.bounds.size.height
            resetToScale(resetScale: min(widthRatio, heightRatio))
        }
    }
    
    @IBAction func clickResetFit(sender: UIBarButtonItem) {
        cancelAllGestureRecognizers()
        allowGestures = false
        UIView.animateWithDuration(0.35, delay: 0.0, options: [], animations:
            {[weak weakSelf = self] in
                weakSelf?.resetFit()
        }){[weak weakSelf = self] (b) in
            weakSelf?.allowGestures = true
        }
    }
    
    @IBAction func clickResetFill(sender: UIBarButtonItem) {
        cancelAllGestureRecognizers()
        allowGestures = false
        UIView.animateWithDuration(0.35, delay: 0.0, options: [], animations:
            {[weak weakSelf = self] in
                weakSelf?.resetFill()
        }){[weak weakSelf = self] (b) in
            weakSelf?.allowGestures = true
        }
    }
}

















