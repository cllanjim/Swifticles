//
//  DSImageUtils.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DSImageUtils : NSObject
{
    override init(){super.init();}

    class var shared: DSImageUtils
    {
        struct Static{static var cTokenOnce: dispatch_once_t = 0;static var cInstance: DSImageUtils? = nil;}
        dispatch_once(&Static.cTokenOnce){Static.cInstance = DSImageUtils()}
        return Static.cInstance!
    }
}

let gImg:DSImageUtils = DSImageUtils.shared;
