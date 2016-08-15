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
    
    var imageViewTest:UIImageView!
    
    var updateTimer:NSTimer?
    
    var cropView = UIView(frame: CGRectZero)
    var cropViewOutsideU = UIView(frame: CGRectZero)
    var cropViewOutsideR = UIView(frame: CGRectZero)
    var cropViewOutsideD = UIView(frame: CGRectZero)
    var cropViewOutsideL = UIView(frame: CGRectZero)
    
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        let imageCenter = imageView.convertPoint(cropView.center, fromView: view)
        var imageTransform = imageView.layer.transform
        
        coordinator.animateAlongsideTransition({ [weak weakSelf = self] (id:UIViewControllerTransitionCoordinatorContext) in
            if let checkSelf = weakSelf {
                checkSelf.cropView.frame = checkSelf.getCropRect(size)
                checkSelf.placeCropOutside()
                
                let newImageCenter = checkSelf.imageView.convertPoint(checkSelf.cropView.center, fromView: checkSelf.view)
                checkSelf.translation.x = newImageCenter.x - imageCenter.x
                checkSelf.translation.y = newImageCenter.y - imageCenter.y
                //imageTransform = CGAffineTransformTranslate(imageTransform, checkSelf.translation.x, checkSelf.translation.y)
                imageTransform = CATransform3DTranslate(imageTransform, checkSelf.translation.x, checkSelf.translation.y, 0.0)
                
                checkSelf.imageView.layer.transform = imageTransform
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
        /*
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
        */
        
        
        var t = CATransform3DIdentity
        t = CATransform3DScale(t, scale, scale, scale)
        t = CATransform3DRotate(t, rotation, 0.0, 0.0, 1.0)
        
        //t = CATransform3DRotate(t, rotation)
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
        
        print("Import MaxSize[\(widthRatio)x\(heightRatio)]\n  wRat:\(widthRatio) hRat:\(heightRatio)")
        
        let importWidth = CGFloat(Int(Double(importImage.size.width) * ratio + 0.5))
        let importHeight = CGFloat(Int(Double(importImage.size.height) * ratio + 0.5))
        
        print("Import Final Size: \(importWidth)x\(importHeight)")
        
        return importImage.resize(CGSize(width: importWidth, height: importHeight))
        
    }
    
    func setUp(importImage importImage:UIImage?, screenSize:CGSize) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if let navigationController = storyboard.instantiateViewControllerWithIdentifier("main_navigation") as? UINavigationController {
            
            //navigationController.navigationBar.
            
            let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(clickNext(_:)))
            let play = UIBarButtonItem(title: "Play", style: .Plain, target: self, action: #selector(clickNext(_:)))
            
            navigationItem.rightBarButtonItems = [add, play]
            
        }
        
        
        
        //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
        //bundle: nil];
        
        //UINavigationController *controller = (UINavigationController*)[mainStoryboard
        //instantiateViewControllerWithIdentifier: @"<Controller ID>"];
        
        
        
        if let image = importImage where screenSize.width > 64 && screenSize.height > 64 {
            
            if let image = self.constrainImageToImportSize(importImage: image, screenSize: screenSize) {
                
                imageView = UIImageView(frame: CGRect(x: (-image.size.width / 2.0), y: (-image.size.height / 2.0), width: image.size.width, height: image.size.height))
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
                
                
                resetFill()
                
                
                allowGestures = false
                imageView.alpha = 0.5
                var t = imageView.layer.transform
                
                imageView.layer.transform = CATransform3DScale(imageView.layer.transform, 0.8, 0.8, 0.8)
                
                UIView.animateWithDuration(0.40, delay: 0.32, options: [], animations:
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
        if gDevice.tablet {
            activeBorder = 30.0
        }
        
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
            if let image = checkImageView.image where image.size.width > 32 && image.size.height > 32 {
                
                
                var imageWidth = image.size.width
                var imageHeight = image.size.height
                
                
                var cropScale = CGFloat(1.0)
                
                let s1 = ((view.bounds.size.width) / cropView.bounds.size.width) * cropScale
                let s2 = ((view.bounds.size.height) / cropView.bounds.size.height) * cropScale
                
                print("scad1: \(s1) scad2: \(s2)")
                
                print("TRANSLATION = [\(translation.x) x \(translation.y)]")
                print("CROP FRAME = [\(cropView.frame.origin.x) x \(cropView.frame.origin.y)]")
                print("SCALE = \(scale)")
                print("ROTATION = \(rotation)")
                
                
                
                let adjustScale = max(s1, s2)
                

                print("Image ori = \(image.imageOrientation.rawValue)")
                
                var transform = CGAffineTransformIdentity
                
                switch image.imageOrientation {
                case .LeftMirrored, .Left:
                    transform = CGAffineTransformTranslate(transform, image.size.width, 0);
                    transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
                    break
                case .RightMirrored, .Right:
                    transform = CGAffineTransformTranslate(transform, 0, image.size.height);
                    transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
                    break
                case .DownMirrored, .Down:
                    transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
                    transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
                    break
                default:
                    break
                }
                
                switch image.imageOrientation {
                case .UpMirrored, .DownMirrored:
                    transform = CGAffineTransformTranslate(transform, image.size.width, 0)
                    transform = CGAffineTransformScale(transform, -1, 1)
                    break
                case .LeftMirrored, .RightMirrored:
                    transform = CGAffineTransformTranslate(transform, image.size.height, 0)
                    transform = CGAffineTransformScale(transform, -1, 1)
                    break
                default:
                    break
                }
                
                
                
                
                
                transform = CGAffineTransformRotate(transform, rotation)
                
                //transform = CGAffineTransformTranslate(transform, imageWidth / 2.0, imageHeight / 2.0)
                
                transform = CGAffineTransformScale(transform, scale, scale)
                
                
                
                //transform = CGAffineTransformScale(transform, adjustScale, adjustScale)
                
                //transform = CGAffineTransformTranslate(transform, image.size.height, 0)
                //transform = CGAffineTransformScale(transform, 1.0, -1.0)
                
                //transform = CGAffineTransformTranslate(transform, -cropView.frame.origin.x, -cropView.frame.origin.y)
                
                //transform = CGAffineTransformTranslate(transform, translation.x, translation.y)
                
                
                
                transform = CGAffineTransformScale(transform, adjustScale, adjustScale)
                
                
                
                
                //transform = CGAffineTransformTranslate(transform, -cropView.frame.origin.x, -cropView.frame.origin.y)
                
                
                //transform = CGAffineTransformTranslate(transform, imageWidth / 2.0, imageHeight / 2.0)
                
                
                
                //transform = CGAffineTransformTranslate(t, translation.x, translation.y)
                
                
                
                
                
                UIGraphicsBeginImageContextWithOptions(CGSize(width: view.bounds.size.width * cropScale, height: view.bounds.size.height * cropScale), false, 1.0)
                
            
                let context = UIGraphicsGetCurrentContext()
                
                
                
                //CGContextTranslateCTM(context, image.size.width/2.0, image.size.height/2.0)
                //CGContextRotateCTM(context, CGFloat(M_PI))
                //CGContextScaleCTM(context, -1.0, 1.0)
                
                
                
                CGContextConcatCTM(context, transform)
                
                CGContextTranslateCTM(context, image.size.width/2.0, image.size.height/2.0)
                
                
                
                //CGContextRotateCTM(context, rotation)
                //CGContextScaleCTM(context, scale, scale)
                //CGContextTranslateCTM(context, translation.x, translation.y)
                
                //[[UIColor redColor] set]; //set the desired background color
                //UIRectFill(CGRectMake(0.0, 0.0, temp.size.width, temp.size.height))
                
            
                //CGContextDrawImage(context, CGRectMake(-image.size.width, -image.size.height, image.size.width, image.size.height), image.CGImage)
                //CGContextDrawImage(context, CGRectMake(-(image.size.width / 2.0), -(image.size.height) / 2.0, image.size.width, image.size.height), image.CGImage)
                CGContextDrawImage(context, CGRectMake(0.0, 0.0, image.size.width, image.size.height), image.CGImage)
                
                
                let resultImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            //return returnImg;
                
                
                return resultImage
            
            
                }
            
        }
        
        
        return nil
    }
    
    
    @IBAction func clickNext(sender: UIBarButtonItem) {
        print("NAXT")
        
        
        
        if imageViewTest == nil {
            imageViewTest = UIImageView()
            view.addSubview(imageViewTest)
        }
        
        imageViewTest.frame = CGRect(x: 50, y: 200, width: cropView.bounds.size.width / 2.0, height: cropView.bounds.size.height / 2.0)
        imageViewTest.backgroundColor = UIColor(red: 0.5, green: 0.0, blue: 0.15, alpha: 0.4)
        
        if let resultImage = cropImage() {
            
            
            imageViewTest.image = resultImage
            
        }
        
    }
    
    @IBAction func clickCancel(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if let navigationController = storyboard.instantiateViewControllerWithIdentifier("main_navigation") as? UINavigationController {
            //navigationController.popViewControllerAnimated(true)
            
            print(navigationController.viewControllers)
            
        }
    }
    
    
    func resetToScale(resetScale resetScale:CGFloat) {
        
        if let checkImageView = imageView {
            rotation = 0.0
            scale = resetScale
            translation = CGPoint(x: (cropView.frame.midX), y: (cropView.frame.midY))
            var t = CATransform3DIdentity
            t = CATransform3DTranslate(t, translation.x, translation.y, 0.0)
            t = CATransform3DScale(t, scale, scale, scale)
            t = CATransform3DRotate(t, rotation, 0.0, 0.0, 1.0)
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

















