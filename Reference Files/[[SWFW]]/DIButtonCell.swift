//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DIButtonCell : DIButtonGlowing
{
    var mLabelTitleSpacingV:CGFloat = 4.0
    
    var mLabelValue:DILabel!;
    var mLabelValuePercentH:CGFloat = 0.40
    var mLabelValueSpacingH:CGFloat = 3.0
    
    var mLabelSubtitle:DILabel!;
    
    var mAccessoryRight:DIElement!
    var mAccessoryLeft:DIElement!
    
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
        
        
        self.mAccessoryLeft = self.getAccessoryLeft()
        if(mAccessoryLeft != nil)
        {
            self.addSubview(mAccessoryLeft);
            mAccessoryLeft.mkchk(CGRectMake(mAccessoryLeft.mX, mAccessoryLeft.mY, mAccessoryLeft.mW, mAccessoryLeft.mH))
        }
        
        self.mAccessoryRight = self.getAccessoryRight()
        if(mAccessoryRight != nil)
        {
            self.addSubview(mAccessoryRight);
            mAccessoryRight.mkchk(CGRectMake(mAccessoryRight.mX, mAccessoryRight.mY, mAccessoryRight.mW, mAccessoryRight.mH))
        }
        
        self.mLabelSubtitle = self.getLabelSubtitle();
        if(self.mLabelSubtitle != nil)
        {
            self.addSubview(mLabelSubtitle)
        }
        
        self.mLabelValue = self.getLabelValue();
        if(mLabelValue != nil)
        {
            self.addSubview(mLabelValue)
        }
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
        var aLeft:CGFloat = 0.0
        var aRight:CGFloat = mW
        
        var aPaddingLeft:CGFloat = 0.0
        var aPaddingRight:CGFloat = 0.0
        
        if(mAccessoryLeft != nil)
        {
            mAccessoryLeft.setRect(CGRectMake(mAccessoryLeft.mPaddingLeft, mH2 - mAccessoryLeft.mH2, mAccessoryLeft.mW, mAccessoryLeft.mH))
            aPaddingLeft = mAccessoryLeft.mPaddingLeft + mAccessoryLeft.mW + mAccessoryLeft.mPaddingRight
            //mAccessoryLeft.layoutPush()
            
        }
        aLeft = aPaddingLeft
        
        if(mAccessoryRight != nil)
        {
            mAccessoryRight.setRect(CGRectMake(mW - (mAccessoryRight.mPaddingRight + mAccessoryRight.mW), mH2 - mAccessoryRight.mH2, mAccessoryRight.mW, mAccessoryRight.mH))
            aPaddingRight = mAccessoryRight.mPaddingLeft + mAccessoryRight.mW + mAccessoryRight.mPaddingRight
            //mAccessoryRight.layoutPush()
            
        }
        aRight = (mW - aPaddingRight)
        
        var aPadding:CGFloat = aPaddingLeft
        if(aPaddingRight > aPadding){aPadding = aPaddingRight}
        
        var aCenteredWidth = mW - (aPadding + aPadding)
        if(aCenteredWidth < 24.0){aCenteredWidth = 24.0}
        
        var aTitleX:CGFloat = mW2 - (aCenteredWidth / 2.0)
        var aTitleY:CGFloat = 0.0
        var aTitleWidth:CGFloat = aCenteredWidth
        var aTitleHeight:CGFloat = mH2
        
        var aValueX:CGFloat = aPaddingLeft
        var aValueY:CGFloat = 0.0
        var aValueWidth:CGFloat = aCenteredWidth
        var aValueHeight:CGFloat = mH2
        
        var aSubtitleY:CGFloat = (mH2 + 6.0)
        var aSubtitleHeight:CGFloat = (mH2 - 6.0)
        
        if(mLabelTitle != nil){aTitleHeight = mLabelTitle.getHeight()}
        if(mLabelValue != nil){aValueHeight = mLabelValue.getHeight()}
        if(mLabelSubtitle != nil){aSubtitleHeight = mLabelSubtitle.getHeight()}
        
        if(aTitleHeight < 1.0){aTitleHeight = mH2}
        if(aSubtitleHeight < 1.0){aSubtitleHeight = mH2}
        if(aValueHeight < 1.0){aValueHeight = mH2}
        
        if(mLabelTitle != nil)
        {
            aTitleY = 0.0
            aTitleHeight = mH
            aSubtitleY = mH2
            aSubtitleHeight = mH2
            
            if(mLabelValue != nil)
            {
                aTitleX = aPaddingLeft
                aTitleWidth = ((aRight - aLeft) * (mLabelValuePercentH) - mLabelValueSpacingH * 0.5)
                aValueX = (aTitleX + aTitleWidth + mLabelValueSpacingH)
                aValueY = ((aTitleY + (aTitleHeight / 2.0)) - (aValueHeight / 2.0))
                aValueWidth = (aRight - aValueX)
            }
        }
        
        if(mButton != nil){self.bringSubviewToFront(mButton)}
        if(mAccessoryLeft != nil){self.bringSubviewToFront(mAccessoryLeft)}
        if(mAccessoryRight != nil){self.bringSubviewToFront(mAccessoryRight)}
        
        if(mLabelTitle != nil)
        {
            mLabelTitle.frame = CGRectMake(aTitleX, aTitleY, aTitleWidth, aTitleHeight);
            self.bringSubviewToFront(mLabelTitle);
        }
        if(mLabelValue != nil)
        {
            mLabelValue.frame = CGRectMake(aValueX, aValueY, aValueWidth, aValueHeight);
            self.bringSubviewToFront(mLabelValue);
        }
        if(mLabelSubtitle != nil)
        {
            mLabelSubtitle.frame = CGRectMake(aTitleX - 2.0, aSubtitleY, aTitleWidth + 4.0, aSubtitleHeight);
            self.bringSubviewToFront(mLabelSubtitle);
        }
        
    }
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    
    override func getBackground() -> DIElement!
    {
        return super.getBackground();
    }
    
    func getAccessoryRight() -> DIElement!
    {
        return nil
    }
    
    func getAccessoryLeft() -> DIElement!
    {
        return nil
    }
    
    override func getLabelTitle() -> DILabel!
    {
        let aLabel:DILabel! = DILabel(frame: CGRectMake(0.0, 0.0, mW, mH))
        aLabel.font = gConfig.fontCellTitleBold()
        aLabel.textAlignment = NSTextAlignment.Center
        aLabel.textColor = UIColor(red: 0.54, green: 0.54, blue: 0.54, alpha: 1.0)
        return aLabel
    }
    
    func getLabelValue() -> DILabel!{return nil}
    func getLabelSubtitle() -> DILabel!{return nil}
    
    func setTextValue(pString:String!)
    {if(self.mLabelValue != nil){mLabelValue.text = String(pString);}}
    
    func setTextSubtitle(pString:String!)
    {if(self.mLabelSubtitle != nil){mLabelSubtitle.text = String(pString);}}
    
    override func update(){}
    override func baseUpdate()
    {
        if(mButton != nil)
        {
            if((mButton.touchInside) == true && (mButton.tracking == true))
            {
                mButtonFade += mButtonFadeSpeed;
                if(mButtonFade > 1.0){mButtonFade = 1.0}
            }
            else
            {
                mButtonFade -= mButtonFadeSpeed
                if(mButtonFade < 0.0){mButtonFade = 0.0;}
            }
            
            if(mButtonFadePrevious != mButtonFade)
            {mButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: mButtonFade * 0.65)}
            
            mButtonFadePrevious = mButtonFade;
        }
        super.baseUpdate()
        self.update()
    }
    
    func destroyAccessoryRight()
    {
        if(mAccessoryRight != nil)
        {mAccessoryRight.destroy();self.mAccessoryRight = nil;}
    }
    
    func destroyAccessoryLeft()
    {
        if(mAccessoryLeft != nil)
        {mAccessoryLeft.destroy();
            self.mAccessoryLeft = nil;}
    }
    
    func destroyLabelValue(){if(mLabelValue != nil){ mLabelValue.layer.removeAllAnimations();mLabelValue.removeFromSuperview();self.mLabelValue = nil;}}
    
    func destroyLabelSubtitle(){if(mLabelSubtitle != nil){mLabelSubtitle.layer.removeAllAnimations();mLabelSubtitle.removeFromSuperview();self.mLabelSubtitle = nil;}}
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            self.destroyAccessoryRight()
            self.destroyAccessoryLeft()
            self.destroyLabelValue()
            self.destroyLabelSubtitle()
            super.destroy()
        }
    }
}



