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
    func set(drawNode drawNode:DrawNode) {
        x = drawNode.x;y = drawNode.y;z = drawNode.z
        u = drawNode.u;v = drawNode.v;w = drawNode.w
        r = drawNode.r;g = drawNode.g;b = drawNode.b;a = drawNode.a
    }
}