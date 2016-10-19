//
//  Color.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/18/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class Color
{
    var r: CGFloat = 1.0
    var g: CGFloat = 1.0
    var b: CGFloat = 1.0
    var a: CGFloat = 1.0
    
    
    init() {
        
    }
    
    convenience init(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat) {
        self.init()
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    
    
}

extension Color: Equatable {
    static func == (lhs: Color, rhs: Color) -> Bool {
        return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.a
    }
}
