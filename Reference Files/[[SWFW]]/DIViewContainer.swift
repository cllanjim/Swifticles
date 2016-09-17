//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DIViewContainer : DIElement
{
    var mView:DIView! = nil;
    var mViewContainer:DIView! = nil;
    
    var mFit:Bool = false;
    var mFitRect:CGRect = CGRectMake(0.0, 0.0, 256, 256);
    
    var mForm:DIForm! = nil;
    
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    init(view: DIView!){super.init();self.setView(view: view);}
    
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
        
        if(mViewContainer != nil)
        {
            if(mView != nil)
            {
                if(mFit == true)
                {
                    var aBox:CGRect = CGRectMake(0.0, 0.0, mFitRect.size.width, mFitRect.size.height);
                    
                    let aFitScale:CGFloat = gDS.getRectAspectFitScale(frame: aBox, size: CGSizeMake(mView.mW, mView.mH), border: 0.0);
                    let aFitRect:CGRect = gDS.getRectAspectFit(frame: aBox, size: CGSizeMake(mView.mW, mView.mH), border: 0.0);
                    
                    aBox = aFitRect;
                    aBox = self.centerRect(aBox);
                    
                    mViewContainer.setRect(aBox);
                    
                    if(aFitScale != 1.0)
                    {
                        var aTransform:CGAffineTransform = CGAffineTransformIdentity;
                        aTransform = CGAffineTransformScale(aTransform, aFitScale, aFitScale);
                        
                        mViewContainer.transform = aTransform;
                        mViewContainer.setRect(aBox);
                    } 
                }
                else
                {
                    mViewContainer.setRect(self.centerRect(CGRectMake(0.0, 0.0, mView.mW, mView.mH)));
                }
                
                mViewContainer.mkchk();
                mView.mkchk();
            }
        }
    }
    
    override func initialize(){super.initialize()}
    
    func setFitRect(pRect: CGRect)
    {
        mFit = true;
        mFitRect = CGRectMake(pRect.origin.x, pRect.origin.y, pRect.size.width, pRect.size.height);
    }
    
    func setView(view pView:DIView!)
    {
        destroyView();
        
        if(pView != nil)
        {
            
            if(mViewContainer == nil)
            {
                self.mViewContainer = DIView(frame: CGRectMake(0.0, 0.0, mW, mH));
                self.addSubview(mViewContainer);
                mViewContainer.layer.borderWidth = 1;
                mViewContainer.layer.borderColor = UIColor.orangeColor().CGColor;
            }
            
            self.mView = pView;
            mViewContainer.addSubview(mView);
            mView.setRect(CGRectMake(0.0, 0.0, mView.mW, mView.mH));
            self.adjustContent();
        }
    }
    
    override func animateInComplete()
    {
        if(mForm != nil){mForm.overlayAnimateInComplete(self);}
    }
    
    override func animateOutComplete()
    {
        if(mForm != nil){mForm.overlayAnimateOutComplete(self);}
    }
    
    override func allowAction() -> Bool
    {
        if(super.allowAction() == false)
        {
            return false;
        }
        
        if(mView != nil)
        {
            if(mView.allowAction() == false)
            {
                return false;
            }
        }
        
        if(mViewContainer != nil)
        {
            if(mViewContainer.allowAction() == false)
            {
                return false;
            }
        }
        
        return true;
    }
    
    func destroyView()
    {
        if(mView != nil)
        {
            mView.destroy();
            self.mView = nil;
        }
        
        if(mViewContainer != nil)
        {
            mViewContainer.destroy();
            self.mViewContainer = nil;
        }
        
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            self.destroyView();
            
            super.destroy()
        }
    }
}



