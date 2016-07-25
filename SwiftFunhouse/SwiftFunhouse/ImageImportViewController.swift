//
//  ImageImportViewController.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/22/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ImageImportViewController: UIViewController {
    
    
    var image:UIImage? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var importScrollView: ImportScrollView?
    {
        didSet {
            
            if image != nil && importScrollView != nil {
                importScrollView!.image = image
            }
            
            
        }
    }
    
//    lazy weak var importScrollView:ImportScrollView? =  {
//        var isv:ImportScrollView? = ImportScrollView(frame: self.view.bounds)
//        self.view.addSubview(isv!)
//        return isv
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUp(image:UIImage?, screenSize:CGSize) {
        
        
        print("SetUp Img[\(image?.size.width)x\(image?.size.height)] Size[\(screenSize.width)x\(screenSize.height)]")
        
        
        //importScrollView?.image = image
        
        self.image = image
        
        
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

















