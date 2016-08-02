//
//  DIPageElement.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/20/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit



class DIElement : DIView
{
    var mElementGroup:DIElementGroup! = nil
    
    var mPaddingLeft:CGFloat = 0.0
    var mPaddingRight:CGFloat = 0.0
    var mPaddingTop:CGFloat = 0.0
    var mPaddingBottom:CGFloat = 0.0
    
    var mBackground:DIElement!
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        super.make(frame)
    }
    
    override func spawn()
    {
        self.spawnSafetyCheck()
        super.spawn()
        
        if(self.mBackground == nil)
        {
            self.mBackground = self.getBackground();
            if(mBackground != nil)
            {
                self.addSubview(mBackground)
                mBackground.mkchk(CGRectMake(0.0, 0.0, mW, mH))
            }
        }
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
        if(mBackground != nil)
        {
            mBackground.setRect(CGRectMake(0.0, 0.0, mW, mH))
        }
    }
    
    func getBackground() -> DIElement!
    {
        return nil;
    }
    
    func setBackground(pElement:DIElement!)
    {
        self.destroyBackground()
        if(pElement != nil)
        {
            self.mBackground = pElement
            mBackground.setRect(CGRectMake(0.0, 0.0, mW, mH));
            self.addSubview(mBackground)
            mBackground.mkchk()
            self.adjustContent()
        }
    }
    
    
    
    
    
    func destroyBackground(){if(mBackground != nil){mBackground.destroy();self.mBackground = nil;}}
    
    
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            self.destroyBackground()
            
            if(mElementGroup != nil){self.mElementGroup = nil;}
            
            super.destroy()
        }
    }
}



