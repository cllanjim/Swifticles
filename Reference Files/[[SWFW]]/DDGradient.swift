//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDGradient : DIElement
{
    
    var mColorArray:NSMutableArray! = NSMutableArray()
    var mPositionArray:NSMutableArray! = NSMutableArray()
    
    var mColorRefresh:Bool = true;
    
    var mGradientLayer:CAGradientLayer!
    
    var mDirectionVertical:Bool = true;
    var mDirectionLocked:Bool = true;
    
    
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        super.make(frame)

        self.backgroundColor = UIColor.clearColor()
    }
    
    override func spawn()
    {
        self.spawnSafetyCheck()
        super.spawn()
        
        self.mGradientLayer = CAGradientLayer()
        mGradientLayer.frame = CGRectMake(0.0, 0.0, mW, mH);
        self.layer.addSublayer(mGradientLayer)
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
        if(mGradientLayer != nil)
        {
            mGradientLayer.frame = CGRectMake(0.0, 0.0, mW, mH);
            
            if(mColorRefresh == true)
            {
                mColorRefresh = false;
                
                
                if(mGradientLayer == nil)
                {
                    self.mGradientLayer = CAGradientLayer()
                    self.layer.addSublayer(mGradientLayer)
                    mGradientLayer.frame = CGRectMake(0.0, 0.0, mW, mH);
                }
                
                if(mColorArray.count == 1)
                {
                    mGradientLayer.colors = [(mColorArray.objectAtIndex(0) as! CGColorRef)]
                    mGradientLayer.locations = [(mPositionArray.objectAtIndex(0) as! Float)]
                }
                else if(mColorArray.count == 2)
                {
                    mGradientLayer.colors = [mColorArray.objectAtIndex(0) as! CGColorRef,
                        mColorArray.objectAtIndex(1) as! CGColorRef]
                    mGradientLayer.locations = [(mPositionArray.objectAtIndex(0) as! Float),
                        (mPositionArray.objectAtIndex(1) as! Float)]
                }
                else if(mColorArray.count == 3)
                {
                    mGradientLayer.colors = [mColorArray.objectAtIndex(0) as! CGColorRef,
                        mColorArray.objectAtIndex(1) as! CGColorRef,
                        mColorArray.objectAtIndex(2) as! CGColorRef]
                    mGradientLayer.locations = [(mPositionArray.objectAtIndex(0) as! Float),
                        (mPositionArray.objectAtIndex(1) as! Float),
                        (mPositionArray.objectAtIndex(2) as! Float)]
                }
                else if(mColorArray.count == 4)
                {
                    mGradientLayer.colors = [mColorArray.objectAtIndex(0) as! CGColorRef,
                        mColorArray.objectAtIndex(1) as! CGColorRef,
                        mColorArray.objectAtIndex(2) as! CGColorRef,
                        mColorArray.objectAtIndex(3) as! CGColorRef]
                    mGradientLayer.locations = [(mPositionArray.objectAtIndex(0) as! Float),
                        (mPositionArray.objectAtIndex(1) as! Float),
                        (mPositionArray.objectAtIndex(2) as! Float),
                        (mPositionArray.objectAtIndex(3) as! Float)]
                }
                else if(mColorArray.count == 5)
                {
                    mGradientLayer.colors = [mColorArray.objectAtIndex(0) as! CGColorRef,
                        mColorArray.objectAtIndex(1) as! CGColorRef,
                        mColorArray.objectAtIndex(2) as! CGColorRef,
                        mColorArray.objectAtIndex(3) as! CGColorRef,
                        mColorArray.objectAtIndex(4) as! CGColorRef]
                    mGradientLayer.locations = [(mPositionArray.objectAtIndex(0) as! Float),
                        (mPositionArray.objectAtIndex(1) as! Float),
                        (mPositionArray.objectAtIndex(2) as! Float),
                        (mPositionArray.objectAtIndex(3) as! Float),
                        (mPositionArray.objectAtIndex(4) as! Float)]
                }
                else if(mColorArray.count == 6)
                {
                    mGradientLayer.colors = [mColorArray.objectAtIndex(0) as! CGColorRef,
                        mColorArray.objectAtIndex(1) as! CGColorRef,
                        mColorArray.objectAtIndex(2) as! CGColorRef,
                        mColorArray.objectAtIndex(3) as! CGColorRef,
                        mColorArray.objectAtIndex(4) as! CGColorRef,
                        mColorArray.objectAtIndex(5) as! CGColorRef]
                    mGradientLayer.locations = [(mPositionArray.objectAtIndex(0) as! Float),
                        (mPositionArray.objectAtIndex(1) as! Float),
                        (mPositionArray.objectAtIndex(2) as! Float),
                        (mPositionArray.objectAtIndex(3) as! Float),
                        (mPositionArray.objectAtIndex(4) as! Float),
                        (mPositionArray.objectAtIndex(5) as! Float)]
                }
                
                
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
        }
        //
        //...
    }

    
    
    func addColor(pColor:UIColor, pPos:CGFloat)
    {
        mColorRefresh = true;
        
        mColorArray.addObject(UIColor(CGColor: pColor.CGColor).CGColor as CGColorRef)
        mPositionArray.addObject(Float(pPos))
        
        
    }
    
    func reset()
    {
        mColorArray.removeAllObjects()
        mPositionArray.removeAllObjects()
        
        if(mGradientLayer != nil)
        {
            mGradientLayer.removeFromSuperlayer()
            self.mGradientLayer = nil
        }
    }
    
    func setWhiteBlue()
    {
        self.reset();
        self.addColor(UIColor(red: 0.93, green: 0.96, blue: 0.98, alpha: 1.0), pPos: 0.0)
        self.addColor(UIColor(red: 0.98, green: 1.0, blue: 0.99, alpha: 1.0), pPos: 1.0)
    }
    
    func setSkyBlueLight1()
    {
        self.reset();
        self.addColor(UIColor(red: 254.0 / 255.0, green: 249.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), pPos: 0.0)
        self.addColor(UIColor(red: 158.0 / 255.0, green: 232.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0), pPos: 1.0)
    }
    
    func setSkyBlue2()
    {
        self.reset();
        self.addColor(UIColor(red: 252.0 / 255.0, green: 252.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), pPos: 0.0)
        self.addColor(UIColor(red: 172.0 / 255.0, green: 225.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0), pPos: 0.66)
        self.addColor(UIColor(red: 160.0 / 255.0, green: 216.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0), pPos: 1.0)
        
        
        //self.addColor(gColorOPRXGreenLite, pPos: 0.6)
        //self.addColor(gColorOPRXGreen, pPos: 0.69)
        //self.addColor(gColorOPRXGreenDark, pPos: 1.0)
    }
    
    func setSkyBlue1()
    {
        self.reset();
        self.addColor(UIColor(red: 135.0 / 255.0, green: 224.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0), pPos: 0.0)
        self.addColor(UIColor(red: 83.0 / 255.0, green: 203.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0), pPos: 0.40)
        self.addColor(UIColor(red: 5.0 / 255.0, green: 171.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0), pPos: 1.00)
    }
    
    func setLightGray1()
    {
        self.reset();
        self.addColor(UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), pPos: 0.0)
        self.addColor(UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0), pPos: 0.45)
        self.addColor(UIColor(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0), pPos: 1.0)
    }
    
    
    func setLightGray2()
    {
        self.reset();
        self.addColor(UIColor(red: 252.0 / 255.0, green: 255.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0), pPos: 0.0)
        self.addColor(UIColor(red: 223.0 / 255.0, green: 229.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0), pPos: 1.0)
    }
    
    func setLightTan1()
    {
        self.reset();
        self.addColor(UIColor(red: 0.98, green: 0.95, blue: 0.92, alpha: 1.0), pPos: 0.0)
        self.addColor(UIColor(red: 0.97, green: 0.95, blue: 0.87, alpha: 1.0), pPos: 1.0)
    }
    
    
    func setLightTan2()
    {
        self.reset();
        self.addColor(UIColor(red: 0.95, green: 0.92, blue: 0.88, alpha: 1.0), pPos: 0.0)
        self.addColor(UIColor(red: 0.94, green: 0.90, blue: 0.84, alpha: 1.0), pPos: 1.0)
    }
    
    //rgba(,,,1) 0%,rgba(,229,215,1) 100%
    
    func setDarkOrange1()
    {
        self.reset();
        self.addColor(UIColor(red: 255.0 / 255.0, green: 168.0 / 255.0, blue: 76.0 / 255.0, alpha: 1.0), pPos: 0.0)
        
        self.addColor(UIColor(red: 255.0 / 255.0, green: 123.0 / 255.0, blue: 13.0 / 255.0, alpha: 1.0), pPos: 1.0)
    }
  
    //Dark Orange
//    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(255,168,76,1)), color-stop(100%,rgba(255,123,13,1))); /*

    
    //Light Orange
    //olor-stop(0%,rgba(255,197,120,1)), color-stop(100%,rgba(251,157,35,1)));
    
    
    
    
    
    
    func setLemonLime()
    {
        self.reset();
        self.addColor(UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), pPos: 0.0)
        self.addColor(UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0), pPos: 0.45)
        self.addColor(UIColor(red: 237.0 / 255.0, green: 237.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0), pPos: 1.0)
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            self.reset()
            
            self.mColorArray = nil
            self.mPositionArray = nil
            
            super.destroy()
        }
    }
}



