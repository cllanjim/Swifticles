//
//  TBSegment.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/18/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

protocol TBSegmentDelegate
{
    func segmentSelected(segment:TBSegment, index: Int)
}

class TBSegment: UIView {
    
    var delegate:TBSegmentDelegate?
    
    var selectedIndex:Int? {
        willSet {
            if let index = selectedIndex where index >= 0 && index < buttons.count {
                buttons[index].styleSetSegment()
            }
        }
        didSet {
            if let index = selectedIndex where index >= 0 && index < buttons.count {
                buttons[index].styleSetSegmentSelected()
            }
        }
    }
    
    private var buttons = [RRButton]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    deinit {
        print("Dealloc TBSegment!!")
    }
    
    func clickSegment(segment:RRButton) {
        print("clickSegment")
        
        var checkIndex:Int?
        
        for i in 0..<buttons.count {
            if segment == buttons[i] {
                print("Click Seg Index \(i)")
                checkIndex = i
            }
        }
        
        if let index = checkIndex {
            
            selectedIndex = index
            delegate?.segmentSelected(self, index: index)
        }
        
        //delegate
        
    }
    
    var segmentCount:Int {
        
        get {
            return buttons.count
        }
        set {
            
            //arrayButtons
            for button:RRButton in buttons {
                button.removeFromSuperview()
                button.removeTarget(self, action: #selector(clickSegment(_:)), forControlEvents: .TouchUpInside)
            }
            buttons.removeAll()
            
            if newValue > 0 {
                for index in 0..<newValue {
                    let button = RRButton(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
                    buttons.append(button)
                    
                    if index <= 0 {
                        button.cornerUL = true
                        button.cornerDL = true
                        if newValue > 1 {
                            button.cornerUR = false
                            button.cornerDR = false
                        } else {
                            button.cornerUR = true
                            button.cornerDR = true
                        }
                    } else if index < (newValue - 1) {
                        button.cornerUL = false
                        button.cornerDL = false
                        button.cornerUR = false
                        button.cornerDR = false
                        
                    } else {
                        button.cornerUL = false
                        button.cornerDL = false
                        button.cornerUR = true
                        button.cornerDR = true
                    }
                    
                    
                    button.addTarget(self, action: #selector(clickSegment(_:)), forControlEvents:.TouchUpInside)
                    button.styleSetSegment()
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
                let button = buttons[index]
                
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
