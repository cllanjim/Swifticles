//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DIButtonGlowing : DIButtonView
{
    var mButtonFade:CGFloat = 0.0
    var mButtonFadePrevious:CGFloat = 0.0
    var mButtonFadeSpeed:CGFloat = 0.09
    
    
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
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
    }
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    override func getLabelTitle() -> DILabel!
    {
        let aLabel:DILabel! = DILabel(frame: CGRectMake(0.0, 0.0, mW, mH))
        aLabel.font = gConfig.fontCellTitleBold()
        aLabel.textAlignment = NSTextAlignment.Center
        aLabel.textColor = UIColor(red: 0.54, green: 0.54, blue: 0.54, alpha: 1.0)
        return nil;
    }
    
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
        super.baseUpdate();
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            super.destroy()
        }
    }
}



