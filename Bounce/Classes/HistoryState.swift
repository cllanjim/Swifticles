//
//  HistoryState.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 10/24/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

enum HistoryType: UInt32 {
    case unknown = 0,
    blobAdd = 1,
    blobDelete = 2,
    blobChangeAffine = 3,
    blobChangeShape = 4
}

class HistoryState : NSObject
{
    override init() {
        super.init()
        
    }
    
    var type: HistoryType = .unknown
    var blobIndex: Int?
    var blobData: [String: AnyObject]?
}
