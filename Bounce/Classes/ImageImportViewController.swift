//
//  ImageImportViewController.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/22/16.
//

import UIKit

class ImageImportViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //@IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBarBottom: UIToolbar!
    
    deinit {
        print("ImageImportViewController.deinit()")
    }
    
    var imageCropped:UIImage?
    var imageView:UIImageView!
    
    var updateTimer:Timer?
    
    var cropView = UIView(frame: CGRect.zero)
    var cropViewOutsideU = UIView(frame: CGRect.zero)
    var cropViewOutsideR = UIView(frame: CGRect.zero)
    var cropViewOutsideD = UIView(frame: CGRect.zero)
    var cropViewOutsideL = UIView(frame: CGRect.zero)
    
    var allowGestures:Bool = true
    
    var panRecognizer:UIPanGestureRecognizer!;
    var pinchRecognizer:UIPinchGestureRecognizer!;
    var rotRecognizer:UIRotationGestureRecognizer!;
    
    var panRecognizerTouchCount:Int = 0
    var pinchRecognizerTouchCount:Int = 0
    var rotRecognizerTouchCount:Int = 0
    
    var gestureCancelTimer:Int = 0
    
    var startImageTouchCenter:CGPoint = CGPoint.zero
    var startRotation:CGFloat = 0.0
    var startScale:CGFloat = 1.0
    
    var touchCenter = CGPoint.zero
    
    
    var translation:CGPoint = CGPoint.zero
    var rotation:CGFloat = 0.0
    var scale:CGFloat = 1.0
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        let imageCenter = imageView.convert(cropView.center, from: view)
        
        coordinator.animate(alongsideTransition: { [weak weakSelf = self] (id:UIViewControllerTransitionCoordinatorContext) in
            if let checkSelf = weakSelf {
                checkSelf.cropView.frame = checkSelf.getCropRect(size)
                checkSelf.placeCropOutside()
                
                let newImageCenter = checkSelf.imageView.convert(checkSelf.cropView.center, from: checkSelf.view)
                checkSelf.translation.x += (newImageCenter.x - imageCenter.x)
                checkSelf.translation.y += (newImageCenter.y - imageCenter.y)
                
                var t = CATransform3DIdentity
                t = CATransform3DScale(t, checkSelf.scale, checkSelf.scale, checkSelf.scale)
                t = CATransform3DRotate(t, checkSelf.rotation, 0.0, 0.0, 1.0)
                t = CATransform3DTranslate(t, checkSelf.translation.x, checkSelf.translation.y, 0.0)
                checkSelf.imageView.layer.transform = t
            }
            }, completion: nil)
        
    }
    
    
    func allowTransform() -> Bool {
        if gestureCancelTimer > 0 {
            return false
        }
        return true
    }
    
    func cancelAllGestureRecognizers() {
        gestureCancelTimer = 3
        panRecognizer.isEnabled = false
        pinchRecognizer.isEnabled = false
        rotRecognizer.isEnabled = false
    }
    
    func updateTransform() {
        var t = CATransform3DIdentity
        t = CATransform3DScale(t, scale, scale, scale)
        t = CATransform3DRotate(t, rotation, 0.0, 0.0, 1.0)
        imageView.layer.transform = t
        
        //Re-center the image at the center of our touch
        //within the object, based on initial touch center.
        let newImageTouchCenter = imageView.convert(touchCenter, from: view)
        translation.x = newImageTouchCenter.x - startImageTouchCenter.x
        translation.y = newImageTouchCenter.y - startImageTouchCenter.y
        t = CATransform3DTranslate(t, translation.x, translation.y, 0.0)
        
        imageView.layer.transform = t
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(ImageImportViewController.update), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
    }
    
    func gestureBegan(_ pos:CGPoint) {
        startImageTouchCenter = imageView.convert(pos, from: view)
        pinchRecognizer.scale = 1.0
        rotRecognizer.rotation = 0.0
        panRecognizer.setTranslation(CGPoint.zero, in: view)
        startScale = scale
        startRotation = rotation
    }
    
    func didPan(_ gr:UIPanGestureRecognizer) -> Void {
        self.performSelector(onMainThread: #selector(ImageImportViewController.didPanMainThread(_:)), with: gr, waitUntilDone: true, modes: [RunLoopMode.commonModes.rawValue])
    }
    
    func didPanMainThread(_ gr:UIPanGestureRecognizer) -> Void {
        
        if allowGestures == false {
            cancelAllGestureRecognizers()
            return
        }
        
        touchCenter = gr.location(in: self.view)
        switch gr.state {
        case .began:
            gestureBegan(touchCenter)
            panRecognizerTouchCount = gr.numberOfTouches
            break
        case .changed:
            if panRecognizerTouchCount != gr.numberOfTouches {
                if gr.numberOfTouches > panRecognizerTouchCount {
                    panRecognizerTouchCount = gr.numberOfTouches
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
    
    func didPinch(_ gr:UIPinchGestureRecognizer) -> Void {
        self.performSelector(onMainThread: #selector(didPinchMainThread(_:)), with: gr, waitUntilDone: true, modes: [RunLoopMode.commonModes.rawValue])
    }
    
    func didPinchMainThread(_ gr:UIPinchGestureRecognizer) -> Void {
        
        if allowGestures == false {
            cancelAllGestureRecognizers()
            return
        }
        
        touchCenter = gr.location(in: self.view)
        switch gr.state {
        case .began:
            if allowTransform() {
                gestureBegan(touchCenter)
                startScale = scale
                pinchRecognizerTouchCount = gr.numberOfTouches
            }
            break
        case .changed:
            
            if pinchRecognizerTouchCount != gr.numberOfTouches {
                if gr.numberOfTouches > pinchRecognizerTouchCount {
                    pinchRecognizerTouchCount = gr.numberOfTouches
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
    
    func didRotate(_ gr:UIRotationGestureRecognizer) -> Void {
        self.performSelector(onMainThread: #selector(didRotateMainThread(_:)), with: gr, waitUntilDone: true, modes: [RunLoopMode.commonModes.rawValue])
    }
    func didRotateMainThread(_ gr:UIRotationGestureRecognizer) -> Void {
        
        if allowGestures == false {
            cancelAllGestureRecognizers()
            return
        }
        
        touchCenter = gr.location(in: self.view)
        switch gr.state {
        case .began:
            if allowTransform() {
                gestureBegan(touchCenter)
                startRotation = rotation
                rotRecognizerTouchCount = gr.numberOfTouches
            }
            break
        case .changed:
            if rotRecognizerTouchCount != gr.numberOfTouches {
                if gr.numberOfTouches > rotRecognizerTouchCount {
                    rotRecognizerTouchCount = gr.numberOfTouches
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func constrainImageToImportSize(importImage:UIImage, screenSize:CGSize) -> UIImage? {
        let importScale = gApp.importScale
        
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
    
    func setUp(importImage:UIImage?, screenSize:CGSize) {
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(clickNext(_:)))
        navigationItem.rightBarButtonItems = [done]
        
        if let image = importImage , screenSize.width > 64 && screenSize.height > 64 {
            if let image = self.constrainImageToImportSize(importImage: image, screenSize: screenSize) {
                
                loadViewIfNeeded()
                view.layoutIfNeeded()
                
                gApp.navigationController.setNavigationBarHidden(false, animated: true)
                
                
                imageView = UIImageView(frame: CGRect(x: (-image.size.width / 2.0), y: (-image.size.height / 2.0), width: image.size.width, height: image.size.height))
                imageView.image = image
                //imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                view.addSubview(imageView)
                
                panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ImageImportViewController.didPan(_:)))
                panRecognizer.delegate = self
                panRecognizer.maximumNumberOfTouches = 2
                panRecognizer.cancelsTouchesInView = false
                view.addGestureRecognizer(panRecognizer)
                
                pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
                pinchRecognizer.delegate = self
                pinchRecognizer.cancelsTouchesInView = false
                view.addGestureRecognizer(pinchRecognizer)
                
                rotRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(ImageImportViewController.didRotate(_:)))
                rotRecognizer.delegate = self
                rotRecognizer.cancelsTouchesInView = false
                view.addGestureRecognizer(rotRecognizer)
                
                
                
                cropView.frame = getCropRect(screenSize)
                view.addSubview(cropView)
                
                cropView.backgroundColor = UIColor.clear
                cropView.layer.borderColor = UIColor(red: 0.88, green: 0.88, blue: 0.92, alpha: 0.92).cgColor
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
                
                self.view.bringSubview(toFront: toolBarBottom)
                //self.view.bringSubviewToFront(navigationBar)
                
                
                
                resetFill()
                
                
                allowGestures = false
                imageView.alpha = 0.0
                let t = imageView.layer.transform
                
                imageView.layer.transform = CATransform3DScale(imageView.layer.transform, 0.925, 0.925, 0.925)
                allowGestures = false
                UIView.animate(withDuration: 0.48, delay: 0.36, options: [], animations:
                    {[weak weakSelf = self] in
                        weakSelf?.imageView.alpha = 1.0
                        weakSelf?.imageView.layer.transform = t
                }) { [weak weakSelf = self] (complete) in
                    weakSelf?.allowGestures = true
                }
            }
        }
    }
    
    func getCropRect(_ size: CGSize) -> CGRect {
        let activeBorder = gDevice.tablet ? 24.0 : 6.0
        let navigationBar = gApp.navigationController.navigationBar
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
        cropViewOutsideU.frame = CGRect(x: cropView.frame.origin.x, y: 0.0, width: cropView.frame.size.width, height: cropView.frame.origin.y)
        cropViewOutsideR.frame = CGRect(x: cropView.frame.maxX, y: 0.0, width: view.frame.size.width - cropView.frame.maxX, height: view.frame.size.height)
        cropViewOutsideD.frame = CGRect(x: cropView.frame.origin.x, y: cropView.frame.maxY, width: cropView.frame.size.width, height: view.frame.height - cropView.frame.maxY)
        cropViewOutsideL.frame = CGRect(x: 0.0, y: 0.0, width: cropView.frame.origin.x, height: view.frame.size.height)
    }
    
    func update() {
        if gestureCancelTimer > 0 {
            gestureCancelTimer = gestureCancelTimer - 1
            if gestureCancelTimer <= 0 {
                panRecognizer.isEnabled = true
                pinchRecognizer.isEnabled = true
                rotRecognizer.isEnabled = true
            }
        }
    }
    
    func cropImage() -> UIImage? {
        if let checkImageView = imageView , cropView.bounds.size.width > 32 && cropView.bounds.size.height > 32 {
            if let checkImage = checkImageView.image , checkImage.size.width > 32 && checkImage.size.height > 32 {

                let image = checkImage
                let imageCenter = imageView.convert(CGPoint(x: imageView.bounds.midX, y: imageView.bounds.midY), to: view)
                let imageShift = CGPoint(x: imageCenter.x - cropView.frame.midX, y: imageCenter.y - cropView.frame.midY)
                
                let cropScale = gDevice.scale
                let s1 = ((view.bounds.size.width) / cropView.bounds.size.width) * cropScale
                let s2 = ((view.bounds.size.height) / cropView.bounds.size.height) * cropScale
                let adjustScale = max(s1, s2)
                
                let resultWidth = view.bounds.size.width * cropScale
                let resultHeight = view.bounds.size.height * cropScale
                
                //UIGraphicsBeginImageContextWithOptions(CGSize(width: resultWidth, height: resultHeight), false, 0.0)
                UIGraphicsBeginImageContext(CGSize(width: resultWidth, height: resultHeight))
                
                let context = UIGraphicsGetCurrentContext();
                
                context?.translateBy(x: (resultWidth / 2.0), y: (resultHeight / 2.0))
                context?.scaleBy(x: adjustScale, y: adjustScale)
                context?.translateBy(x: imageShift.x, y: imageShift.y)
                context?.scaleBy(x: scale, y: scale)
                context?.rotate(by: rotation)
                context?.translateBy(x: -(image.size.width / 2.0), y: -(image.size.height / 2.0))
                
                //And then for some reason, flip the whole thing horizontally.
                context?.translateBy(x: 0.0, y: image.size.height)
                context?.scaleBy(x: 1.0, y: -1.0)
                
                //CGContextSetAlpha(context, 0.75)
                context?.draw(image.cgImage!, in: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
                
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                
                print("RESULT W[\(resultImage?.size.width)] H[\(resultImage?.size.height)] Sc[\(resultImage?.scale)]")
                
                return resultImage
            }
        }
        return nil
    }
    
    @IBAction func clickNext(_ sender: UIBarButtonItem) {
        if let resultImage = cropImage() {
            let isPortrait = view.bounds.size.width < view.bounds.size.height
            if let bounce = gApp.getStoryboardVC("bounce") as? BounceViewController {
                bounce.loadViewIfNeeded()
                bounce.setUpNew(image: resultImage, sceneRect:CGRect(x: 0.0, y: 0.0, width: isPortrait ? gDevice.portraitWidth : gDevice.landscapeWidth, height: isPortrait ? gDevice.portraitHeight : gDevice.landscapeHeight), portraitOrientation: isPortrait)
            
                gApp.navigationController.setNavigationBarHidden(true, animated: true)
                gApp.navigationController.setViewControllers([bounce], animated: true)
            }
        }
    }
    
    func resetToScale(resetScale:CGFloat) {
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
        if let checkImageView = imageView , cropView.frame.size.width > 16.0 && cropView.frame.size.height > 16.0 {
            let widthRatio = cropView.frame.size.width / checkImageView.bounds.size.width
            let heightRatio = cropView.frame.size.height / checkImageView.bounds.size.height
            resetToScale(resetScale: min(widthRatio, heightRatio))
        }
    }
    
    func resetFill() {
        if let checkImageView = imageView , cropView.frame.size.width > 16.0 && cropView.frame.size.height > 16.0 {
            let widthRatio = cropView.frame.size.width / checkImageView.bounds.size.width
            let heightRatio = cropView.frame.size.height / checkImageView.bounds.size.height
            resetToScale(resetScale: max(widthRatio, heightRatio))
        }
    }
    
    @IBAction func clickResetFit(_ sender: UIBarButtonItem) {
        cancelAllGestureRecognizers()
        allowGestures = false
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [], animations:
            {[weak weakSelf = self] in
                weakSelf?.resetFit()
        }){[weak weakSelf = self] (b) in
            weakSelf?.allowGestures = true
        }
    }
    
    @IBAction func clickResetFill(_ sender: UIBarButtonItem) {
        cancelAllGestureRecognizers()
        allowGestures = false
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [], animations:
            {[weak weakSelf = self] in
                weakSelf?.resetFill()
        }){[weak weakSelf = self] (b) in
            weakSelf?.allowGestures = true
        }
    }
}

















