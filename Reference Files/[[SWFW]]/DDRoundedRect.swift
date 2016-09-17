//
//  DDRoundedRect.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDRoundedRect : DIElement
{
    var mGradientLayer:CAGradientLayer!
    var mOutline:DDRoundedRectOutline!
    
    var mCornerRadius:CGFloat = 6.0
    
    var mColorStart:UIColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 0.7)
    var mColorEnd:UIColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 0.7)
    
    var mDirectionVertical:Bool = true;
    var mDirectionLocked:Bool = true;
    
    
    var mStrokeWidth:CGFloat = 0.0
    var mStrokeInset:CGFloat = 0.0
    var mStrokeColor: UIColor = UIColor(red: 0.02, green: 0.01, blue: 0.03, alpha: 1.0);
    
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
        
        self.mGradientLayer = CAGradientLayer();
        self.layer.addSublayer(mGradientLayer);
        mGradientLayer.frame = CGRectMake(0.0, 0.0, mW, mH);
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
        if(mGradientLayer != nil)
        {
            //mGradientLayer.frame = CGRectMake(0.0, 0.0, mW, mH);
        }
        
        //self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect)
    {
//        if(mGradientLayer == nil)
//        {
//            self.mGradientLayer = CAGradientLayer();
//            self.layer.addSublayer(mGradientLayer)
//        }
        
        if(mOutline != nil)
        {
            mOutline.destroy()
            self.mOutline = nil
        }
        
        if(mStrokeWidth > 0)
        {
            let aStrokeRect:CGRect = CGRectMake(mStrokeInset, mStrokeInset,
                frame.size.width - (mStrokeInset * 2.0), frame.size.height - (mStrokeInset * 2.0))
            
            self.mOutline = DDRoundedRectOutline(frame: aStrokeRect)
            mOutline.mCornerRadius = mCornerRadius;
            mOutline.mRoundUL = mRoundUL;mOutline.mRoundUR = mRoundUR;
            mOutline.mRoundDR = mRoundDR;mOutline.mRoundDL = mRoundDL;
            mOutline.mThickness = mStrokeWidth;mOutline.mColor = mStrokeColor;
            self.addSubview(mOutline)
            mOutline.mkchk(aStrokeRect);
            
        }
        else
        {
            
        }
        
        
        if(mGradientLayer != nil)
        {
            mGradientLayer.frame = CGRectMake(0.0, 0.0, mW, mH);
            
            mGradientLayer.colors = [mColorStart.CGColor as CGColorRef, mColorEnd.CGColor as CGColorRef]
            mGradientLayer.locations = [0.0, 1.0]
        
        if(mDirectionLocked == true)
        {
            if(mDirectionVertical == true)
            {
                mGradientLayer.startPoint = CGPointMake(0.5, 0.0);
                mGradientLayer.endPoint = CGPointMake(0.5, 1.0);
            }
            else
            {
                mGradientLayer.startPoint = CGPointMake(0.0, 0.5);
                mGradientLayer.endPoint = CGPointMake(1.0, 0.5);
            }
        }
        
        }
        
        let aCornerType:UIRectCorner = gMask.getCornerType(
            mRoundUL, pUR: mRoundUR, pDR: mRoundDR, pDL: mRoundDL)
        gMask.maskRoundedRect(self, pCornerRadius: mCornerRadius, pCornerType: aCornerType)
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            if(mGradientLayer != nil)
            {
                mGradientLayer.removeAllAnimations()
                mGradientLayer.removeFromSuperlayer()
                self.mGradientLayer = nil
            }
            
            if(mOutline != nil)
            {
                mOutline.destroy()
                self.mOutline = nil
            }
            
            super.destroy()
        }
    }
}
