//
//  BlobMeshNode.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/9/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class BlobMeshNode : DrawNode
{
    var edgeDistance: CGFloat = 0.0
    var edgePercent: CGFloat = 0.0
    
    
    //var edgeDistance: CGFloat
    
    
    //var x:CGFloat = 0.0
    //var y:CGFloat = 0.0
    //var z:CGFloat = 0.0
    
    func set(meshNode meshNode:BlobMeshNode) {
        
        set(drawNode: meshNode)
        //x = meshNode.x;y = meshNode.y;z = meshNode.z
        //u = meshNode.u;v = meshNode.v;w = meshNode.w
        //r = meshNode.r;g = meshNode.g;b = meshNode.b;a = meshNode.a
        edgeDistance = meshNode.edgeDistance
        edgePercent = meshNode.edgePercent
    }
    
    
}
