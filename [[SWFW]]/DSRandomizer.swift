//
//  DSRandomizer.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/20/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit


class DSRandomizer : DSObject
{
    func get(pInt:Int) -> Int
    {
        var aReturn:Int = pInt;
        
        if(aReturn <= 1){aReturn = 0;}
        else{aReturn = Int(arc4random_uniform(UInt32(aReturn)))}
        
        return aReturn;
    }
    
    func getInt(pInt:Int) -> Int{return self.get(pInt);}

    func getPercent()->CGFloat{return CGFloat(getInt(768432807)) / 768432806.0}
    func p()->CGFloat{return self.getPercent()}
    
    func getFloat(pFloat:CGFloat)->CGFloat{return getPercent() * pFloat}
    func getFloat(min pMin:CGFloat, max pMax:CGFloat)->CGFloat{return pMin + (getPercent() * (pMax - pMin))}
    
    func f(pFloat:CGFloat)->CGFloat{return self.getFloat(pFloat)}
    func f(min pMin:CGFloat, max pMax:CGFloat)->CGFloat{return self.getFloat(min: pMin, max: pMax)}
    
    func getBool()->Bool{return self.get(2) == 1}
    func b()->Bool{return self.getBool()}
    
    func getColorRed() -> UIColor
    {
        return UIColor(red: 0.8 + getFloat(0.2), green: getFloat(0.2), blue: getFloat(0.2), alpha: 1.0)
    }
    
    func getColorRedBright() -> UIColor
    {
        return UIColor(red: 0.8 + getFloat(0.2), green: 0.5 + getFloat(0.1), blue: 0.5 + getFloat(0.1), alpha: 1.0)
    }
    
    func getColorRedDark() -> UIColor
    {
        return UIColor(red: 0.5 + getFloat(0.2), green: 0.0 + getFloat(0.1), blue: 0.0 + getFloat(0.1), alpha: 1.0)
    }
    
    func getColorGray() -> UIColor
    {
        return UIColor(red: 0.8 + getFloat(0.2), green: 0.8 + getFloat(0.2), blue: 0.8 + getFloat(0.2), alpha: 1.0)
    }
    
    class var shared: DSRandomizer
    {
        struct Static{static var cTokenOnce: dispatch_once_t = 0;static var cInstance: DSRandomizer? = nil;}
        dispatch_once(&Static.cTokenOnce){Static.cInstance = DSRandomizer()}
        return Static.cInstance!
    }
}

let gRnd:DSRandomizer = DSRandomizer.shared;