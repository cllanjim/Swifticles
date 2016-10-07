//
//  RefreshSpiner.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/6/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class RefreshSpinner : UIView
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
        backgroundColor = UIColor.clear
    }
    
    private var _revealPercent: CGFloat = 0.0
    var revealPercent: CGFloat {
        set {
            _revealPercent = newValue
            var count:Int = 0
            if _revealPercent < 0.0 {
                _revealPercent = 0.0
                count = 0
            } else if _revealPercent > 1.0 {
                _revealPercent = 1.0
                count = spokeCount
            } else {
                count = Int(CGFloat(spokeCount) * _revealPercent)
            }
            
            //We don't need to redraw if the number of spokes didn't change.
            if count != _displaySpokeCount {
                _displaySpokeCount = count
                setNeedsDisplay()
            }
        }
        get {
            return _revealPercent
        }
    }
    
    private var _displaySpokeCount:Int = 0
    
    var spokeCount:Int = 10 { didSet { setNeedsDisplay() } }
    
    var thickness: CGFloat = 3.25 { didSet { setNeedsDisplay() } }
    
    var spokeInnerRadius:CGFloat = 10.0 { didSet { setNeedsDisplay() } }
    var spokeOuterRadius:CGFloat = 15.0 { didSet { setNeedsDisplay() } }
    
    var startRotation: CGFloat = 0.0
    
    
    
    override func draw(_ rect: CGRect) {
        
        //super.draw(rect)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        
        let displayCount = _displaySpokeCount
        
        for i in 0..<displayCount {
            let percent = CGFloat(i) / CGFloat(spokeCount)
            let rot = percent * Math.PI2 + startRotation
            
            let dir = CGPoint(x: sin(rot), y: -cos(rot))
            
            let p0 = CGPoint(x: center.x + dir.x * spokeInnerRadius, y: center.y + dir.y * spokeInnerRadius)
            let p1 = CGPoint(x: center.x + dir.x * spokeOuterRadius, y: center.y + dir.y * spokeOuterRadius)
            
            let path = UIBezierPath()
            path.addArc(withCenter: p1, radius: thickness / 2.0, startAngle: rot + Math.PI, endAngle: rot, clockwise: true)
            path.addArc(withCenter: p0, radius: thickness / 2.0, startAngle: rot, endAngle: rot - Math.PI, clockwise: true)
            path.close()
            
            context.addPath(path.cgPath)
            context.setFillColor(UIColor(red: 0.68, green: 0.68, blue: 0.68, alpha: 0.87).cgColor)
            context.fillPath()
            
        }
        context.restoreGState()
    }
}
