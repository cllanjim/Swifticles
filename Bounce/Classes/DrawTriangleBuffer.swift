//
//  DrawTriangleBuffer.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/9/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//


import UIKit

class DrawTriangleBuffer {
    
    var t = [DrawTriangle]()
    var i = [IndexBufferType]()
    
    init() {
        
    }
    
    func add(triangle triangle:DrawTriangle) {
        
        t.append(triangle)
        
    }
    
    
}