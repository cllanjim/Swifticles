//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit



class DIFormFooter : DIElement
{
    var mForm:DIForm! = nil
    
    var mButtonBottom:UIButton! = nil
    var mButtonMiddle:UIButton! = nil
    var mButtonTop:UIButton! = nil
    
    var mButtonPaddingTop:CGFloat = 0.0
    var mButtonPaddingBottom:CGFloat = 0.0
    var mButtonPaddingLeft:CGFloat = 0.0
    var mButtonPaddingRight:CGFloat = 0.0
    var mButtonSpacing:CGFloat = 0.0
    
    var mGradientBack:DDGradient! = nil
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        super.make(frame)
        
        self.backgroundColor = UIColor(red: 7.0, green: 4.0, blue: 5.0, alpha: 1.0)
        
        //
        //...
    }
    
    override func spawn()
    {
        self.spawnSafetyCheck()
        super.spawn()
        
        self.mGradientBack = self.getGradientBackground();
        if(mGradientBack != nil)
        {
            addSubview(mGradientBack);
            mGradientBack.mkchk(CGRectMake(0.0, 0.0, mW, mH))
        }
        
        self.mButtonBottom = self.getButtonBottom();
        if(mButtonBottom != nil)
        {
            self.addSubview(mButtonBottom);
            mButtonBottom.frame = CGRectMake(mW2 - (mButtonBottom.frame.size.width / 2.0), 0.0, mButtonBottom.frame.size.width, mButtonBottom.frame.size.height)
        }
        
        self.mButtonMiddle = self.getButtonMiddle();
        if(mButtonMiddle != nil)
        {
            self.addSubview(mButtonMiddle);
            mButtonMiddle.frame = CGRectMake(mW2 - (mButtonMiddle.frame.size.width / 2.0), 0.0, mButtonMiddle.frame.size.width, mButtonMiddle.frame.size.height)
        }
        
        self.mButtonTop = self.getButtonTop();
        if(mButtonTop != nil)
        {
            self.addSubview(mButtonTop);
            mButtonTop.frame = CGRectMake(mW2 - (mButtonTop.frame.size.width / 2.0), 0.0, mButtonTop.frame.size.width, mButtonTop.frame.size.height)
        }
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
        var aButtonCount:Int = 0
        var aButtonY:CGFloat = mButtonPaddingTop
        
        if(mButtonBottom != nil){aButtonCount++;}
        if(mButtonMiddle != nil){aButtonCount++;}
        if(mButtonTop != nil){aButtonCount++;}
        
        if(aButtonCount > 0)
        {
            var aRequiredHeight:CGFloat = mButtonPaddingBottom
            
            if(mButtonBottom != nil){aRequiredHeight += mButtonBottom.frame.size.height;}
            if(mButtonMiddle != nil){aRequiredHeight += mButtonMiddle.frame.size.height;}
            if(mButtonTop != nil){aRequiredHeight += mButtonTop.frame.size.height;}
            
            if(aButtonCount > 1)
            {aRequiredHeight += CGFloat(aButtonCount - 1) * CGFloat(mButtonSpacing)}
            
            aRequiredHeight += mButtonPaddingTop
            
            if(aRequiredHeight > (mH))
            {
                var aBottomY:CGFloat = (mY + mH)
                aBottomY -= aRequiredHeight
                self.setRect(CGRectMake(mX, aBottomY, mW, aRequiredHeight))
                return
            }
            
            if(mButtonTop != nil)
            {mButtonTop.frame = CGRectMake(mButtonTop.frame.origin.x, aButtonY, mButtonTop.frame.size.width, mButtonTop.frame.size.height)
                aButtonY += (mButtonTop.frame.size.height + mButtonSpacing)}
            
            if(mButtonMiddle != nil)
            {mButtonMiddle.frame = CGRectMake(mButtonMiddle.frame.origin.x, aButtonY, mButtonMiddle.frame.size.width, mButtonMiddle.frame.size.height)
                aButtonY += (mButtonMiddle.frame.size.height + mButtonSpacing)}
            
            if(mButtonBottom != nil)
            {mButtonBottom.frame = CGRectMake(mButtonBottom.frame.origin.x, aButtonY, mButtonBottom.frame.size.width, mButtonBottom.frame.size.height)}
            
        }
        
        if(mGradientBack != nil){mGradientBack.setRect(CGRectMake(0.0, 0.0, mW, mH))}
    }
    
    func getGradientBackground() -> DDGradient!
    {
        let aGradient:DDGradient! = nil
        return aGradient
    }
    
    func getButtonBottom() -> UIButton!
    {
        let aReturn:UIButton! = nil
        return aReturn
    }
    
    func getButtonMiddle() -> UIButton!
    {
        let aReturn:UIButton! = nil
        return aReturn
    }
    
    func getButtonTop() -> UIButton!
    {
        let aReturn:UIButton! = nil
        return aReturn
    }

    
    
    
    func click(pButton:UIButton!)
    {
        if(mForm != nil)
        {
            mForm.footerButtonClicked(pButton)
        }
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            if(mGradientBack != nil)
            {
                mGradientBack.destroy()
                self.mGradientBack = nil;
            }
            
            if(mButtonBottom != nil)
            {
                mButtonBottom.removeTarget(self, action: "click:", forControlEvents: .TouchUpInside)
                mButtonBottom.removeFromSuperview()
                self.mButtonBottom = nil
            }
            
            if(mButtonMiddle != nil)
            {
                mButtonMiddle.removeTarget(self, action: "click:", forControlEvents: .TouchUpInside)
                mButtonMiddle.removeFromSuperview()
                self.mButtonMiddle = nil
            }
            
            if(mButtonTop != nil)
            {
                mButtonTop.removeTarget(self, action: "click:", forControlEvents: .TouchUpInside)
                mButtonTop.removeFromSuperview()
                self.mButtonTop = nil
            }
            
            super.destroy()
        }
    }
}



