//
//  StylePickerButton.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class StylePickerButton : UIButton
{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp() {
        //backgroundColor = UIColor.clear
        //layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
    }
    
    var isOdd: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()

        
    }
    
}











