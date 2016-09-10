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
    
    var fill:Bool = true { didSet { setNeedsDisplay() } }
    var fillColor:UIColor = UIColor(red: 0.45, green: 0.45, blue: 1.0, alpha: 1.0) { didSet { setNeedsDisplay() } }
    var fillColorDown:UIColor = UIColor(red: 0.65, green: 0.65, blue: 1.0, alpha: 1.0) { didSet { setNeedsDisplay() } }
    
    var stroke:Bool = true { didSet { setNeedsDisplay() } }
    var strokeColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 0.75, alpha: 1.0) { didSet { setNeedsDisplay() } }
    var strokeColorDown:UIColor = UIColor(red: 0.86, green: 0.86, blue: 0.72, alpha: 1.0) { didSet { setNeedsDisplay() } }
    var strokeWidth:CGFloat = 3.0 { didSet { setNeedsDisplay() } }
    
    var cornerRadius:CGFloat = 6.0 { didSet { setNeedsDisplay() } }
    
    
    
    var isPressed:Bool { return isTouchInside && isTracking }
    
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
        self.backgroundColor = UIColor.clear
        
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchDown)
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchDragInside)
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchDragOutside)
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchCancel)
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchUpInside)
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchUpOutside)
        
        self.addTarget(self, action: #selector(didClick), for: .touchUpInside)
        
    }
    
    func getCornerType(ul:Bool, ur:Bool, dr:Bool, dl:Bool) -> UIRectCorner {
        var result:UIRectCorner = UIRectCorner(rawValue: 0)
        if ul == true {result = result.union(UIRectCorner.topLeft)}
        if ur == true {result = result.union(UIRectCorner.topRight)}
        if dr == true {result = result.union(UIRectCorner.bottomRight)}
        if dl == true {result = result.union(UIRectCorner.bottomLeft)}
        return result;
    }
    
    override func draw(_ rect: CGRect) {
        
        //super.drawRect(rect)
        
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        
        if fill {
        let rect = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        let clipPath = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: getCornerType(ul: cornerUL, ur: cornerUR, dr: cornerDR, dl: cornerDL),
                                        cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        
        context.beginPath()
        context.addPath(clipPath)
        context.setFillColor(isPressed ? fillColorDown.cgColor : fillColor.cgColor)
        context.closePath()
        context.fillPath()
        }
        
        if stroke {
        let rect = CGRect(x: strokeWidth / 2.0, y: strokeWidth / 2.0, width: self.frame.size.width - strokeWidth, height: self.frame.size.height - strokeWidth)
            let clipPath = UIBezierPath(roundedRect: rect, byRoundingCorners: getCornerType(ul: cornerUL, ur: cornerUR, dr: cornerDR, dl: cornerDL), cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        
        context.beginPath()
        context.addPath(clipPath)
        context.setStrokeColor((isPressed ? strokeColorDown : strokeColor).cgColor)
        context.setLineWidth(strokeWidth)
        context.closePath()
        context.strokePath()
            
        }
        
        context.restoreGState()
    }
    
    func didToggleControlState() {
        self.setNeedsDisplay()
    }
    
    func didClick() {
    
    }
    
    func styleSetSegment() {
        fill = true
        stroke = true
        fillColor = styleColorSegmentFill
        strokeColor = styleColorSegmentStroke
    }
    
    func styleSetSegmentSelected() {
        fill = true
        stroke = false
        fillColor = styleColorSegmentFillSelected
        strokeColor = styleColorSegmentStrokeSelected
    }
    
    
    
    
}
