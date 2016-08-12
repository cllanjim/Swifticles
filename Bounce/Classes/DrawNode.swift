//
//  DrawNode.swift
//  Bounce
//
//  Created by Nicholas Raptis on 8/9/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class DrawNode {
    
    deinit {
        print("DrawNode.deinit()")
    }
    
    var x:CGFloat = 0.0
    var y:CGFloat = 0.0
    var z:CGFloat = 0.0
    
    var u:CGFloat = 0.0
    var v:CGFloat = 0.0
    var w:CGFloat = 0.0
    
    var r:CGFloat = 1.0
    var g:CGFloat = 1.0
    var b:CGFloat = 1.0
    var a:CGFloat = 1.0
}
