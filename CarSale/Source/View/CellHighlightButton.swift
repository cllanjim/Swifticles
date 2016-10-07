//
//  CellHighlightButton.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/3/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class CellHighlightButton : UIButton {
    
    var isPressed:Bool { return isTouchInside && isTracking }
    
    var highlightR: CGFloat = 1.0
    var highlightG: CGFloat = 1.0
    var highlightB: CGFloat = 1.0
    var highlightA: CGFloat = 0.0
    
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
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchDown)
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchDragInside)
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchDragOutside)
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchCancel)
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchUpInside)
        self.addTarget(self, action: #selector(didToggleControlState), for: .touchUpOutside)
        self.backgroundColor = UIColor(red: highlightR, green: highlightG, blue: highlightB, alpha: highlightA)
    }
    
    func didToggleControlState() {
        if isPressed {
            if highlightA == 0.0 {
                highlightA = 0.6
                UIView.animate(withDuration: 0.32, animations: { [weak weakSelf = self] in
                    if let checkSelf = weakSelf {
                        checkSelf.backgroundColor = UIColor(red: checkSelf.highlightR, green: checkSelf.highlightG, blue: checkSelf.highlightB, alpha: checkSelf.highlightA)
                    }
                    })
            }
        } else {
            if highlightA != 0.0 {
                highlightA = 0.0
                UIView.animate(withDuration: 0.32, animations: { [weak weakSelf = self] in
                    if let checkSelf = weakSelf {
                        checkSelf.backgroundColor = UIColor(red: checkSelf.highlightR, green: checkSelf.highlightG, blue: checkSelf.highlightB, alpha: checkSelf.highlightA)
                    }
                    })
            }
        }
    }
}

