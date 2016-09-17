//
//  DDShape.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/20/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDShapePresets : DSObject
{
    
    func makeCheckMark() -> DDShape
    {
        let aShape:DDShape = DDShape(frame: CGRectMake(0.0, 0.0, 100.0, 100.0))
        aShape.addPoint(CGPointMake(0.0, 0.5));aShape.addPoint(CGPointMake(0.5, 0.925));aShape.addPoint(CGPointMake(1.0, 0.05));
        return aShape
    }
    
    func makeChevronRight() -> DDShape
    {
        let aShape:DDShape = DDShape(frame: CGRectMake(0.0, 0.0, 100.0, 100.0))
        aShape.addPoint(CGPointMake(0.30, 0.0));aShape.addPoint(CGPointMake(0.85, 0.5));aShape.addPoint(CGPointMake(0.30, 1.0));
        return aShape
    }
    
    func makeChevronLeft() -> DDShape
    {
        let aShape:DDShape = DDShape(frame: CGRectMake(0.0, 0.0, 100.0, 100.0))
        aShape.addPoint(CGPointMake(0.70, 0.0));aShape.addPoint(CGPointMake(0.15, 0.5));aShape.addPoint(CGPointMake(0.70, 1.0));
        return aShape
    }
    
    
    class var shared: DDShapePresets
    {
        struct Static{static var cTokenOnce: dispatch_once_t = 0;static var cInstance: DDShapePresets? = nil;}
        dispatch_once(&Static.cTokenOnce){Static.cInstance = DDShapePresets()}
        return Static.cInstance!
    }
}

let gShape:DDShapePresets = DDShapePresets.shared;

