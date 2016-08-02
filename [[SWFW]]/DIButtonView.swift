//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DIButtonView : DIElement
{
    var mLabelTitle:DILabel!;
    var mButton:DIButton!
    
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
        
        self.mButton = DIButton(frame: CGRectMake(0.0, 0.0, mW, mH))
        if(self.mButton != nil)
        {
            self.addSubview(mButton);
            mButton.addTarget(self, action: "click:", forControlEvents: .TouchUpInside)
            mButton.mkchk(CGRectMake(0.0, 0.0, mW, mH))
        }
        
        
        
        self.mLabelTitle = self.getLabelTitle();
        if(self.mLabelTitle != nil)
        {
            self.addSubview(mLabelTitle)
            mLabelTitle.setRect(CGRectMake(0.0, 0.0, mW, mH))
        }
    }
    
    override func adjustContent()
    {
        super.adjustContent()

        
        
        
        
        if(mButton != nil)
        {
            mButton.setRect(CGRectMake(0.0, 0.0, mW, mH));
            self.bringSubviewToFront(mButton);
        }
        
        if(mLabelTitle != nil)
        {
            mLabelTitle.setRect(CGRectMake(0.0, 0.0, mW, mH))
            self.bringSubviewToFront(mLabelTitle);
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

    func click(pButton:UIButton!)
    {
        self.notifySend();
    
        if(mParent != nil)
        {
            if(mParent.allowAction() == true)
            {
            if(mParent.respondsToSelector(Selector("buttonClick:")))
            {
                mParent.performSelectorOnMainThread(Selector("buttonClick:"), withObject: self, waitUntilDone: true);
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
                    aView.buttonClick(self);
                }
                
            }
            else
            {
            if(mNotify.respondsToSelector(Selector("buttonClick:")))
            {
                mNotify.performSelectorOnMainThread(Selector("buttonClick:"), withObject: self, waitUntilDone: true);
            }
            }
        }
    }
    
    func destroyButton()
    {
        if(mButton != nil)
        {
            mButton.removeTarget(self, action: "click", forControlEvents: .TouchUpInside)
            mButton.removeFromSuperview()
            self.mButton = nil
        }
    }
    
    
    func destroyLabelTitle(){if(mLabelTitle != nil){ mLabelTitle.layer.removeAllAnimations();mLabelTitle.removeFromSuperview();self.mLabelTitle = nil;}}
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            
            self.destroyLabelTitle()
            self.destroyButton()
            super.destroy()
        }
    }
}



