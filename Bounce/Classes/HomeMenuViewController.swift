//
//  HomeMenuViewController.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/18/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class HomeMenuViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var animator:UIDynamicAnimator?
    
    var attachmentBehavior:UIAttachmentBehavior?
    
    override func viewDidLoad() {

        //self.
        //performSegueWithIdentifier("image_import", sender: nil)
    }
    
    @IBAction func testPush(sender: UIButton) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "image_import" {
            
            let testImage = UIImage(named: "test_image.jpg")
            
            if let importer = segue.destinationViewController as? ImageImportViewController {
                
                importer.setUp(testImage, screenSize: self.view.bounds.size)
            
            }
        }
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
