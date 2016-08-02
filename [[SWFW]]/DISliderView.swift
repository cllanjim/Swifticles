//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DISliderView : DIElement
{
    var mLabelTitle:DILabel!;
    var mSlider:DISlider!
    
    var mMin:CGFloat = 0.0
    var mMax:CGFloat = 1.0
    var mValue:CGFloat = 0.0
    var mPercent:CGFloat = 0.0
    
    
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        super.make(frame)
    }
    
    override func spawn()
    {
        self.spawnSafetyCheck()
        super.spawn()
        
        self.mSlider = DISlider(frame: CGRectMake(0.0, 0.0, mW, mH))
        if(self.mSlider != nil)
        {
            self.addSubview(mSlider);
            mSlider.continuous = true
            mSlider.tintColor = UIColor.blueColor()
            mSlider.addTarget(self, action: "sliderMoveInternal:", forControlEvents: .ValueChanged);
            mSlider.mkchk(CGRectMake(0.0, 0.0, mW, mH));
            mSlider.minimumValue = Float(0.0);
            mSlider.maximumValue = Float(1.0);
        }
        
        
        
        self.mLabelTitle = self.getLabelTitle();
        if(self.mLabelTitle != nil)
        {
            self.addSubview(mLabelTitle)
            mLabelTitle.frame = CGRectMake(0.0, 0.0, mW2 * 0.5, mH)
            mLabelTitle.text = "Slider";
        }
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
        var aLabelWidth:CGFloat = mW2 * 0.5;
        
        
        if(mLabelTitle != nil)
        {
            mLabelTitle.setRect(CGRectMake(0.0, 0.0, aLabelWidth, mH))
        }
        
        if(mSlider != nil)
        {
            mSlider.setRect(CGRectMake(aLabelWidth, 0.0, mW - aLabelWidth, mH))
            self.bringSubviewToFront(mSlider);
        }
    }
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    func getLabelTitle() -> DILabel!
    {
        let aLabel:DILabel! = DILabel(frame: CGRectMake(0.0, 0.0, mW, mH))
        aLabel.font = gConfig.fontCellTitleBold()
        aLabel.textAlignment = NSTextAlignment.Center
        aLabel.textColor = UIColor(red: 0.54, green: 0.54, blue: 0.54, alpha: 1.0)
        return aLabel
    }
    
    func setTextTitle(pString:String!)
    {if(self.mLabelTitle != nil){mLabelTitle.text = String(pString);}}
    
    func sliderMoveInternal(sender:UISlider!)
    {
        mPercent = CGFloat(mSlider.value);
        mValue = mMin + (mMax - mMin) * mPercent;
        
        if(mParent != nil)
        {
            if(mParent.allowAction() == true)
            {
            if(mParent.respondsToSelector(Selector("sliderMove:")))
            {
                mParent.performSelectorOnMainThread(Selector("sliderMove:"), withObject: self, waitUntilDone: true);
            }
            }
        }
        
        if(mNotify != nil)
        {
            if(mNotify.isKindOfClass(DIView))
            {
                var aView:DIView = (mNotify as! DIView);
                
                if(aView.allowAction() == true)
                {
                    aView.sliderMove(self);
                }
                
            }
            else
            {
            if(mNotify.respondsToSelector(Selector("sliderMove:")))
            {
                mNotify.performSelectorOnMainThread(Selector("sliderMove:"), withObject: self, waitUntilDone: true);
            }
            }
        }
    }
    
    
    func destroySlider()
    {
        if(mSlider != nil)
        {
            mSlider.removeTarget(self, action: "sliderMoveInternal:", forControlEvents: .ValueChanged)
            mSlider.layer.removeAllAnimations()
            mSlider.removeFromSuperview()
            self.mSlider = nil
        }
    }
    
    
    func destroyLabelTitle(){if(mLabelTitle != nil){ mLabelTitle.layer.removeAllAnimations();mLabelTitle.removeFromSuperview();self.mLabelTitle = nil;}}
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            self.destroySlider()
            super.destroy()
        }
    }
}



