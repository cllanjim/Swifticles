//
//  CubicSpline.swift
//
//  Created by Nicholas Raptis on 8/22/16.
//

import UIKit

struct CubicSplineNode {
    var value:CGFloat = 0.0
    var delta:CGFloat = 0.0
    var derivative:CGFloat = 0.0
    var coefA:CGFloat = 0.0
    var coefB:CGFloat = 0.0
    var coefC:CGFloat = 0.0
    
    func save() -> [String:AnyObject] {
        var info = [String:AnyObject]()
        info["value"] = Float(value) as AnyObject?
        info["delta"] = Float(delta) as AnyObject?
        info["derivative"] = Float(derivative) as AnyObject?
        info["coefA"] = Float(coefA) as AnyObject?
        info["coefB"] = Float(coefB) as AnyObject?
        info["coefC"] = Float(coefC) as AnyObject?
        return info
    }
    
    mutating func load(info:[String:AnyObject]) {
        if let _value = info["value"] as? Float { value = CGFloat(_value) }
        if let _delta = info["delta"] as? Float { delta = CGFloat(_delta) }
        if let _derivative = info["derivative"] as? Float { derivative = CGFloat(_derivative) }
        if let _coefA = info["coefA"] as? Float { coefA = CGFloat(_coefA) }
        if let _coefB = info["coefB"] as? Float { coefB = CGFloat(_coefB) }
        if let _coefC = info["coefC"] as? Float { coefC = CGFloat(_coefC) }
    }
}

class CubicSpline {
    
    init() { }
    deinit { }
    
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
    
    func getControlPoint(_ index:Int) ->CGPoint {
        var point = CGPoint.zero
        if index >= 0 && index < x.count {
            point.x = x[index].value
            point.y = y[index].value
        }
        return point
    }
    
    var closed:Bool = false {
        didSet { setNeedsCompute() }
    }
    
    var linear:Bool = false {
        didSet { setNeedsCompute() }
    }
    
    func add(_ x:CGFloat, y:CGFloat) {
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
    
    func set(_ index:Int, x:CGFloat, y:CGFloat) {
        if index >= controlPointCount { _controlPointCount = index + 1 }
        if index >= self.x.count {
            let newCapacity = _controlPointCount + _controlPointCount / 2 + 1
            self.x.reserveCapacity(newCapacity)
            self.y.reserveCapacity(newCapacity)
            while self.x.count < newCapacity {
                self.x.append(CubicSplineNode())
                self.y.append(CubicSplineNode())
            }
        }
        self.x[index].value = x
        self.y[index].value = y
        setNeedsCompute()
    }
    
    func get(_ pos:CGFloat) -> CGPoint {
        var point = CGPoint.zero
        if controlPointCount > 1 {
            if needsCompute { compute() }
            if pos <= 0.0 {
                point.x = x[0].value
                point.y = y[0].value
            } else {
                var index:Int = Int(pos)
                var factor = pos - CGFloat(index)
                if index < 0 {
                    index = 0
                    factor = 0.0
                } else if index >= _controlPointCount {
                    index = _controlPointCount - 1
                    factor = 1.0
                }
                
                // c * p^3 + b * p^2 + a * p + x
                point.x = x[index].value + (((x[index].coefC * factor) + x[index].coefB) * factor + x[index].coefA) * factor
                point.y = y[index].value + (((y[index].coefC * factor) + y[index].coefB) * factor + y[index].coefA) * factor
            }
        } else if controlPointCount == 1 {
            point.x = x[0].value
            point.y = y[0].value
        }
        return point
    }
    
    func getClosestControlPoint(point:CGPoint) -> (index:Int, distance:CGFloat)? {
        if controlPointCount > 0 {
            var diffX = point.x - x[0].value
            var diffY = point.y - y[0].value
            var bestDist = diffX * diffX + diffY * diffY
            var bestIndex = 0
            for i in 1..<controlPointCount {
                diffX = x[i].value - point.x
                diffY = y[i].value - point.y
                let dist = diffX * diffX + diffY * diffY
                if dist < bestDist {
                    bestDist = dist
                    bestIndex = i
                }
            }
            if bestDist > Math.epsilon { bestDist = CGFloat(sqrtf(Float(bestDist))) }
            return (bestIndex, bestDist)
        }
        return nil
    }
    
    
    func setNeedsCompute() { needsCompute = true }
    internal var needsCompute:Bool = true
    //internal var refresh:Bool = false
    
    internal var _controlPointCount:Int = 0
    
    internal func compute() {
        compute(coord: &x)
        compute(coord: &y)
        needsCompute = false
    }
    
    //Find cubic coefficients for a particular coordinate.
    internal func compute(coord:inout [CubicSplineNode]) {
        guard controlPointCount >= 2 else { return }
        let count = controlPointCount
        let count1 = controlPointCount - 1
        let count2 = count1 - 1
        if controlPointCount == 2 || linear {
            //Solve linear coefficients.
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
                //compute derivatives for closed / circular natural cubic spline.
                coord[1].delta = 0.25
                coord[0].derivative = 0.25 * 3.0 * (coord[1].value - coord[count1].value)
                var G = CGFloat(1.0)
                var H = CGFloat(4.0)
                var F = 3.0 * (coord[0].value - coord[count2].value)
                for i in 1..<count1 {
                    coord[i+1].delta = -0.25 * coord[i].delta
                    coord[i].derivative = 0.25 * (3.0 * (coord[i+1].value - coord[i-1].value) - coord[i-1].derivative)
                    H = H - G * coord[i].delta
                    F = F - G * coord[i-1].derivative
                    G = (-0.25 * G)
                }
                H = H - (G + 1) * (0.25 + coord[count1].delta)
                coord[count1].derivative = F - (G + 1.0) * coord[count2].derivative
                coord[count1].derivative = coord[count1].derivative / H
                coord[count2].derivative = coord[count2].derivative - (0.25 + coord[count1].delta) * coord[count1].derivative
                for i:Int in stride(from: (count1-2), to: -1, by: -1) {
                    coord[i].derivative = coord[i].derivative - 0.25 * coord[i + 1].derivative - coord[i + 1].delta * coord[count1].derivative
                }
                coord[count1].coefA = coord[count1].derivative
                coord[count1].coefB = 3.0 * (coord[0].value - coord[count1].value) - 2.0 * coord[count1].derivative - coord[0].derivative
                coord[count1].coefC = 2.0 * (coord[count1].value - coord[0].value) + coord[count1].derivative + coord[0].derivative
            } else {
                 //compute derivatives for natural cubic spline.
                coord[0].delta = 3.0 * (coord[1].value - coord[0].value) * 0.25
                for i in 1..<count1 {
                    coord[i].delta = (3.0 * (coord[i+1].value - coord[i-1].value) - coord[i-1].delta) * 0.25
                }
                coord[count1].delta = (3.0 * (coord[count1].value - coord[count2].value) - coord[count2].delta) * 0.25
                coord[count1].derivative = coord[count1].delta
                for i:Int in stride(from: (count2), to: -1, by: -1) {
                    coord[i].derivative = coord[i].delta - 0.25 * coord[i+1].derivative
                }
            }
            
            //Find the coefficients.
            for i in 0..<count1 {
                coord[i].coefA = coord[i].derivative
                coord[i].coefB = 3.0 * (coord[i+1].value - coord[i].value) - 2.0 * coord[i].derivative - coord[i+1].derivative
                coord[i].coefC = 2.0 * (coord[i].value - coord[i+1].value) + coord[i].derivative + coord[i+1].derivative
            }
        }
    }
    
    func clone() -> CubicSpline {
        let result = CubicSpline()
        result.linear = linear
        result.closed = closed
        //for i in 0..<controlPointCount {
        
        for i:Int in stride(from: (controlPointCount - 1), to: -1, by: -1) {
            result.set(i, x: x[i].value, y: y[i].value)
        }
            
        return result
    }
    
    //Save to dictionary.
    func save() -> [String:AnyObject] {
        var info = [String:AnyObject]()
        info["closed"] = closed as AnyObject?
        info["linear"] = linear as AnyObject?
        var splineDataX = [[String:AnyObject]]()
        var splineDataY = [[String:AnyObject]]()
        for i in 0..<controlPointCount {
            splineDataX.append(x[i].save())
            splineDataY.append(y[i].save())
        }
        info["coord_x"] = splineDataX as AnyObject?
        info["coord_y"] = splineDataY as AnyObject?
        return info
    }
    
    //Load from dictionary.
    func load(info:[String:AnyObject]) {
        clear()
        if let _closed = info["closed"] as? Bool { closed = _closed }
        if let _linear = info["linear"] as? Bool { linear = _linear }
        if let splineDataX = info["coord_x"] as? [[String:AnyObject]],  let splineDataY = info["coord_y"] as? [[String:AnyObject]] {
            if splineDataX.count == splineDataY.count {
                for _ in 0..<splineDataX.count {
                    add(0.0, y: 0.0)
                }
                for i in 0..<splineDataX.count {
                    x[i].load(info: splineDataX[i])
                    y[i].load(info: splineDataY[i])
                }
            }
        }
        setNeedsCompute()
    }
}



