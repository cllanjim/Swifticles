//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit
 
class DINetworkActivityContainer : DIViewContainerEffects
{
    var mActivityIndicator:DINetworkActivityIndicator! = nil
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck();
        super.make(frame);
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
    
    override func setAnimationStateIn()
    {
        if(mActivityIndicator != nil)
        {
            mActivityIndicator.layer.transform = CATransform3DIdentity;
            mActivityIndicator.alpha = 1.0;
            
            //mActivityIndicator.showAnimated();
            //mActivityIndicator.baseUpdate();
        }
        
        self.backgroundColor = UIColor(red: mContextR, green: mContextG, blue: mContextB, alpha: mContextA);
        
        //super.setAnimationStateIn();
        
        //self.alpha = 1.0;
    }
    override func setAnimationStateOut()
    {
        if(mActivityIndicator != nil)
        {
            mActivityIndicator.layer.transform = CATransform3DMakeScale(0.85, 0.85, 0.85);
            mActivityIndicator.alpha = 0.0;
            //mActivityIndicator.hideAnimated();
            //mActivityIndicator.baseUpdate();
        }

        
        self.backgroundColor = UIColor(red: mContextR, green: mContextG, blue: mContextB, alpha: 0.0);
        //super.setAnimationStateOut();
        
        //self.alpha = 0.0;
        
        if(mActivityIndicator != nil)
        {
            
        }
        
    }
    
    override func animateInComplete()
    {
        super.animateInComplete();
    }
    
    override func animateOutComplete()
    {
        super.animateOutComplete();
    }
    
    override func animateInDelayed(time pTime:CGFloat, del pDelay:CGFloat)
    {
        
        
        self.mAnimatingIn = true;
        self.mAnimatingOut = false;
        self.setAnimationStateOut();
        UIView.animateWithDuration(Double(pTime), delay: Double(pDelay), options: UIViewAnimationOptions.TransitionNone , animations:{self.setAnimationStateIn();}, completion: {(value: Bool) in
            self.mAnimatingIn = false;
            self.animateInComplete();
        })
        
    }
    
    override func animateOutDelayed(time pTime:CGFloat, del pDelay:CGFloat)
    {
                self.mAnimatingIn = false;
        self.mAnimatingOut = true;
        self.setAnimationStateIn();
        UIView.animateWithDuration(Double(pTime), delay: Double(pDelay), options: UIViewAnimationOptions.TransitionNone , animations:{self.setAnimationStateOut();},completion:{(value: Bool) in
            self.mAnimatingOut = false;
            self.animateOutComplete();
        })
    }
    
    override func initialize(){}
    override func setRect(pRect:CGRect){super.setRect(pRect);}
    
    func setIndicator(pActivityIndicator: DINetworkActivityIndicator!)
    {
        destroyIndicator();
        self.mActivityIndicator = pActivityIndicator;
        if(mActivityIndicator != nil){self.addSubview(mActivityIndicator);}
    }
    
    override func baseUpdate()
    {
        super.baseUpdate()
        if(mActivityIndicator != nil){mActivityIndicator.baseUpdate()}
    }
    
    func destroyIndicator()
    {
        if(mActivityIndicator != nil)
        {
            mActivityIndicator.destroy()
            self.mActivityIndicator = nil
        }
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            self.destroyIndicator()
            super.destroy()
        }
    }
}



