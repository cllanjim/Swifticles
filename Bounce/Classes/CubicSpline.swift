//
//  CubicSpline.swift
//  Bounce
//
//  Created by Nicholas Raptis on 8/22/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit


struct CubicSplineNode {
    var value:CGFloat = 0.0
    
    var delta:CGFloat = 0.0
    var derivative:CGFloat = 0.0
    
    var coefA:CGFloat = 0.0
    var coefB:CGFloat = 0.0
    var coefC:CGFloat = 0.0
}

class CubicSpline {
    
    init() {
        
    }
    
    deinit {
        
    }
    
    var x = [CubicSplineNode]()
    var y = [CubicSplineNode]()
    
    
    
    var maxPos:CGFloat {
        return CGFloat(maxIndex)
    }
    
    var maxIndex:Int {
        return x.count <= 1 ? 0 : (closed ? _controlPointCount : (_controlPointCount - 1))
    }
    
    
    var controlPointCount:Int {
        return _controlPointCount
    }
    
    func getControlPoint(index:Int) ->CGPoint {
        var point = CGPointZero
        
        if index >= 0 && index < x.count {
            point.x = x[index].value
            point.y = y[index].value
        }
        
        return point
    }
    
    var closed:Bool = false {
        didSet { refresh = true }
    }
    
    var linear:Bool = false {
        didSet { refresh = true }
    }
    
    func add(x:CGFloat, y:CGFloat) {
        set(_controlPointCount, x: x, y: y)
    }
    
    func reset() {
        _controlPointCount = 0
    }
    
    func clear() {
        reset()
        x.removeAll()
        y.removeAll()
    }
    
    func set(index:Int, x:CGFloat, y:CGFloat) {
        if index >= controlPointCount {
            _controlPointCount = index + 1
            let newCapacity = _controlPointCount + _controlPointCount / 2 + 1
            self.x.reserveCapacity(newCapacity)
            self.y.reserveCapacity(newCapacity)
            while self.x.count <= controlPointCount {
                self.x.append(CubicSplineNode())
                self.y.append(CubicSplineNode())
            }
        }
        
        self.x[index].value = x
        self.y[index].value = y
        
        refresh = true
    }
    
    func get(pos:CGFloat) -> CGPoint {
        var point = CGPointZero
        if controlPointCount > 1 {
            if refresh { compute() }
            if pos <= 0.0 {
                point.x = x[0].value
                point.y = y[0].value
            } else {
                let index:Int = Int(pos)
                let factor = pos - CGFloat(index)
                
                point.x = x[index].value + (((x[index].coefC * factor) + x[index].coefB) * factor + x[index].coefA) * factor
                point.y = y[index].value + (((y[index].coefC * factor) + y[index].coefB) * factor + y[index].coefA) * factor
            }
        } else if controlPointCount == 1 {
            point.x = x[0].value
            point.y = y[0].value
        }
        return point
    }
    
    internal var refresh:Bool = false
    internal var _controlPointCount:Int = 0
    
    internal func compute() {
        compute(coord: &x)
        compute(coord: &y)
        refresh = false
    }
    
    internal func compute(inout coord coord:[CubicSplineNode]) {
        
        guard controlPointCount >= 2 else { return }
        
        let count = controlPointCount
        let count1 = controlPointCount - 1
        let count2 = count1 - 1
        
        if controlPointCount == 2 || linear {
            var j = 0
            for i in 1..<count {
                coord[j].coefA = coord[i].value - coord[j].value
                coord[j].coefB = 0.0
                coord[j].coefC = 0.0
                j = i
            }
            if closed {
                coord[count1].coefA = coord[0].value - coord[count1].value
                coord[count1].coefB = 0.0
                coord[count1].coefC = 0.0
            }
        } else {
            if closed {
                coord[1].delta = 0.25
                coord[0].derivative = 0.25 * 3.0 * (coord[1].value - coord[count1].value);
                
                var G = CGFloat(1.0)
                var H = CGFloat(4.0)
                var F = 3.0 * (coord[0].value - coord[count2].value)
                
                for i in 1..<count1 {
                    coord[i+1].delta = -0.25 * coord[i].delta
                    coord[i].derivative = 0.25 * (3.0 * (coord[i+1].value - coord[i-1].value) - coord[i-1].derivative);
                    H = H - G * coord[i].delta;
                    F = F - G * coord[i-1].derivative;
                    G = (-0.25 * G)
                }
                H = H - (G + 1) * (0.25 + coord[count1].delta)
                
                coord[count1].derivative = F - (G + 1.0) * coord[count2].derivative
                coord[count1].derivative = coord[count1].derivative / H
                coord[count2].derivative = coord[count2].derivative - (0.25 + coord[count1].delta) * coord[count1].derivative
                
                for i in (count1-2).stride(to: 0, by: -1) {
                    coord[i].derivative = coord[i].derivative - 0.25 * coord[i + 1].derivative - coord[i + 1].delta * coord[count1].derivative
                }
                
                coord[count1].coefA = coord[count1].derivative
                coord[count1].coefB = 3.0 * (coord[0].value - coord[count1].value) - 2.0 * coord[count1].derivative - coord[0].derivative
                coord[count1].coefC = 2.0 * (coord[count1].value - coord[0].value) + coord[count1].derivative + coord[0].derivative
                
            } else {
                coord[0].delta = 3.0 * (coord[1].value - coord[0].value) * 0.25
                
                for i in 1..<count1 {
                    coord[i].delta = (3.0 * (coord[i+1].value - coord[i-1].value) - coord[i-1].delta) * 0.25
                }
                
                coord[count1].delta = (3.0 * (coord[count1].value - coord[count2].value) - coord[count2].delta) * 0.25
                coord[count1].derivative = coord[count1].delta
                
                for i in (count2).stride(to: 0, by: -1) {
                    coord[i].derivative = coord[i].delta - 0.25 * coord[i+1].derivative
                }
            }
            
            for i in 0..<count1 {
                coord[i].coefA = coord[i].derivative
                coord[i].coefB = 3.0 * (coord[i+1].value - coord[i].value) - 2.0 * coord[i].derivative - coord[i+1].derivative
                coord[i].coefC = 2.0 * (coord[i].value - coord[i+1].value) + coord[i].derivative + coord[i+1].derivative
            }
        }
    }
}



