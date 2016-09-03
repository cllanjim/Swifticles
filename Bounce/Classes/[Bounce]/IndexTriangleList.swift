//
//  IndexTriangleList.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/2/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation

struct IndexTriangle {
    var x1:Int16 = 0
    var y1:Int16 = 0
    
    var x2:Int16 = 0
    var y2:Int16 = 0
    
    var x3:Int16 = 0
    var y3:Int16 = 0
}

class IndexTriangleList {
    
    var data = [IndexTriangle]()
    
    var count:Int {
        return _count
    }
    internal var _count:Int = 0
    
    func reset() {
        _count = 0
    }
    
    func add(x1 x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int) {
        
        if _count >= data.count {
            let newCapacity = _count + _count / 2 + 2
            data.reserveCapacity(newCapacity)
            
            while data.count <= newCapacity {
                
                data.append(IndexTriangle())
                
            }
        }
        
        data[_count].x1 = Int16(x1)
        data[_count].y1 = Int16(y1)
        data[_count].x2 = Int16(x2)
        data[_count].y2 = Int16(y2)
        data[_count].x3 = Int16(x3)
        data[_count].y3 = Int16(y3)
        
        _count += 1
    }
}

