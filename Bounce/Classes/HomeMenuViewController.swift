//
//  HomeMenuViewController.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/18/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class HomeMenuViewController: UIViewController {

    @IBOutlet weak var imageViewBackground: UIImageView!
    
    @IBOutlet weak var buttonCreate: RRButton!
    
    @IBOutlet weak var buttonLoad: RRButton!
    
    @IBOutlet weak var buttonContinue: RRButton!
    
    @IBOutlet weak var buttonUpgrade: RRButton!
    
    @IBOutlet weak var cloudTest: RRButton!
    
    @IBOutlet weak var glTest: RRButton!
    
    
    
    var animator:UIDynamicAnimator?
    
    var attachmentBehavior:UIAttachmentBehavior?
    
    override func viewDidLoad() {

        self.performSegueWithIdentifier("bounce", sender: nil)
        
        //bounce
        
    }
    
    @IBAction func testPush(sender: UIButton) {
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        print("viewWillTransitionToSize")
        print("coord \(coordinator)")
        print("size \(size.width)x\(size.height)")
        print("~~~~~~~")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "image_import" {
            
        }
        
        if segue.identifier == "image_import" {
            
            let testImage = UIImage(named: "test_image.jpg")
            
            if let importer = segue.destinationViewController as? ImageImportViewController {
                
                importer.setUp(testImage, screenSize: self.view.bounds.size)
            
            }
        }
    }
    
    @IBAction func clickCreate(sender: UIButton) {
        self.performSegueWithIdentifier("bounce", sender: nil)
    }
    
    @IBAction func clickLoad(sender: AnyObject) {
        
        self.performSegueWithIdentifier("bounce", sender: nil)
    }
    
    @IBAction func clickUpgrade(sender: AnyObject) {
    
        self.performSegueWithIdentifier("bounce", sender: nil)
    }
    
    
    deinit {
        print("Deinit \(self)")
    }
    
}
