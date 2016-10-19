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
    
    var color = Color() {
        willSet {
            if(newValue != color) {
                setNeedsCompute()
            }
        }
    }
    
    
    var thickness: CGFloat = 1.25 {
        willSet {
            if(newValue != thickness) {
                setNeedsCompute()
            }
        }
    }
    
    private var _drawBuffer: DrawTriangleBuffer?
    var drawBuffer:DrawTriangleBuffer {
        if _drawBuffer == nil {
            _drawBuffer = DrawTriangleBuffer()
        }
        return _drawBuffer!
    }
    
    private var _triangle = DrawTriangle()
    
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
    
    func compute() {
        let buffer = drawBuffer
        buffer.reset()
        if count >= 3 {
            
            _triangle.setColor(color: color)
            
            var nodeIndex:Int = 0
            var index2:Int = count - 1
            for index1 in 0..<count {
                
                let p1 = data[index2].p1
                let p2 = data[index2].p2
                let p3 = data[index1].p2
                
                var dx1 = p2.x - p1.x
                var dy1 = p2.y - p1.y
                var len1 = dx1 * dx1 + dy1 * dy1
                
                var dx2 = p3.x - p2.x
                var dy2 = p3.y - p2.y
                var len2 = dx2 * dx2 + dy2 * dy2
                
                let area = (p2.x - p1.x) * (p3.y - p2.y) - (p3.x - p2.x) * (p2.y - p1.y)
                let isClockwise = (area > 0.0)
                
                if len1 > Math.epsilon && len2 > Math.epsilon {
                    len1 = CGFloat(sqrtf(Float(len1)))
                    dx1 /= len1
                    dy1 /= len1
                    
                    len2 = CGFloat(sqrtf(Float(len2)))
                    dx2 /= len2
                    dy2 /= len2
                    
                    let nx1 = -dy1
                    let ny1 = dx1
                    
                    let nx2 = -dy2
                    let ny2 = dx2
                    
                    var c1 = CGPoint(x: p2.x + nx1 * thickness, y: p2.y + ny1 * thickness)
                    var c2 = CGPoint(x: p2.x - nx1 * thickness, y: p2.y - ny1 * thickness)
                    var c3 = CGPoint(x: p2.x + nx2 * thickness, y: p2.y + ny2 * thickness)
                    var c4 = CGPoint(x: p2.x - nx2 * thickness, y: p2.y - ny2 * thickness)
                    
                    if isClockwise == false {
                        _triangle.node1.point = c1
                        _triangle.node2.point = c2
                        _triangle.node3.point = c3
                        
                        buffer.set(index: nodeIndex, triangle: _triangle)
                        nodeIndex = nodeIndex + 1
                        
                        _triangle.node1.point = c1
                        _triangle.node2.point = c2
                        _triangle.node3.point = c4
                        
                        buffer.set(index: nodeIndex, triangle: _triangle)
                        nodeIndex = nodeIndex + 1
                        
                    } else {
                        _triangle.node1.point = c1
                        _triangle.node2.point = c4
                        _triangle.node3.point = c3
                        
                        buffer.set(index: nodeIndex, triangle: _triangle)
                        nodeIndex = nodeIndex + 1
                        
                        _triangle.node1.point = c2
                        _triangle.node2.point = c3
                        _triangle.node3.point = c4
                        
                        buffer.set(index: nodeIndex, triangle: _triangle)
                        nodeIndex = nodeIndex + 1
                    }
                    
                    c1 = CGPoint(x: p1.x + nx1 * thickness, y: p1.y + ny1 * thickness)
                    c2 = CGPoint(x: p1.x - nx1 * thickness, y: p1.y - ny1 * thickness)
                    c3 = CGPoint(x: p2.x + nx1 * thickness, y: p2.y + ny1 * thickness)
                    c4 = CGPoint(x: p2.x - nx1 * thickness, y: p2.y - ny1 * thickness)
                    
                    _triangle.node1.point = c1
                    _triangle.node2.point = c2
                    _triangle.node3.point = c3
                    
                    buffer.set(index: nodeIndex, triangle: _triangle)
                    nodeIndex = nodeIndex + 1
                    
                    _triangle.node1.point = c2
                    _triangle.node2.point = c3
                    _triangle.node3.point = c4
                    
                    buffer.set(index: nodeIndex, triangle: _triangle)
                    nodeIndex = nodeIndex + 1
                }
                
                index2 = index1
            }
        }
        needsCompute = false
    }
    
    func draw() {
        if needsCompute { compute() }
        drawBuffer.draw(texture: nil)
    }
}


