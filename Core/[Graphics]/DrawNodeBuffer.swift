//
//  DrawNodeBuffer.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/7/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class DrawNodeBuffer {
    
    var count:Int { return _count }
    internal var _count:Int = 0
    
    var data = [DrawNode]()
    
    func reset() {
        _count = 0
    }
    
    func add(node:DrawNode) {
        set(index: count, node: node)
    }
    
    func ensureCapacity(_ capacity: Int) {
        if capacity >= data.count {
            let newCapacity = capacity + capacity / 2 + 1
            data.reserveCapacity(newCapacity)
            while data.count < newCapacity {
                data.append(DrawNode())
            }
        }
    }
    
    func set(index:Int, node:DrawNode) {
        guard index >= 0 else { return }
        ensureCapacity(index)
        if index >= _count { _count = index + 1 }
        data[index].set(drawNode: node)
    }
    
    func setXY(index:Int, x:CGFloat, y:CGFloat) {
        setXYZ(index:index, x: x, y: y, z: 0.0)
    }
    
    func setXYZ(index:Int, x:CGFloat, y:CGFloat, z:CGFloat) {
        guard index >= 0 else { return }
        ensureCapacity(index)
        if index >= _count { _count = index + 1 }
        data[index].x = x;data[index].y = y;data[index].z = z
    }
    
    func printData() {
        
        print("DrawNodeBuffer [\(count)] Elements [\(data.count)] Size [\(data.capacity)] Capacity\n*** *** ***")
        
        for i in 0..<count {
            
            let d = data[i]
            print("Node[\(i)] xyz(\(d.x),\(d.y),\(d.z)")
            
        }
        
        print("*** *** ***")
        
    }
    
}


