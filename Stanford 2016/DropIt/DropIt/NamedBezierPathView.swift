//
//  NamedBezierPathView.swift
//  DropIt
//
//  Created by Raptis, Nicholas on 7/21/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class NamedBezierPathView: UIView {

    var bezierPaths = [String:UIBezierPath]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        for (_,path) in bezierPaths {
            path.stroke()
        }
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
