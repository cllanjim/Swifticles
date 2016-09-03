//
//  DrawTriangle.swift
//  Bounce
//
//  Created by Nicholas Raptis on 8/9/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class DrawTriangle {
    
    
    deinit {
        print("DrawTriangle.deinit()")
    }
    
    var node1 = DrawNode()
    var node2 = DrawNode()
    var node3 = DrawNode()
    
    func set(triangle triangle:DrawTriangle) {
        
        p1 = triangle.p1
        p2 = triangle.p2
        p3 = triangle.p3
        
        t1 = triangle.t1
        t2 = triangle.t2
        t3 = triangle.t3
        
        c1 = triangle.c1
        c2 = triangle.c2
        c3 = triangle.c3
        
        /*
        x1 = triangle.x1
        y1 = triangle.y1
        z1 = triangle.z1
        u1 = triangle.u1
        v1 = triangle.v1
        w1 = triangle.w1
        r1 = triangle.r1
        g1 = triangle.g1
        b1 = triangle.b1
        a1 = triangle.a1
        
        x2 = triangle.x2
        y2 = triangle.y2
        z2 = triangle.z2
        u2 = triangle.u2
        v2 = triangle.v2
        w2 = triangle.w2
        r2 = triangle.r2
        g2 = triangle.g2
        b2 = triangle.b2
        a2 = triangle.a2
        
        x3 = triangle.x3
        y3 = triangle.y3
        z3 = triangle.z3
        u3 = triangle.u3
        v3 = triangle.v3
        w3 = triangle.w3
        r3 = triangle.r3
        g3 = triangle.g3
        b3 = triangle.b3
        a3 = triangle.a3
        */
        
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
    
    func writeToTriangleList(inout t:[GLfloat]) {
        
        let count = t.count
        t[count +  0] = GLfloat(node1.x)
        t[count +  1] = GLfloat(node1.y)
        t[count +  2] = GLfloat(node1.z)
        
        t[count +  3] = GLfloat(node1.u)
        t[count +  4] = GLfloat(node1.v)
        t[count +  5] = GLfloat(node1.w)
        
        t[count +  6] = GLfloat(node1.r)
        t[count +  7] = GLfloat(node1.g)
        t[count +  8] = GLfloat(node1.b)
        t[count +  9] = GLfloat(node1.a)
        
        t[count + 10] = GLfloat(node2.x)
        t[count + 11] = GLfloat(node2.y)
        t[count + 12] = GLfloat(node2.z)
        
        t[count + 13] = GLfloat(node2.u)
        t[count + 14] = GLfloat(node2.v)
        t[count + 15] = GLfloat(node2.w)
        
        t[count + 16] = GLfloat(node2.r)
        t[count + 17] = GLfloat(node2.g)
        t[count + 18] = GLfloat(node2.b)
        t[count + 19] = GLfloat(node2.a)
        
        t[count + 20] = GLfloat(node3.x)
        t[count + 21] = GLfloat(node3.y)
        t[count + 22] = GLfloat(node3.z)
        
        t[count + 23] = GLfloat(node3.u)
        t[count + 24] = GLfloat(node3.v)
        t[count + 25] = GLfloat(node3.w)
        
        t[count + 26] = GLfloat(node3.r)
        t[count + 27] = GLfloat(node3.g)
        t[count + 28] = GLfloat(node3.b)
        t[count + 29] = GLfloat(node3.a)
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
        
    }
    
    /*
    glClearColor(0.65, 0.65, 0.65, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
    
    glBindVertexArrayOES(vertexArray)
    
    // Render the object with GLKit
    self.effect?.prepareToDraw()
    
    glDrawArrays(GLenum(GL_TRIANGLES) , 0, 36)
    
    // Render the object again with ES2
    glUseProgram(program)
    
    withUnsafePointer(&modelViewProjectionMatrix, {
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, UnsafePointer($0))
    })
    
    withUnsafePointer(&normalMatrix, {
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, UnsafePointer($0))
    })
    
    glDrawArrays(GLenum(GL_TRIANGLES), 0, 36)
    */
    
    
}
