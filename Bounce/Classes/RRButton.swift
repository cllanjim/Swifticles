//
//  RRButton.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/18/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class RRButton: UIButton {
    
    //var fill =
    
    var drawUL = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var drawUR = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var drawDR = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var drawDL = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    func setUp() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    func getCornerType(ul:Bool, ur:Bool, dr:Bool, dl:Bool) -> UIRectCorner
    {
        var aReturn:UIRectCorner = UIRectCorner(rawValue: 0)
        if ul == true {aReturn = aReturn.union(UIRectCorner.TopLeft)}
        if ur == true {aReturn = aReturn.union(UIRectCorner.TopRight)}
        if dr == true {aReturn = aReturn.union(UIRectCorner.BottomRight)}
        if dl == true {aReturn = aReturn.union(UIRectCorner.BottomLeft)}
        return aReturn;
    }
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSaveGState(ctx)
        
        let rect = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
        let clipPath = UIBezierPath(roundedRect: rect, byRoundingCorners: getCornerType(drawUL, ur: drawUR, dr: drawDR, dl: drawDL), cornerRadii: CGSize(width: 16.0, height: 32.0)).CGPath
        
        CGContextAddPath(ctx, clipPath)
        CGContextSetFillColorWithColor(ctx, UIColor.redColor().CGColor)
        
        CGContextClosePath(ctx)
        CGContextFillPath(ctx)
        CGContextRestoreGState(ctx)
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
