//
//  Config.swift
//  SwiftFunhouse
//
//  Created by Nicholas Raptis on 7/24/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

//
//  DSConfig.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/20/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class Config
{
    
    var scale:CGFloat {
        return 2.0
    }
    
    var importScale:CGFloat {
        return scale * 1.5
    }
    
    
    func fontName() -> String{return String("Arial")}
    func fontNameBold() -> String{return String("Arial-BoldMT")}
    
    func fontCellValue() -> UIFont!
    {
        return UIFont(name: fontName(), size: 16.0)
    }
    
    func fontCellSubtitle() -> UIFont!
    {
        return UIFont(name: fontName(), size: 11.0)
    }
    
    func fontCellHeaderBold() -> UIFont!
    {
        return UIFont(name: fontNameBold(), size: 22.0)
    }
    
    class var shared: Config
    {
        struct Static {
            static var cTokenOnce:dispatch_once_t = 0;
            static var cInstance: Config?;
        }
        dispatch_once(&Static.cTokenOnce) {
            Static.cInstance = Config()
        }
        return Static.cInstance!
    }
}

let gCfg = Config()//Config.shared;
