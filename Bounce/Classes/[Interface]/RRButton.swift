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
    
    var maxHeight: CGFloat?
    
    var cornerUL = true { didSet { setNeedsDisplay() } }
    var cornerUR = false { didSet { setNeedsDisplay() } }
    var cornerDR = true { didSet { setNeedsDisplay() } }
    var cornerDL = true { didSet { setNeedsDisplay() } }
    
    var fill:Bool = true { didSet { setNeedsDisplay() } }
    var fillDown:Bool = true { didSet { setNeedsDisplay() } }
    
    var fillColor:UIColor = UIColor(red: 0.45, green: 0.45, blue: 1.0, alpha: 1.0) { didSet { setNeedsDisplay() } }
    var fillColorDown:UIColor = UIColor(red: 0.65, green: 0.65, blue: 1.0, alpha: 1.0) { didSet { setNeedsDisplay() } }
    
    var stroke:Bool = true { didSet { setNeedsDisplay() } }
    var strokeDown:Bool = true { didSet { setNeedsDisplay() } }
    
    var strokeColor:UIColor = UIColor(red: 1.0, green: 1.0, blue: 0.75, alpha: 0.5) { didSet { setNeedsDisplay() } }
    var strokeColorDown:UIColor = UIColor(red: 0.86, green: 0.86, blue: 0.72, alpha: 0.5) { didSet { setNeedsDisplay() } }
    var strokeWidth:CGFloat = 4.0 { didSet { setNeedsDisplay() } }
    
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
        
        var drawStroke:Bool = false
        var drawFill:Bool = false
        
        if isPressed {
            if strokeDown { drawStroke = true }
            if fillDown { drawFill = true }
        } else {
            if stroke { drawStroke = true }
            if fill { drawFill = true }
        }
        if strokeWidth <= 0.0 { drawStroke = false }
        
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        var rect = CGRect(x: 0.0, y: 0.0, width: self.width, height: self.height)
        
        //context.setFillColor(UIColor.brown.cgColor)
        //context.fill(rect)
        
        if let max = maxHeight, rect.height > max {
            rect.size.height = max
            rect.origin.y = CGFloat(Int(self.height / 2.0 - max / 2.0))
        }
        
        if drawStroke {
            if drawFill {
                let clipPath = UIBezierPath(roundedRect: rect, byRoundingCorners: getCornerType(ul: cornerUL, ur: cornerUR, dr: cornerDR, dl: cornerDL), cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
                context.beginPath()
                context.addPath(clipPath)
                context.setFillColor((isPressed ? strokeColorDown : strokeColor).cgColor)
                context.closePath()
                context.fillPath()
                
                let inset = strokeWidth / 2.0
                rect = rect.insetBy(dx: inset, dy: inset)
            } else {
                
                let inset = strokeWidth / 2.0
                rect = rect.insetBy(dx: inset, dy: inset)
                
                let clipPath = UIBezierPath(roundedRect: rect, byRoundingCorners: getCornerType(ul: cornerUL, ur: cornerUR, dr: cornerDR, dl: cornerDL), cornerRadii: CGSize(width: cornerRadius - inset, height: cornerRadius - inset)).cgPath
                
                context.beginPath()
                context.addPath(clipPath)
                context.setStrokeColor((isPressed ? strokeColorDown : strokeColor).cgColor)
                context.setLineWidth(strokeWidth)
                context.closePath()
                context.strokePath()
            }
        }
        
        if drawFill {
            let clipPath = UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: getCornerType(ul: cornerUL, ur: cornerUR, dr: cornerDR, dl: cornerDL),
                                        cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            context.beginPath()
            context.addPath(clipPath)
            context.setFillColor(isPressed ? fillColorDown.cgColor : fillColor.cgColor)
            context.closePath()
            context.fillPath()
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
        strokeDown = true
        fillColor = styleColorSegmentFill
        strokeColor = styleColorSegmentStroke
        maxHeight = 38.0
    }
    
    func styleSetSegmentSelected() {
        fill = true
        fillDown = true
        stroke = false
        strokeDown = false
        fillColor = styleColorSegmentFillSelected
        strokeColor = styleColorSegmentStrokeSelected
        maxHeight = 38.0
    }
    
    func styleSetToolbarButton() {
        fill = false
        fillDown = true
        stroke = true
        strokeDown = false
        strokeWidth = 4.0
        //fillColor = UIColor.clear
        fillColorDown = styleColorToolbarButtonFillPressed
        strokeColor = styleColorSegmentStroke
        //strokeColorDown = UIColor.clear
        maxHeight = 42.0
    }
    
    func styleSetHomeMenuButton() {
        fill = true
        fillDown = true
        stroke = false
        strokeDown = true
        strokeWidth = 2.0
        fillColor = styleColorHomeMenuButtonBack
        fillColorDown = styleColorHomeMenuButtonBackDown
        strokeColor = styleColorSegmentStroke
        strokeColorDown = styleColorSegmentStroke
        maxHeight = nil
    }
    
}
