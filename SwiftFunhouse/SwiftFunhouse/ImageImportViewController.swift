//
//  ImageImportViewController.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/22/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ImageImportViewController: UIViewController {
    
    
    var imageView:UIImageView!
    
    var translation:CGPoint = CGPointZero {didSet {updateTransform()}}
    var rotation:CGFloat = 0.0 {didSet {updateTransform()}}
    var scale:CGFloat = 1.0 {didSet {updateTransform()}}
    
    func updateTransform() {
        
        var t = CGAffineTransformIdentity
        
        
        t = CGAffineTransformScale(t, scale, scale)
        t = CGAffineTransformRotate(t, rotation)
        
        t.tx = translation.x
        t.ty = translation.y
        
        imageView.transform = t
        
        //imageView.transform.tx = translation.x
        //imageView.transform.ty = translation.y
        
        
        
        
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
        
        switch gr.state {
        case .Began, .Changed:
            
            self.translation = gr.translationInView(self.view)
            
        default:
            
            break
            
        }
        
    }
    
    func didPinch(gr:UIPanGestureRecognizer) -> Void {
        
    }
    
    func didRotate(gr:UIPanGestureRecognizer) -> Void {
        
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
            
            
            
            //Constrain image to proper size.
            
            
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

















