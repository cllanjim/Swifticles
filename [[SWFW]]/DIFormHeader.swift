//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DIFormHeader : DIElement
{
    
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        super.make(frame)
        
        //
        //...
    }
    
    override func spawn()
    {
        self.spawnSafetyCheck()
        super.spawn()
        
        self.mGradientBack = self.getGradientBackground()
        if(mGradientBack != nil)
        {
            self.addSubview(mGradientBack);
            mGradientBack.mkchk(CGRectMake(0.0, 0.0, mW, mH));
        }
        
        self.mLabelTitle = self.getLabelTitle()
        if(mLabelTitle != nil){self.addSubview(mLabelTitle);}
        
        self.mButtonLeft = self.getButtonLeft()
        if(mButtonLeft != nil)
        {
            self.addSubview(mButtonLeft);
            mButtonLeft.frame = CGRectMake(mButtonLeft.frame.origin.x, mButtonLeft.frame.origin.y, mButtonLeft.frame.size.width, mButtonLeft.frame.size.height)
            
        }
        
        
        self.mButtonRight = self.getButtonRight()
        
        if(mButtonRight != nil)
        {
            self.addSubview(mButtonRight);
            mButtonRight.frame = CGRectMake(mButtonRight.frame.origin.x, mButtonRight.frame.origin.y, mButtonRight.frame.size.width, mButtonRight.frame.size.height)
        }
    }
    
    override func adjustContent()
    {
        let aTitlePaddingL:CGFloat = 6.0
        let aButtonPaddingL:CGFloat = 3.0
        
        let aTitlePaddingR:CGFloat = 6.0
        let aButtonPaddingR:CGFloat = 3.0
        
        var aLeftWidth:CGFloat = aTitlePaddingL
        var aRightWidth:CGFloat = aTitlePaddingR
        
        var aLeft:CGFloat = aTitlePaddingL
        var aRight:CGFloat = mW - aTitlePaddingR
        
        var aTop:CGFloat = gDS.getStatusBarHeight()
        var aHeight:CGFloat = mH - (aTop)
        let aH2 = (aTop + aHeight / 2.0)
        
        var aBottom:CGFloat = gDS.getStatusBarHeight()
        if(mGradientBack != nil){mGradientBack.setRect(CGRectMake(0.0, 0.0, mW, mH));}
        
        
        if(self.mButtonLeft != nil)
        {
            mButtonLeft.frame = CGRectMake(aButtonPaddingL, aH2 - mButtonLeft.frame.size.height / 2.0, mButtonLeft.frame.size.width, mButtonLeft.frame.size.height)
            aLeftWidth = ((aButtonPaddingL + mButtonLeft.frame.size.width) + aTitlePaddingL)
        }
        
        if(self.mButtonRight != nil)
        {
            mButtonRight.frame = CGRectMake(mW - (aButtonPaddingR + mButtonRight.frame.size.width), aH2 - mButtonRight.frame.size.height / 2.0, mButtonRight.frame.size.width, mButtonRight.frame.size.height)
            aRightWidth = (aTitlePaddingR + mButtonRight.frame.size.width + aButtonPaddingR)
        }
        
        var aPaddingWidth:CGFloat = aLeftWidth
        if(aRightWidth > aPaddingWidth){aPaddingWidth = aRightWidth}
        aRight = (mW - aPaddingWidth)
        aLeft = aPaddingWidth
        
        if(mLabelTitle != nil){mLabelTitle.frame = CGRectMake(aLeft, aTop, (aRight - aLeft), (mH - aTop))}
    }
    
    
    var mForm:DIForm! = nil
    var mLabelTitle:DILabel! = nil
    var mLabelSubtitle:DILabel! = nil
    var mButtonLeft:UIButton! = nil
    var mButtonRight:UIButton! = nil
    var mGradientBack:DDGradient! = nil
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    override func initialize(){}
    
    func getGradientBackground() -> DDGradient!
    {
        let aGradient:DDGradient = DDGradient(frame: CGRectMake(0.0, 0.0, mW, mH))
        aGradient.addColor(UIColor(red: 0.72, green: 0.74, blue: 0.81, alpha: 1.0), pPos: 0.0)
        aGradient.addColor(UIColor(red: 0.76, green: 0.78, blue: 0.75, alpha: 1.0), pPos: 1.0)
        return aGradient
    }
    
    func getButtonLeft() -> UIButton!{return nil;}
    func getButtonRight() -> UIButton!{return nil;}
    
    func getLabelTitle() -> DILabel!
    {
        let aReturn:DILabel! = DILabel()
        aReturn.font = UIFont(name: "Arial-BoldMT", size: 18.0)
        //aReturn.font = UIFont(name: "Arial", size: 17.0)
        aReturn.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        aReturn.numberOfLines = 2
        aReturn.textAlignment = NSTextAlignment.Center
        return aReturn
    }
    
    func getLabelSubtitle() -> DILabel!
    {
        let aReturn:DILabel! = DILabel()
        aReturn.font = UIFont(name: "Arial", size: 12.0)
        aReturn.textColor = UIColor(red: 0.74, green: 0.76, blue: 0.82, alpha: 1.0)
        aReturn.numberOfLines = 1
        aReturn.textAlignment = NSTextAlignment.Center
        aReturn.backgroundColor = UIColor(red: 0.89, green: 0.87, blue: 0.93, alpha: 0.2)
        return aReturn
    }
    
    
    //var mButtonLeft:UIButton! = nil
    //var mButtonRight:UIButton! = nil
    //var mGradientBack:DDGradient! = nil
    
    func click(pButton:UIButton!)
    {
        if(mForm != nil)
        {
            mForm.headerButtonClicked(pButton)
        }
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            self.mForm = nil
            
            if(mGradientBack != nil)
            {
                mGradientBack.destroy()
                self.mGradientBack = nil
            }
            
            if(mLabelTitle != nil)
            {
                mLabelTitle.destroy()
                self.mLabelTitle = nil
            }
            
            if(mLabelSubtitle != nil)
            {
                mLabelSubtitle.destroy()
                self.mLabelSubtitle = nil
            }
            
            if(mButtonLeft != nil)
            {
                mButtonLeft.removeTarget(self, action: "click:", forControlEvents: .TouchUpInside)
                mButtonLeft.removeFromSuperview()
                self.mButtonLeft = nil
            }
            
            if(mButtonRight != nil)
            {
                mButtonRight.removeTarget(self, action: "click:", forControlEvents: .TouchUpInside)
                mButtonRight.removeFromSuperview()
                self.mButtonRight = nil
            }
            
            super.destroy()
        }
    }
}



