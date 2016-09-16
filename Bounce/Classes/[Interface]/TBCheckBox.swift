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
        
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        
        
        let checkWidth = frame.size.height / 2.0
        let checkHeight = frame.size.height / 2.0
        
        let checkRect = CGRect(x: (frame.size.width - (checkWidth + (frame.size.height - checkHeight) / 2.0)), y: frame.size.height / 2.0 - checkHeight / 2.0, width: checkWidth, height: checkHeight)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        
            var rect = checkRect
            var clipPath = UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: getCornerType(ul: true, ur: true, dr: true, dl: true),
                                        cornerRadii: CGSize(width: 4.0, height: 20.0)).cgPath
            
            context.beginPath()
            context.addPath(clipPath)
            context.setFillColor(styleColorSegmentFill.cgColor)
            context.closePath()
            context.fillPath()
        
        
        if checked {
            rect = CGRect(x: checkRect.origin.x + strokeWidth / 2.0, y: checkRect.origin.y + strokeWidth / 2.0, width: checkRect.size.width - strokeWidth, height: checkRect.size.height - strokeWidth)
            clipPath = UIBezierPath(roundedRect: rect, byRoundingCorners: getCornerType(ul: true, ur: true, dr: true, dl: true), cornerRadii: CGSize(width: 20.0, height: 20.0)).cgPath
            
            context.beginPath()
            context.addPath(clipPath)
            context.setStrokeColor((isPressed ? strokeColorDown : strokeColor).cgColor)
            context.setLineWidth(strokeWidth)
            context.closePath()
            context.strokePath()
        }
        
        context.restoreGState()
    }
    
    override func didClick() {
        checked = !checked
        delegate?.checkBoxToggled(checkBox: self, checked: checked)
    }
    
}
