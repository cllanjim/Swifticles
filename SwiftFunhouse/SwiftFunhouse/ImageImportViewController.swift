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
    
    
    var panRecognizer:UIPanGestureRecognizer!;//(target: self, action: #selector(ImageImportViewController.didPan(_:)))
    var pinchRecognizer:UIPinchGestureRecognizer!;//(target: self, action: #selector(didPinch(_:)))
    var rotRecognizer:UIRotationGestureRecognizer!;//(target: self, action: #selector(ImageImportViewController.didRotate(_:)))
    
    
    
    var starTouchCenter:CGPoint = CGPointZero
    
    var startImageTouchCenter:CGPoint = CGPointZero {
        didSet {
            
            let crosshairT = CGAffineTransformMakeTranslation(startImageTouchCenter.x, startImageTouchCenter.y)
            startCrosshairH.transform = crosshairT
            startCrosshairV.transform = crosshairT
        }
    }
    var startRotation:CGFloat = 0.0
    var startScale:CGFloat = 1.0
    
    
    
    var crosshairH:UIView = UIView()
    var crosshairV:UIView = UIView()
    
    var centerCrosshairH:UIView = UIView()
    var centerCrosshairV:UIView = UIView()
    
    
    var startCrosshairH:UIView = UIView()
    var startCrosshairV:UIView = UIView()
    
    
    
    var touchCenter = CGPointZero {
        didSet {
            let crosshairT = CGAffineTransformMakeTranslation(touchCenter.x, touchCenter.y)
            centerCrosshairH.transform = crosshairT
            centerCrosshairV.transform = crosshairT
        }
    }
    
    
    var localImageCenter:CGPoint = CGPointZero
    var imageCenter:CGPoint {
        
        get {
            return localImageCenter
        }
        
        set {
            localImageCenter.x = newValue.x
            localImageCenter.y = newValue.y
            
            
            let crosshairT = CGAffineTransformMakeTranslation(pivotPoint.x, pivotPoint.y)
            crosshairH.transform = crosshairT
            crosshairV.transform = crosshairT
            
            
        }
        
    }
    
    
    var translation:CGPoint = CGPointZero
    var rotation:CGFloat = 0.0
    var scale:CGFloat = 1.0
    
    
    var pivotPoint:CGPoint = CGPointZero {
    
        didSet {
            
            if imageView != nil {
                
                
                //imageView.layer.anchorPoint = CGPoint(x: pivotPoint.x / imageView.bounds.size.width , y: pivotPoint.y / imageView.bounds.size.height)
                //print("Anchor = [\(imageView.layer.anchorPoint.x) , \(imageView.layer.anchorPoint.y)] ")
                
                
            }
        }
    }
    
    
    var pivot:Bool = false
    
    
    func updateTransform() {
        
        var t = CGAffineTransformIdentity
        
        
        t = CGAffineTransformScale(t, scale, scale)
        t = CGAffineTransformRotate(t, rotation)
        //t.tx = translation.x
        //t.ty = translation.y
        
        imageView.transform = t
        
        
        let newImageTouchCenter = imageView.convertPoint(touchCenter, fromView: view)
        
        let deltaX = newImageTouchCenter.x - startImageTouchCenter.x
        let deltaY = newImageTouchCenter.y - startImageTouchCenter.y
        
        translation.x = deltaX
        translation.y = deltaY
        
        //t.tx = translation.x
        //t.ty = translation.y
        
        t = CGAffineTransformTranslate(t, translation.x, translation.y)
        
        
        imageView.transform = t
        
        //print("Delta[\(deltaX),\(deltaY)]")
        
        
        
        //starTouchCenter = pos
        //startImageTouchCenter = imageView.convertPoint(pos, fromView: view)
        
        
        //imageView.transform.tx = translation.x
        //imageView.transform.ty = translation.y
        

        
        
        
    }
    
    func gestureBegan(pos:CGPoint) {
        
        starTouchCenter = pos
        startImageTouchCenter = imageView.convertPoint(pos, fromView: view)
        
        pinchRecognizer.scale = 1.0
        rotRecognizer.rotation = 0.0
        
        
        
        
        startScale = scale
        startRotation = rotation
        
    }
    
    
    func didPan(gr:UIPanGestureRecognizer) -> Void {
        
        touchCenter = gr.locationInView(self.view)
        
        let localTranslation = gr.translationInView(self.view)
        
        
        switch gr.state {
            
        case .Began:
            
            gestureBegan(touchCenter)
            break
        case .Changed:
            
            break
        default:
            
            break
            
        }
        
        updateTransform()
        
        //var touchCenter = CGPointZero
        //var imageCenter = CGPointZero
        
        
        /*
        var localPivot = gr.locationInView(imageView)
        
        switch gr.state {
        
        case .Began:
            
            pivot = true
            pivotPoint = localPivot //view.convertPoint(localTranslation, fromView: imageView)
            
            print("Pan-Pivot = [\(pivotPoint.x), \(pivotPoint.y)]")
            
            
            startTranslation = self.translation
            translation = CGPoint(x: startTranslation.x + touchCenter.x, y: startTranslation.y + touchCenter.y)
            
            break
        case .Changed:
            
            pivot = true
            pivotPoint = localPivot //view.convertPoint(localTranslation, fromView: imageView)
            
            translation = CGPoint(x: startTranslation.x + touchCenter.x, y: startTranslation.y + touchCenter.y)
            break
        default:
            
            gr.setTranslation(CGPointZero, inView: self.view)
            break
            
        }
 
        */
        
    }
    
    func didPinch(gr:UIPinchGestureRecognizer) -> Void {
        
        touchCenter = gr.locationInView(self.view)

        
        
        switch gr.state {
            
            case .Began:
                gestureBegan(touchCenter)
            
                startScale = scale
                scale = startScale * gr.scale
            
            break
            case .Changed:
            
                scale = startScale * gr.scale
                
                
            break
            default:
            
                gr.scale = 1.0
                
            break
            
        }
        
        let localPivot = gr.locationInView(imageView)
        pivot = true
        pivotPoint = localPivot //view.convertPoint(localTranslation, fromView: imageView)
        //print("Pinch-Pivot = [\(pivotPoint.x), \(pivotPoint.y)]")
        
        
        updateTransform()
        
    }
    
    func didRotate(gr:UIRotationGestureRecognizer) -> Void {
        
        touchCenter = gr.locationInView(self.view)
        
        switch gr.state {
        case .Began:
            gestureBegan(touchCenter)
            startRotation = rotation
            break
        default:
            break
        }
        
        rotation = startRotation + gr.rotation
        
        var localPivot = gr.locationInView(imageView)
        pivot = true
        pivotPoint = localPivot //view.convertPoint(localTranslation, fromView: imageView)
        //print("Rotate-Pivot = [\(pivotPoint.x), \(pivotPoint.y)]")
        
        updateTransform()
        
    }

    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func constrainImageToImportSize(image:UIImage, screenSize:CGSize) -> UIImage {
        
        return image
    }
    
    
    
    func setUp(image:UIImage?, screenSize:CGSize) {
        
        print("SetUp Img[\(image?.size.width)x\(image?.size.height)] Size[\(screenSize.width)x\(screenSize.height)]")
        
        if image != nil && screenSize.width > 64 && screenSize.height > 64 {
            
            let importImage:UIImage = constrainImageToImportSize(image!, screenSize: screenSize)
            
            //imageView = UIImageView(frame: CGRect(x: -(importImage.size.width / 2.0), y: -(importImage.size.height) / 2.0, width: importImage.size.width, height: importImage.size.height))
            imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: importImage.size.width, height: importImage.size.height))
            
            imageView.image = importImage
            imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.addSubview(imageView)
            
            
            crosshairH.frame = CGRect(x: -10.0, y: -50.0, width: 20.0, height: 100.0)
            crosshairV.frame = CGRect(x: -50.0, y: -10.0, width: 100.0, height: 20.0)
            crosshairH.backgroundColor = UIColor.cyanColor()
            crosshairV.backgroundColor = UIColor.cyanColor()
            imageView.addSubview(crosshairH)
            imageView.addSubview(crosshairV)
            
            
            centerCrosshairH.frame = CGRect(x: -5.0, y: -30.0, width: 10.0, height: 60.0)
            centerCrosshairV.frame = CGRect(x: -30.0, y: -5.0, width: 60.0, height: 10.0)
            centerCrosshairH.backgroundColor = UIColor.blueColor()
            centerCrosshairV.backgroundColor = UIColor.blueColor()
            view.addSubview(centerCrosshairH)
            view.addSubview(centerCrosshairV)
            
            
            startCrosshairH.frame = CGRect(x: -3.0, y: -40.0, width: 6.0, height: 80.0)
            startCrosshairV.frame = CGRect(x: -40.0, y: -3.0, width: 80.0, height: 6.0)
            startCrosshairH.backgroundColor = UIColor.yellowColor()
            startCrosshairV.backgroundColor = UIColor.yellowColor()
            imageView.addSubview(startCrosshairH)
            imageView.addSubview(startCrosshairV)
            
            
            
            
            
            panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ImageImportViewController.didPan(_:)))
            panRecognizer.delegate = self
            self.view.addGestureRecognizer(panRecognizer)
            
            pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
            pinchRecognizer.delegate = self
            self.view.addGestureRecognizer(pinchRecognizer)
            
            rotRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(ImageImportViewController.didRotate(_:)))
            rotRecognizer.delegate = self
            self.view.addGestureRecognizer(rotRecognizer)
            
        }
        
        
        //importScrollView?.image = image
        
        //self.image = image
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

















