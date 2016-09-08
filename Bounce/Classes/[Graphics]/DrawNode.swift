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
    func set(node:DrawNode) {
        x = node.x;y = node.y;z = node.z
        u = node.u;v = node.v;w = node.w
        r = node.r;g = node.g;b = node.b;a = node.a
    }
}