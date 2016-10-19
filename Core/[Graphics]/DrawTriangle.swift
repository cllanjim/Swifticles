//
//  DrawTriangle.swift
//
//  Created by Nicholas Raptis on 8/9/16.
//

import UIKit

class DrawTriangle {
    
    var node1 = DrawNode()
    var node2 = DrawNode()
    var node3 = DrawNode()
    
    func set(triangle:DrawTriangle) {
        node1.set(drawNode: triangle.node1)
        node2.set(drawNode: triangle.node2)
        node3.set(drawNode: triangle.node3)
    }
    
    func setColor(color: Color) {
        
        node1.r = color.r
        node1.g = color.g
        node1.b = color.b
        node1.a = color.a
        
        node2.r = color.r
        node2.g = color.g
        node2.b = color.b
        node2.a = color.a
        
        node3.r = color.r
        node3.g = color.g
        node3.b = color.b
        node3.a = color.a
        
        
        
        //Color
    }
    
    var p1:(x:CGFloat, y:CGFloat, z:CGFloat) {
        get { return (node1.x, node1.y, node1.z)}
        set {
            node1.x = newValue.x
            node1.y = newValue.y
            node1.z = newValue.z
        }
    }
    
    var p2:(x:CGFloat, y:CGFloat, z:CGFloat) {
        get { return (node2.x, node2.y, node2.z)}
        set {
            node2.x = newValue.x
            node2.y = newValue.y
            node2.z = newValue.z
        }
    }
    
    var p3:(x:CGFloat, y:CGFloat, z:CGFloat) {
        get { return (node3.x, node3.y, node3.z)}
        set {
            node3.x = newValue.x
            node3.y = newValue.y
            node3.z = newValue.z
        }
    }
    
    var t1:(u:CGFloat, v:CGFloat, w:CGFloat) {
        get { return (node1.u, node1.v, node1.w)}
        set {
            node1.u = newValue.u
            node1.v = newValue.v
            node1.w = newValue.w
        }
    }
    
    var t2:(u:CGFloat, v:CGFloat, w:CGFloat) {
        get { return (node2.u, node2.v, node2.w)}
        set {
            node2.u = newValue.u
            node2.v = newValue.v
            node2.w = newValue.w
        }
    }
    
    var t3:(u:CGFloat, v:CGFloat, w:CGFloat) {
        get { return (node3.u, node3.v, node3.w)}
        set {
            node3.u = newValue.u
            node3.v = newValue.v
            node3.w = newValue.w
        }
    }
    
    var c1:(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) {
        get { return (node1.r, node1.g, node1.b, node1.a)}
        set {
            node1.r = newValue.r
            node1.g = newValue.g
            node1.b = newValue.b
            node1.a = newValue.a
        }
    }
    
    var c2:(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) {
        get { return (node2.r, node2.g, node2.b, node2.a)}
        set {
            node2.r = newValue.r
            node2.g = newValue.g
            node2.b = newValue.b
            node2.a = newValue.a
        }
    }
    
    var c3:(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) {
        get { return (node3.r, node3.g, node3.b, node3.a)}
        set {
            node3.r = newValue.r
            node3.g = newValue.g
            node3.b = newValue.b
            node3.a = newValue.a
        }
    }
    
    var x1: CGFloat {
        get { return node1.x}
        set {node1.x = newValue}
    }
    
    var y1: CGFloat {
        get { return node1.y}
        set {node1.y = newValue}
    }
    
    var z1: CGFloat {
        get { return node1.z}
        set {node1.z = newValue}
    }
    
    var u1: CGFloat {
        get { return node1.u}
        set {node1.u = newValue}
    }
    
    var v1: CGFloat {
        get { return node1.v}
        set {node1.v = newValue}
    }
    
    var w1: CGFloat {
        get { return node1.w}
        set {node1.w = newValue}
    }
    
    var r1: CGFloat {
        get { return node1.r}
        set {node1.r = newValue}
    }
    
    var g1: CGFloat {
        get { return node1.g}
        set {node1.g = newValue}
    }
    
    var b1: CGFloat {
        get { return node1.b}
        set {node1.b = newValue}
    }
    
    var a1: CGFloat {
        get { return node1.a}
        set {node1.a = newValue}
    }
    
    var x2: CGFloat {
        get { return node2.x}
        set {node2.x = newValue}
    }
    
    var y2: CGFloat {
        get { return node2.y}
        set {node2.y = newValue}
    }
    
    var z2: CGFloat {
        get { return node2.z}
        set {node2.z = newValue}
    }
    
    var u2: CGFloat {
        get { return node2.u}
        set {node2.u = newValue}
    }
    
    var v2: CGFloat {
        get { return node2.v}
        set {node2.v = newValue}
    }
    
    var w2: CGFloat {
        get { return node2.w}
        set {node2.w = newValue}
    }
    
    var r2: CGFloat {
        get { return node2.r}
        set {node2.r = newValue}
    }
    
    var g2: CGFloat {
        get { return node2.g}
        set {node2.g = newValue}
    }
    
    var b2: CGFloat {
        get { return node2.b}
        set {node2.b = newValue}
    }
    
    var a2: CGFloat {
        get { return node2.a}
        set {node2.a = newValue}
    }
    
    var x3: CGFloat {
        get { return node3.x}
        set {node3.x = newValue}
    }
    
    var y3: CGFloat {
        get { return node3.y}
        set {node3.y = newValue}
    }
    
    var z3: CGFloat {
        get { return node3.z}
        set {node3.z = newValue}
    }
    
    var u3: CGFloat {
        get { return node3.u}
        set {node3.u = newValue}
    }
    
    var v3: CGFloat {
        get { return node3.v}
        set {node3.v = newValue}
    }
    
    var w3: CGFloat {
        get { return node3.w}
        set {node3.w = newValue}
    }
    
    var r3: CGFloat {
        get { return node3.r}
        set {node3.r = newValue}
    }
    
    var g3: CGFloat {
        get { return node3.g}
        set {node3.g = newValue}
    }
    
    var b3: CGFloat {
        get { return node3.b}
        set {node3.b = newValue}
    }
    
    var a3: CGFloat {
        get { return node3.a}
        set {node3.a = newValue}
    }
    
    func writeToTriangleList(_ t:inout [GLfloat], index:Int) {
        //let count = t.count
        t[index +  0] = GLfloat(node1.x)
        t[index +  1] = GLfloat(node1.y)
        t[index +  2] = GLfloat(node1.z)
        t[index +  3] = GLfloat(node1.u)
        t[index +  4] = GLfloat(node1.v)
        t[index +  5] = GLfloat(node1.w)
        t[index +  6] = GLfloat(node1.r)
        t[index +  7] = GLfloat(node1.g)
        t[index +  8] = GLfloat(node1.b)
        t[index +  9] = GLfloat(node1.a)
        t[index + 10] = GLfloat(node2.x)
        t[index + 11] = GLfloat(node2.y)
        t[index + 12] = GLfloat(node2.z)
        t[index + 13] = GLfloat(node2.u)
        t[index + 14] = GLfloat(node2.v)
        t[index + 15] = GLfloat(node2.w)
        t[index + 16] = GLfloat(node2.r)
        t[index + 17] = GLfloat(node2.g)
        t[index + 18] = GLfloat(node2.b)
        t[index + 19] = GLfloat(node2.a)
        t[index + 20] = GLfloat(node3.x)
        t[index + 21] = GLfloat(node3.y)
        t[index + 22] = GLfloat(node3.z)
        t[index + 23] = GLfloat(node3.u)
        t[index + 24] = GLfloat(node3.v)
        t[index + 25] = GLfloat(node3.w)
        t[index + 26] = GLfloat(node3.r)
        t[index + 27] = GLfloat(node3.g)
        t[index + 28] = GLfloat(node3.b)
        t[index + 29] = GLfloat(node3.a)
    }
    
    var buffer:[GLfloat] {
        return [GLfloat](arrayLiteral: GLfloat(node1.x), GLfloat(node1.y), GLfloat(node1.z),
                         GLfloat(node1.u), GLfloat(node1.v), GLfloat(node1.w),
                         GLfloat(node1.r), GLfloat(node1.g), GLfloat(node1.b), GLfloat(node1.a),
                         
                         GLfloat(node2.x), GLfloat(node2.y), GLfloat(node2.z),
                         GLfloat(node2.u), GLfloat(node2.v), GLfloat(node2.w),
                         GLfloat(node2.r), GLfloat(node2.g), GLfloat(node2.b), GLfloat(node2.a),
                         
                         GLfloat(node3.x), GLfloat(node3.y), GLfloat(node3.z),
                         GLfloat(node3.u), GLfloat(node3.v), GLfloat(node3.w),
                         GLfloat(node3.r), GLfloat(node3.g), GLfloat(node3.b), GLfloat(node3.a)
        )
    }
    
    func draw() {
        ShaderProgramMesh.shared.triangleDraw(self)
    }
}
