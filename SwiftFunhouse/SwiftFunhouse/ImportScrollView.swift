//
//  ImportScrollView.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/22/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ImportScrollView: UIScrollView {
    
    @IBOutlet weak var imageView:UIImageView?
    
    var image:UIImage? {
        
        //test_image
        
        get {
            return imageView?.image
        }
        set {
            
            print("fit this image for importing... \(newValue?.size.width), \(newValue?.size.height)")
            
        }
        
    }
    
    
}
