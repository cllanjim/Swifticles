//
//  DrawNode.swift
//
//  Created by Nicholas Raptis on 8/9/16.
//

import UIKit

class DrawNode {
    var x:CGFloat = 0.0
    var y:CGFloat = 0.0
    var z:CGFloat = 0.0
    var u:CGFloat = 0.0
    var v:CGFloat = 0.0
    var w:CGFloat = 0.0
    var r:CGFloat = 1.0
    var g:CGFloat = 1.0
    var b:CGFloat = 1.0
    var a:CGFloat = 1.0
    func set(drawNode:DrawNode) {
        x = drawNode.x;y = drawNode.y;z = drawNode.z
        u = drawNode.u;v = drawNode.v;w = drawNode.w
        r = drawNode.r;g = drawNode.g;b = drawNode.b;a = drawNode.a
    }
    func writeToTriangleList(_ t:inout [GLfloat], index:Int) {
        //let count = t.count
        t[index +  0] = GLfloat(x)
        t[index +  1] = GLfloat(y)
        t[index +  2] = GLfloat(z)
        t[index +  3] = GLfloat(u)
        t[index +  4] = GLfloat(v)
        t[index +  5] = GLfloat(w)
        t[index +  6] = GLfloat(r)
        t[index +  7] = GLfloat(g)
        t[index +  8] = GLfloat(b)
        t[index +  9] = GLfloat(a)
    }
    
    
}
