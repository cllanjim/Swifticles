//
//  DSConfig.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/20/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit


class DSConfig : DSObject
{
    
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
    
    func fontCellTitleBold() -> UIFont!
    {
        return UIFont(name: fontNameBold(), size: 16.0)
    }
    
    func fontCellTitle() -> UIFont!
    {
        return UIFont(name: fontName(), size: 16.0)
    }

    func fontDialogTitle() -> UIFont!
    {
        return UIFont(name: fontNameBold(), size: 20.0)
    }
    
    func fontDialogSubtitle() -> UIFont!
    {
        return UIFont(name: fontName(), size: 16.0)
    }
    
    func fontDialog() -> UIFont!
    {
        return UIFont(name: fontName(), size: 12.0)
    }
    
    
    
    class var shared: DSConfig
    {
        struct Static{static var cTokenOnce: dispatch_once_t = 0;static var cInstance: DSConfig? = nil;}
        dispatch_once(&Static.cTokenOnce){Static.cInstance = DSConfig()}
        return Static.cInstance!
    }
}

let gConfig:DSConfig = DSConfig.shared;
