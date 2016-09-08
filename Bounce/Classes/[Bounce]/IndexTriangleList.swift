//
//  IndexTriangleList.swift
//
//  Created by Raptis, Nicholas on 9/2/16.
//

import Foundation

struct IndexTriangle {
    var i1:Int = 0
    //var y1:Int = 0
    
    var i2:Int = 0
    //var y2:Int = 0
    
    var i3:Int = 0
    //var y3:Int = 0
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
    
    func add(i1 i1:Int, i2:Int, i3:Int) {
        if _count >= data.count {
            let newCapacity = _count + _count / 2 + 1
            data.reserveCapacity(newCapacity)
            while data.count <= newCapacity {
                data.append(IndexTriangle())
            }
        }
        data[_count].i1 = i1
        data[_count].i2 = i2
        data[_count].i3 = i3
        _count += 1
    }
}

