//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DINetworkActivityIndicator : DIView
{
    var mLabelSmallTitleTop:UILabel! = nil
    var mLabelSmallTitleBottom:UILabel! = nil
    
    var mSpinnerImage:UIImage! = nil
    var mSpinnerImageView:UIImageView! = nil
    
    var mBackgroundRect:DDRoundedRect! = nil
    var mBackgroundCircle:DDCircle! = nil
    
    var mSpinnerRotation:CGFloat = 0.0
    
    var mAnimation:CGFloat = 0.0
    var mHideDelay:Int = 0
    
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
        
        
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
    }
    
    func show()
    {
        mAnimatingIn = false
        mAnimatingOut = false
        mAnimation = 1.0
        
        mHideDelay = 8
    }
    
    func showAnimated()
    {
        mAnimatingIn = true
        mAnimatingOut = false
        
        mHideDelay = 8
    }
    
    func hide()
    {
        mAnimatingIn = false
        mAnimatingOut = false
        mAnimation = 0.0
        updateAnimation()
    }
    
    func hideAnimated()
    {
        mAnimatingOut = true
    }
    
    //
    //var mSpinnerImage:UIImage! = nil
    //var mSpinnerImageView:UIImageView! = nil

    func generateSpinner()
    {
        self.mSpinnerImage = UIImage(named: "network_activity_spinner.png")
        
        if(mSpinnerImage != 0)
        {
            var aSize:CGFloat = mSpinnerImage.size.width
            
            if(aSize > 6.0)
            {
                aSize /= 2.0
                self.mSpinnerImageView = UIImageView(frame: CGRectMake(-(aSize / 2.0), -(aSize / 2.0), aSize, aSize))
                mSpinnerImageView.image = mSpinnerImage
                self.addSubview(mSpinnerImageView)
            }
        }
    }
    
    func setUp()
    {
        //mBackgroundCircle
        
        self.mBackgroundRect = DDRoundedRect(frame: CGRectMake(0.0, 0.0, mW, mH))
        
        
        let aM:CGFloat = 0.32
        mBackgroundRect.mColorStart = UIColor(red: 0.80 * aM, green: 0.76 * aM, blue: 0.93 * aM, alpha: 1.0)
        mBackgroundRect.mColorEnd = UIColor(red: 0.73 * aM, green: 0.74 * aM, blue: 0.90 * aM, alpha: 1.0)
        mBackgroundRect.mStrokeColor = UIColor(red: 0.78 * aM, green: 0.72 * aM, blue: 0.85 * aM, alpha: 0.4)
        mBackgroundRect.mStrokeWidth = 2.0
        mBackgroundRect.mCornerRadius = 8.0
        
        mBackgroundRect.layer.shadowColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0).CGColor
        mBackgroundRect.layer.shadowOffset = CGSizeMake(-1.0, 2.4)
        mBackgroundRect.layer.shadowOpacity = 0.6
        mBackgroundRect.layer.shadowRadius = 3.0
        
        self.addSubview(mBackgroundRect)
        mBackgroundRect.mkchk(CGRectMake(0.0, 0.0, mW, mH))
        
        
        self.mBackgroundCircle = DDCircle(pCenter: CGPointMake(mW2, mH2), pRadius: mW2 * 0.50)
        mBackgroundCircle.mFillColor = UIColor(red: 0.73 * aM * 0.87, green: 0.74 * aM * 0.87, blue: 0.90 * aM * 0.87, alpha: 1.0)
        //mBackgroundCircle.mStrokeWidth = 1.0
        //mBackgroundCircle.mStrokeColor = UIColor(red: 0.71, green: 0.71, blue: 0.87, alpha: 1.0)
        self.addSubview(mBackgroundCircle)
        mBackgroundCircle.mkchk()
        
        self.mLabelSmallTitleTop = UILabel(frame: CGRectMake(0.0, -2.0, mW, 34.0))
        mLabelSmallTitleTop.font = UIFont(name: "Arial-BoldMT", size: 11.0)
        mLabelSmallTitleTop.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mLabelSmallTitleTop.numberOfLines = 2
        mLabelSmallTitleTop.textAlignment = NSTextAlignment.Center
        //mLabelSmallTitleTop.text = "Calling the server... Server Server Server!!";
        self.addSubview(mLabelSmallTitleTop)
        
        self.mLabelSmallTitleBottom = UILabel(frame: CGRectMake(0.0, mH - 34.0, mW, 34.0))
        mLabelSmallTitleBottom.font = UIFont(name: "Arial-BoldMT", size: 11.0)
        mLabelSmallTitleBottom.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mLabelSmallTitleBottom.numberOfLines = 2
        mLabelSmallTitleBottom.textAlignment = NSTextAlignment.Center
        mLabelSmallTitleBottom.text = "Loading Data...";
        self.addSubview(mLabelSmallTitleBottom)
        
    }
    
    
    func updateAnimation()
    {
        
        var aRot = CGFloat ((1.0 - mAnimation) * gMath.PI_2)
        let aSin:CGFloat = sin(aRot  * gMath.PI_2);
        
        aRot = (aRot * 0.5 + aSin * 0.5)
        
        var aExtraScale:CGFloat = (1.0 - mAnimation)
        
        aExtraScale = (aExtraScale * aExtraScale * aExtraScale)
        
        let aScale:CGFloat = (aExtraScale) * 0.06 + 1.0
        
        var aTran:CGAffineTransform = CGAffineTransformIdentity
        
        aTran = CGAffineTransformTranslate(aTran, 0.0, (1.0 - mAnimation) * -14.0)
        
        aTran = CGAffineTransformScale(aTran, aScale, aScale)
        
        self.transform = aTran
        self.alpha = mAnimation
    }
    
    
    override func baseUpdate()
    {
        
        if(mAnimatingIn == true)
        {
            mAnimation += 0.04;
            if(mAnimation >= 1.0){mAnimation = 1.0;mAnimatingIn = false;}
            updateAnimation();
        }
        else if(mAnimatingOut == true)
        {
            
            if(mHideDelay > 0){mHideDelay--;}
            
            if(mHideDelay <= 0)
            {
                mAnimation -= 0.036;
                if(mAnimation <= 0.0){mAnimation = 0.0;mAnimatingOut = false;}
            }
            updateAnimation();
        }
        
        
        
        mSpinnerRotation += 4.0
        if(mSpinnerRotation >= 360.0)
        {
            mSpinnerRotation -= 360.0
        }
        
        if(mSpinnerImageView != nil)
        {
            var aTran:CGAffineTransform = CGAffineTransformIdentity
            
            aTran = CGAffineTransformTranslate(aTran, mW2, mH2)
            aTran = CGAffineTransformRotate(aTran, mSpinnerRotation * gMath.D_R)
            aTran = CGAffineTransformScale(aTran, 0.78, 0.78)
            
            mSpinnerImageView.transform = aTran
        }
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            if(mBackgroundRect != nil)
            {
                mBackgroundRect.destroy()
                self.mBackgroundRect = nil
            }
            
            if(mSpinnerImageView != nil)
            {
                mSpinnerImageView.image = nil
                mSpinnerImageView.removeFromSuperview()
                self.mSpinnerImageView = nil
            }
            
            if(mLabelSmallTitleTop != nil)
            {
                mLabelSmallTitleTop.removeFromSuperview()
                self.mLabelSmallTitleTop = nil
            }
            
            super.destroy()
        }
    }
}



