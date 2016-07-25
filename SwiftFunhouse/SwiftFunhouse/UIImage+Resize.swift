//
//  UIImage+Resize.swift
//  SwiftFunhouse
//
//  Created by Nicholas Raptis on 7/24/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(size:CGSize) -> UIImage? {
        if size.width > 0 && self.size.width > 0 && size.height > 0 && self.size.height > 0 {
            UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
            drawInRect(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            return result;
        }
        return nil
    }
    
    
    
}