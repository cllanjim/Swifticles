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
    var index:Int = 0
    
    var edgeDistance: CGFloat = 0.0
    var edgePercent: CGFloat = 0.0
    
    func set(meshNode meshNode:BlobMeshNode) {
        
        set(drawNode: meshNode)
        
        index = meshNode.index
        
        edgeDistance = meshNode.edgeDistance
        edgePercent = meshNode.edgePercent
    }
    
    
}
