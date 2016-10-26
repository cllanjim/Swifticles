//
//  HistoryStateChangeShape.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/25/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class HistoryStateChangeShape : HistoryState
{
    override init() {
        super.init()
        type = .blobChangeShape
    }
    
    var startSplineData: [String: AnyObject]?
    var endSplineData: [String: AnyObject]?
}
