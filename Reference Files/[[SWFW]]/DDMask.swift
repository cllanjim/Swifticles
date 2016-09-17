//
//  DDMask.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/20/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDMask : DSObject
{
    
    
    func getCornerType(pUL:Bool, pUR:Bool, pDR:Bool, pDL:Bool) -> UIRectCorner
    {
        var aReturn:UIRectCorner = UIRectCorner(rawValue: 0)
        
        if(pUL == true){aReturn = aReturn.union(UIRectCorner.TopLeft)}
        if(pUR == true){aReturn = aReturn.union(UIRectCorner.TopRight)}
        if(pDR == true){aReturn = aReturn.union(UIRectCorner.BottomRight)}
        if(pDL == true){aReturn = aReturn.union(UIRectCorner.BottomLeft)}
        
        return aReturn;
    }
    
    func maskRoundedRect(pView:UIView, pCornerRadius:CGFloat, pCornerType:UIRectCorner)
    {
        let aMaskPath:UIBezierPath = UIBezierPath(roundedRect:
            CGRect(x: 0.0, y: 0.0, width:pView.frame.size.width, height: pView.frame.size.height),
            byRoundingCorners: pCornerType,
            cornerRadii: CGSize(width: pCornerRadius, height: pCornerRadius))
        let aShape:CAShapeLayer = CAShapeLayer()
        aShape.path = aMaskPath.CGPath
        pView.layer.mask = aShape
    }
    
    func maskRoundedRect(pView:UIView, pCornerRadius:CGFloat)
    {
        self.maskRoundedRect(pView, pCornerRadius:pCornerRadius,
            pCornerType:getCornerType(true, pUR:true, pDR: true, pDL: true))
    }
    
    
    class var shared: DDMask
    {
        struct Static{static var cTokenOnce: dispatch_once_t = 0;static var cInstance: DDMask? = nil;}
        dispatch_once(&Static.cTokenOnce){Static.cInstance = DDMask()}
        return Static.cInstance!
    }
}

let gMask:DDMask = DDMask.shared;