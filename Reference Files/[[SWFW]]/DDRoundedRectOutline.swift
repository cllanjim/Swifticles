//
//  DDRoundedRect.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDRoundedRectOutline : DIView
{
    var mCornerRadius:CGFloat = 30.0
    var mColor:UIColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.7)
    var mThickness:CGFloat = 10.0
    
    var mPathOutline : UIBezierPath!;
    
    var mRoundUL:Bool = true;
    var mRoundUR:Bool = true;
    var mRoundDR:Bool = true;
    var mRoundDL:Bool = true;
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        super.make(frame)
        
        self.userInteractionEnabled = false
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func spawn()
    {
        self.spawnSafetyCheck()
        super.spawn()
    }
    
    func renderRefresh()
    {
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect)
    {
        let aCornerType:UIRectCorner = gMask.getCornerType(mRoundUL, pUR: mRoundUR, pDR: mRoundDR, pDL: mRoundDL)

        self.mPathOutline = nil;
        self.mPathOutline = UIBezierPath(roundedRect: self.bounds,
            byRoundingCorners: aCornerType,
            cornerRadii: CGSize(width: mCornerRadius, height: mCornerRadius))
        
        mColor.setStroke();
        mPathOutline.lineWidth = mThickness
        mPathOutline.stroke();
        
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            super.destroy()
        }
    }
}