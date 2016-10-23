//
//  TBSegmentButton.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/18/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation

//
//  RRButton.swift
//  SwiftFunhouse
//
//  Created by Raptis, Nicholas on 7/18/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class TBSegmentButton : RRButton {
    
    override var image: UIImage? {
        if isSelected || isPressed {
            if let img = imageDown {
                return img
            }
            if let img = imageUp {
                return img
            }
        } else {
            if let img = imageUp {
                return img
            }
            if let img = imageDown {
                return img
            }
        }
        return nil
    }
    
    override var isSelected: Bool { didSet { setNeedsDisplay() } }
    
}
