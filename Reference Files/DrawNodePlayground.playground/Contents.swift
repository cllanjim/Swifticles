//: Playground - noun: a place where people can play

import UIKit
import OpenGLES

class DrawNode {
    
    var x:Double = 0.0
    var y:Double = 0.0
    var z:Double = 0.0
    
    var u:Double = 0.0
    var v:Double = 0.0
    var w:Double = 0.0
    
    var r:Double = 1.0
    var g:Double = 1.0
    var b:Double = 1.0
    var a:Double = 1.0
}

class DrawTriangle {
    
    init() {
        
    }
    
    var node1 = DrawNode()
    var node2 = DrawNode()
    var node3 = DrawNode()
    
    var p1:(x:Double, y:Double, z:Double) {
        get { return (node1.x, node1.y, node1.z)}
        set {
            node1.x = newValue.x;
            node1.y = newValue.y;
            node1.z = newValue.z;
        }
    }
    
    var p2:(x:Double, y:Double, z:Double) {
        get { return (node1.x, node1.y, node1.z)}
        set {
            node2.x = newValue.x;
            node2.y = newValue.y;
            node2.z = newValue.z;
        }
    }
    
    var p3:(x:Double, y:Double, z:Double) {
        get { return (node1.x, node1.y, node1.z)}
        set {
            node3.x = newValue.x;
            node3.y = newValue.y;
            node3.z = newValue.z
        }
    }
    
    var t1:(u:Double, v:Double, w:Double) {
        get { return (node1.u, node1.v, node1.w)}
        set {
            node1.u = newValue.u
            node1.v = newValue.v
            node1.w = newValue.w
        }
    }
    
    var t2:(u:Double, v:Double, w:Double) {
        get { return (node1.u, node1.v, node1.w)}
        set {
            node2.u = newValue.u
            node2.v = newValue.v
            node2.w = newValue.w
        }
    }
    
    var t3:(u:Double, v:Double, w:Double) {
        get { return (node1.u, node1.v, node1.w)}
        set {
            node3.u = newValue.u
            node3.v = newValue.v
            node3.w = newValue.w
        }
    }
    
    var buffer:[GLfloat] {
        
        var result = [GLfloat](count:4 * (3 + 3 + 4), repeatedValue: 0.0)
        
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
        
        //result.insert(<#T##newElement: Element##Element#>, atIndex: <#T##Int#>)
        //return (0..<16).map { i in
        //    self[i]
        //}
        
        //return result
    }
    
}


var t1 = DrawTriangle()

t1.p1 = (10.0, 20.0, 0.0)

print("\(t1.p1)")
print("\(t1)")
print("\(t1.buffer)")





//t1.


