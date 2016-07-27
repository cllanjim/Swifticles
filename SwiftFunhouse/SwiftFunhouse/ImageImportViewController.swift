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
    
    var startTranslation:CGPoint = CGPointZero
    var startRotation:CGFloat = 0.0
    var startScale:CGFloat = 0.0
    
    var crosshairH:UIView = UIView()
    var crosshairV:UIView = UIView()
    
    
    
    var translation:CGPoint = CGPointZero {didSet {updateTransform()}}
    var rotation:CGFloat = 0.0 {didSet {updateTransform()}}
    var scale:CGFloat = 1.0 {didSet {updateTransform()}}
    
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
        
        t.tx = translation.x
        t.ty = translation.y
        
        imageView.transform = t
        
        //imageView.transform.tx = translation.x
        //imageView.transform.ty = translation.y
        
        let crosshairT = CGAffineTransformMakeTranslation(pivotPoint.x, pivotPoint.y)
        
        crosshairH.frame = CGRectMake(pivotPoint.x - crosshairH.frame.size.width / 2.0, pivotPoint.y - crosshairH.frame.size.height / 2.0, crosshairH.frame.size.width, crosshairH.frame.size.height)
        
        crosshairV.frame = CGRectMake(pivotPoint.x - crosshairV.frame.size.width / 2.0, pivotPoint.y - crosshairV.frame.size.height / 2.0, crosshairV.frame.size.width, crosshairV.frame.size.height)
        
        
        //crosshairH.transform = crosshairT
        //crosshairV.transform = crosshairT
        
    }
    
    
    /*
    @IBOutlet weak var importScrollView: ImportScrollView?
    {
        didSet {
            
            if image != nil && importScrollView != nil {
                importScrollView!.image = image
            }
            
            
        }
    }
    */
    
//    lazy weak var importScrollView:ImportScrollView? =  {
//        var isv:ImportScrollView? = ImportScrollView(frame: self.view.bounds)
//        self.view.addSubview(isv!)
//        return isv
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ImageImportViewController.didPan(_:))))
        self.view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(ImageImportViewController.didPinch(_:))))
        self.view.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(ImageImportViewController.didRotate(_:))))
    }
    
    func didPan(gr:UIPanGestureRecognizer) -> Void {
        
        var localTranslation = gr.translationInView(self.view)
        var localPivot = gr.locationInView(imageView)
        
        switch gr.state {
        
        case .Began:
            
            pivot = true
            pivotPoint = localPivot //view.convertPoint(localTranslation, fromView: imageView)
            
            print("Pan-Pivot = [\(pivotPoint.x), \(pivotPoint.y)]")
            
            
            startTranslation = self.translation
            translation = CGPoint(x: startTranslation.x + localTranslation.x, y: startTranslation.y + localTranslation.y)
            
            break
        case .Changed:
            
            pivot = true
            pivotPoint = localPivot //view.convertPoint(localTranslation, fromView: imageView)
            
            translation = CGPoint(x: startTranslation.x + localTranslation.x, y: startTranslation.y + localTranslation.y)
            break
        default:
            
            gr.setTranslation(CGPointZero, inView: self.view)
            break
            
        }
    }
    
    func didPinch(gr:UIPanGestureRecognizer) -> Void {
        
        var localPivot = gr.locationInView(imageView)
        
        pivot = true
        pivotPoint = localPivot //view.convertPoint(localTranslation, fromView: imageView)
        
        print("Pinch-Pivot = [\(pivotPoint.x), \(pivotPoint.y)]")
        
        
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didRotate(gr:UIRotationGestureRecognizer) -> Void {
        
        rotation = gr.rotation
        
        var localPivot = gr.locationInView(imageView)
        
        pivot = true
        pivotPoint = localPivot //view.convertPoint(localTranslation, fromView: imageView)
        
        print("Rotate-Pivot = [\(pivotPoint.x), \(pivotPoint.y)]")
        
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
            
            imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: importImage.size.width, height: importImage.size.height))
            imageView.image = importImage
            view.addSubview(imageView)
            
            
            crosshairH.frame = CGRect(x: -10.0, y: -50.0, width: 20.0, height: 100.0)
            crosshairV.frame = CGRect(x: -50.0, y: -10.0, width: 100.0, height: 20.0)
            
            crosshairH.backgroundColor = UIColor.cyanColor()
            crosshairV.backgroundColor = UIColor.cyanColor()
            
            imageView.addSubview(crosshairH)
            imageView.addSubview(crosshairV)
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

















