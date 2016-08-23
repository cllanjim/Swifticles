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
    //var z:CGFloat
    
    var coefA:CGFloat = 0.0
    var coefB:CGFloat = 0.0
    var coefC:CGFloat = 0.0
    var coefD:CGFloat = 0.0
    
    var tan:CGFloat = 0.0
}

class CubicSpline {
    
    init() {
        
    }
    
    deinit {
        
    }
    
    var x = [CubicSplineNode]()
    var y = [CubicSplineNode]()
    
    internal var refresh:Bool = false
    
    var max:CGFloat {
        return x.count <= 1 ? 0.0 : (closed ? CGFloat(x.count) : CGFloat(x.count - 1))
    }
    
    var controlPointCount:Int {
        return x.count
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
    
    func add(x:CGFloat, y:CGFloat) {
        var xNode = CubicSplineNode()
        xNode.value = x
        self.x.append(xNode)
        
        var yNode = CubicSplineNode()
        yNode.value = y
        self.y.append(yNode)
        
        refresh = true
    }
    
    func set(index:Int, x:CGFloat, y:CGFloat) {
        
    }
    
    func get(pos:CGFloat) -> CGPoint {
        
        if refresh { compute() }
        
        
        var point = CGPointZero
        
        return point
    }
    
    internal func compute() {
        
        
        
        refresh = false
    }
    
    
}



