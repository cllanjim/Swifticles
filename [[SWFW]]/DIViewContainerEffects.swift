//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DIViewContainerEffects : DIViewContainer
{
    var mEffectImageView:UIImageView!;
    var mEffectImage:UIImage!;
    
    
    var mEffectBlur:UIVisualEffectView! = nil;
    var mEffectBlurFactor:CGFloat = 0.0
    
    var mContextR:CGFloat = 0.0;
    var mContextG:CGFloat = 0.0;
    var mContextB:CGFloat = 0.0;
    var mContextA:CGFloat = 0.0;
    
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    override init(view: DIView!){super.init(view: view);}
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        super.make(frame)
    }
    
    override func spawn()
    {
        self.spawnSafetyCheck()
        super.spawn()
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
        if(mEffectBlur != nil)
        {
            if(mEffectImage == nil)
            {
                if(mViewContainer != nil){mViewContainer.hidden = true;}
                mEffectBlur.frame = self.bounds;
                
                self.mEffectImage = self.toImage();
                self.mEffectImageView = UIImageView(frame: CGRectMake(0.0, 0.0, mW, mH))
                mEffectImageView.image = mEffectImage;
                self.addSubview(mEffectImageView);
                
                mEffectImageView.addSubview(mEffectBlur);
                mEffectImageView.alpha = mEffectBlurFactor;
                
                if(mViewContainer != nil){mViewContainer.hidden = false;}
            }
        }
        
        if(mEffectImageView != nil){self.bringSubviewToFront(mEffectImageView);}
        if(mViewContainer != nil){self.bringSubviewToFront(mViewContainer);}
    }
    
    override func initialize(){super.initialize()}
    
    override func baseUpdate()
    {
        super.baseUpdate();
        self.update();
    }
    
    
    func effectBlurLight(pct pPercent:CGFloat)
    {
        self.destroyVisualEffect();
        let aBlur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.mEffectBlur = UIVisualEffectView(effect: aBlur)
        mEffectBlur.frame = self.bounds;
        self.mEffectBlurFactor = pPercent;
        if(mViewContainer != nil){self.bringSubviewToFront(mViewContainer);}
        
        if(mW > 0){self.adjustContent();}
        
        
    }
    
    func effectBlurDark(pct pPercent:CGFloat)
    {
        self.destroyVisualEffect();
        let aBlur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        self.mEffectBlur = UIVisualEffectView(effect: aBlur)
        mEffectBlur.frame = self.bounds;
        self.mEffectBlurFactor = pPercent;
        if(mViewContainer != nil){self.bringSubviewToFront(mViewContainer);}
        
        if(mW > 0){self.adjustContent();}
    }
    
    
    
    func effectColorDark(pct pPercent:CGFloat)
    {
        self.mContextR = 0.0;
        self.mContextG = 0.0;
        self.mContextB = 0.0;
        self.mContextA = pPercent;
        
        self.backgroundColor = UIColor(red: mContextR, green: mContextG, blue: mContextB, alpha: mContextA);
    }
    
    func effectColorLight(pct pPercent:CGFloat)
    {
        self.mContextR = 1.0;
        self.mContextG = 1.0;
        self.mContextB = 1.0;
        self.mContextA = pPercent;
        
        self.backgroundColor = UIColor(red: mContextR, green: mContextG, blue: mContextB, alpha: mContextA);
    }
    
    override func setAnimationStateIn()
    {
        self.backgroundColor = UIColor(red: mContextR, green: mContextG, blue: mContextB, alpha: mContextA);
        
        if(mEffectBlur != nil)
        {
            //mEffectBlur.alpha = mEffectBlurFactor;
            
            if(mEffectImageView != nil){
                mEffectImageView.alpha = mEffectBlurFactor;}
        }
        
    }
    
    override func setAnimationStateOut()
    {
        self.backgroundColor = UIColor(red: mContextR, green: mContextG, blue: mContextB, alpha: 0.0);
        
        if(mEffectBlur != nil)
        {
            if(mEffectImageView != nil){
                mEffectImageView.alpha = 0.0;}
            
            
            //mEffectBlur.alpha = 0.0;
            
        }
    }
    
    
    func destroyVisualEffect()
    {
        if(mEffectBlur != nil)
        {
            mEffectBlur.layer.removeAllAnimations();
            mEffectBlur.removeFromSuperview();
            self.mEffectBlur = nil;
        }
        
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            self.destroyVisualEffect();
            
            if(mEffectImageView != nil)
            {
                mEffectImageView.image = nil;
                mEffectImageView.layer.removeAllAnimations();
                mEffectImageView.removeFromSuperview();
                self.mEffectImageView = nil;
            }
            
            self.mEffectImage = nil;
            
            super.destroy();
        }
    }
}



