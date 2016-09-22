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
    
    
    func setNeedsCompute() { needsCompute = true }
    internal var needsCompute:Bool = true
    
    
    func reset() {
        _count = 0
        setNeedsCompute()
    }
    
    func add(line:LineSegment) {
        set(index: count, p1: line.p1, p2: line.p2)
    }
    
    func set(index:Int, line:LineSegment) {
        set(index: index, p1: line.p1, p2: line.p2)
    }
    
    func add(p1:CGPoint, p2:CGPoint) {
        set(index: count, p1:p1, p2:p2)
    }
    
    func set(index:Int, p1:CGPoint, p2:CGPoint) {
        guard index >= 0 else { return }
        if index >= _count {
            _count = index + 1
            setNeedsCompute()
        }
        if index >= data.count {
            let newCapacity = data.count + data.count / 2 + 1
            data.reserveCapacity(newCapacity)
            while data.count < newCapacity {
                data.append(LineSegment())
            }
            setNeedsCompute()
        }
        
        if data[index].p1.x != p1.x || data[index].p1.y != p1.y {
            data[index].p1.x = p1.x
            data[index].p1.y = p1.y
            setNeedsCompute()
        }
        
        if data[index].p2.x != p2.x || data[index].p2.y != p2.y {
            data[index].p2.x = p2.x
            data[index].p2.y = p2.y
            setNeedsCompute()
        }
        
    }
    
    
    //bool TriangleIsClockwise(float pX1, float pY1, float pX2, float pY2, float pX3, float pY3)
    //{
    //return (pX2-pX1)*(pY3-pY2)-(pX3-pX2)*(pY2-pY1) > 0;
    //}
    
    
}


