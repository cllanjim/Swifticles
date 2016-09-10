//
//  Geometry.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/10/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class Math {
    
    static let PI:CGFloat = 3.1415926535897932384626433832795028841968
    static let PI2:CGFloat = (2 * PI)
    static let PI_2:CGFloat = (PI / 2)
    static let D_R:CGFloat = 0.01745329251994329576923690768488
    static let R_D:CGFloat = 57.2957795130823208767981548141052
    
    static let epsilon:CGFloat = 0.01
    
    class func sind(_ degrees:CGFloat) -> CGFloat {
        return CGFloat(sin(Double(degrees * D_R)))
    }
    
    class func cosd(_ degrees:CGFloat) -> CGFloat {
        return CGFloat(cos(Double(degrees * D_R)))
    }
    
    class func dist(p1:CGPoint, p2:CGPoint) -> CGFloat {
        let diffX = p1.x - p2.x
        let diffY = p1.y - p2.y
        var dist = diffX * diffX + diffY * diffY
        if dist > 0.01 {
            dist = CGFloat(sqrtf(Float(dist)))
        }
        return dist
    }
    
    class func dotProduct(p1:CGPoint, p2:CGPoint) -> CGFloat {
        return p1.x * p2.x + p1.y * p2.y
    }
    
    class func crossProduct(p1:CGPoint, p2:CGPoint) -> CGFloat {
        return p1.x * p2.y - p2.x * p1.y
    }
    
    class func dotProduct(x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat) -> CGFloat {
        return x1 * x2 + y1 * y2
    }
    
    class func crossProduct(x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat) -> CGFloat {
        return x1 * y2 - x2 * y1
    }
    
    
}

