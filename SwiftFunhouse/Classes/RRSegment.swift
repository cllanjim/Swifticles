//
//  RRSegment.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/18/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class RRSegment: UIView {
    
    private var arrayButtons = [RRButton]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
        //self.backgroundColor = UIColor.clearColor()
        
    }
    
    func clickSegment(segment:RRButton) {
        print("clickSegment")
        
    }
    
    var segmentCount:Int {
        
        get {
            return arrayButtons.count
        }
        set {
            
            //arrayButtons
            for button:RRButton in arrayButtons {
                button.removeFromSuperview()
                button.removeTarget(self, action: #selector(clickSegment(_:)), forControlEvents: .TouchUpInside)
            }
            arrayButtons.removeAll()
            
            if newValue > 0 {
                for _ in 0..<newValue {
                    
                    let button = RRButton(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
                    arrayButtons.append(button)
                    
                    //#selector(FaceView.changeScale(_:))
                    
                    
                    var sel = #selector(clickSegment(_:))
                    button.addTarget(self, action: #selector(clickSegment(_:)), forControlEvents:.TouchUpInside)
                    
                    addSubview(button)
                }
            }
            
            layoutButtons()
            
        }
        
    }
    
    private func layoutButtons() {
        
        if segmentCount > 0 {
            
            let stride = Int(Double(self.frame.size.width) / Double(segmentCount))
            
            var left = 0.0
            var right = left + Double(stride)
            
            for index in 0..<segmentCount {
                let button = arrayButtons[index]
                
                if index == (segmentCount - 1) {
                    right = Double(self.frame.size.width)
                }
                
                button.frame = CGRect(x: CGFloat(left), y: 0, width: CGFloat(right - left), height: self.frame.size.height)
                
                button.setNeedsDisplay()
                
                left = right
                right += Double(stride)
            }
        }
    }
    
    internal override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layoutButtons()
        
    }
    
}
