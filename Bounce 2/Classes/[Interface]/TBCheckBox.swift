//
//  RRButton.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/18/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

protocol TBCheckBoxDelegate
{
    func checkBoxToggled(checkBox:TBCheckBox, checked: Bool)
}

class TBCheckBox: RRButton {
    
    var delegate:TBCheckBoxDelegate?
    var checked:Bool = false { didSet { setNeedsDisplay() } }
    
    deinit {
        print("Deinit RRCheckBox")
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        
        
        let checkWidth = frame.size.height / 2.0
        let checkHeight = frame.size.height / 2.0
        
        let checkRect = CGRect(x: (frame.size.width - (checkWidth + (frame.size.height - checkHeight) / 2.0)), y: frame.size.height / 2.0 - checkHeight / 2.0, width: checkWidth, height: checkHeight)
        
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSaveGState(context)
        
        
            var rect = checkRect
            var clipPath = UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: getCornerType(ul: true, ur: true, dr: true, dl: true),
                                        cornerRadii: CGSize(width: 4.0, height: 20.0)).CGPath
            
            CGContextBeginPath(context)
            CGContextAddPath(context, clipPath)
            CGContextSetFillColorWithColor(context, styleColorSegmentFill.CGColor)
            CGContextClosePath(context)
            CGContextFillPath(context)
        
        
        if checked {
            rect = CGRectMake(checkRect.origin.x + strokeWidth / 2.0, checkRect.origin.y + strokeWidth / 2.0, checkRect.size.width - strokeWidth, checkRect.size.height - strokeWidth)
            clipPath = UIBezierPath(roundedRect: rect, byRoundingCorners: getCornerType(ul: true, ur: true, dr: true, dl: true), cornerRadii: CGSize(width: 20.0, height: 20.0)).CGPath
            
            CGContextBeginPath(context)
            CGContextAddPath(context, clipPath)
            CGContextSetStrokeColorWithColor(context, (isPressed ? strokeColorDown : strokeColor).CGColor)
            CGContextSetLineWidth(context, strokeWidth)
            CGContextClosePath(context)
            CGContextStrokePath(context)
        }
        
        CGContextRestoreGState(context)
    }
    
    override func didClick() {
        checked = !checked
        delegate?.checkBoxToggled(self, checked: checked)
    }
    
}
