//
//  LineBuffer.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/7/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class LineSegmentBuffer {
    
    var count:Int { return _count }
    internal var _count:Int = 0
    
    var data = [LineSegment]()
    
    func reset() {
        _count = 0
    }
    
    func add(line line:LineSegment) {
        set(index: count, p1: line.p1, p2: line.p2)
    }
    
    func set(index index:Int, line:LineSegment) {
        set(index: index, p1: line.p1, p2: line.p2)
    }
    
    func add(p1 p1:CGPoint, p2:CGPoint) {
        set(index: count, p1:p1, p2:p2)
    }
    
    func set(index index:Int, p1:CGPoint, p2:CGPoint) {
        guard index >= 0 else { return }
        if index >= _count {
            _count = index + 1
        }
        if index >= data.count {
            let newCapacity = data.count + data.count / 2 + 1
            data.reserveCapacity(newCapacity)
            while data.count < newCapacity {
                data.append(LineSegment())
            }
        }
        data[index].p1 = p1
        data[index].p2 = p2
    }
}


