//
//  UIView+Extras.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/13/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    var x:CGFloat {
        return frame.origin.x
    }
    
    var y:CGFloat {
        return frame.origin.y
    }
    
    var width:CGFloat {
        return bounds.size.width
    }
    
    var height:CGFloat {
        return bounds.size.height
    }
    
    var isInstalled:Bool {
        if superview == nil {
            return false
        } else {
            return true
        }
    }
    
    
    
}
