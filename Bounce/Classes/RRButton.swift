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
    
    var cornerUL = true { didSet { setNeedsDisplay() } }
    var cornerUR = false { didSet { setNeedsDisplay() } }
    var cornerDR = true { didSet { setNeedsDisplay() } }
    var cornerDL = true { didSet { setNeedsDisplay() } }
    
    var fillColor:UIColor = UIColor(red: 0.45, green: 0.45, blue: 1.0, alpha: 1.0) { didSet { setNeedsDisplay() } }
    var fillColorDown:UIColor = UIColor(red: 0.65, green: 0.65, blue: 1.0, alpha: 1.0) { didSet { setNeedsDisplay() } }
    
    var strokeColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 0.75, alpha: 1.0) { didSet { setNeedsDisplay() } }
    var strokeColorDown:UIColor = UIColor(red: 0.86, green: 0.86, blue: 0.72, alpha: 1.0) { didSet { setNeedsDisplay() } }
    
    
    var isPressed:Bool { return touchInside && tracking }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    deinit {
        print("Deinit RRButton")
    }
    
    func setUp() {
        self.backgroundColor = UIColor.clearColor()
        
        
        self.addTarget(self, action: #selector(didToggleControlState), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(didToggleControlState), forControlEvents: .TouchDragInside)
        self.addTarget(self, action: #selector(didToggleControlState), forControlEvents: .TouchDragOutside)
        self.addTarget(self, action: #selector(didToggleControlState), forControlEvents: .TouchCancel)
        self.addTarget(self, action: #selector(didToggleControlState), forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(didToggleControlState), forControlEvents: .TouchUpOutside)
        
        
        
        
        
        
        
        //[self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        //[self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        //[self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
    }
    
    func getCornerType(ul:Bool, ur:Bool, dr:Bool, dl:Bool) -> UIRectCorner {
        var result:UIRectCorner = UIRectCorner(rawValue: 0)
        if ul == true {result = result.union(UIRectCorner.TopLeft)}
        if ur == true {result = result.union(UIRectCorner.TopRight)}
        if dr == true {result = result.union(UIRectCorner.BottomRight)}
        if dl == true {result = result.union(UIRectCorner.BottomLeft)}
        return result;
    }
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSaveGState(ctx)
        
        let rect = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
        let clipPath = UIBezierPath(roundedRect: rect, byRoundingCorners: getCornerType(cornerUL, ur: cornerUR, dr: cornerDR, dl: cornerDL), cornerRadii: CGSize(width: 12.0, height: 12.0)).CGPath
        
        CGContextAddPath(ctx, clipPath)
        
        //fillColor
        
        if isPressed {
            CGContextSetFillColorWithColor(ctx, fillColorDown.CGColor)
        } else {
            CGContextSetFillColorWithColor(ctx, fillColor.CGColor)
        }
        CGContextClosePath(ctx)
        CGContextFillPath(ctx)
        
        
        if isPressed {
            CGContextSetStrokeColorWithColor(ctx, strokeColorDown.CGColor)
        } else {
            CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor)
        }
        CGContextSetLineWidth(ctx, 8.0)
        CGContextStrokePath(ctx)
        
        CGContextRestoreGState(ctx)
    }
    
    func didToggleControlState() {
        //self.backgroundColor = fillColorDown
        self.setNeedsDisplay()
    }
    
    func didRelease() {
        
    }
    
}
