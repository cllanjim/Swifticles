//
//  DILabel.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/26/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import Foundation

class DIScrollView: UIScrollView, UIScrollViewDelegate
{
    var mView:UIView!;
    
    var mX:CGFloat = 0.0;
    var mY:CGFloat = 0.0;
    var mW:CGFloat = 0.0;
    var mH:CGFloat = 0.0;
    var mW2:CGFloat = 0.0;
    var mH2:CGFloat = 0.0;
    var mCX:CGFloat = 0.0;
    var mCY:CGFloat = 0.0;
    
    var mDestroy:Bool = false;
    var mRectSet:Bool = false
    
    required init()
    {
        super.init(frame: CGRectMake(0.0, 0.0, gDS.appWidth, gDS.appHeight))
        self.setRect(CGRectMake(0.0, 0.0, 160.0, 42.0))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        self.setRect(CGRectMake(0.0, 0.0, 160.0, 42.0))
    }
    
    required override init(frame: CGRect)
    {
        super.init(frame: frame);
        self.setRect(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height))
    }
    
    init(view: UIView!, frame: CGRect)
    {
        super.init(frame: frame);
        
        self.setRect(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height));
        
        self.mView = view;
        self.addSubview(mView);
        self.delegate = self;
    }
    
    func mkchk(pFrame:CGRect)
    {
        //self.makeCheck(pFrame)
        if(mDidMake == false){self.make(CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height))}
        //self.spawnCheck()
        if(mDidSpawn == false){self.spawn()}
        
        self.mRectSet = false
        self.setRect(pFrame)
    }
    
    func mkchk()
    {
        self.mkchk(CGRectMake(mX, mY, mW, mH));
    }
    
    
    func makeSafetyCheck(){if(mDidMake == true){print("ERROR!!! Double-Make NOT ALLOWED...!");exit(0);}}
    var mDidMake:Bool = false
    func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
        self.mDidMake = true;
        self.internalAdjustContent()
    }
    
    //func makeCheck(frame: CGRect){}
    
    
    func spawnSafetyCheck()
    {
        if(mDidMake == false)
        {
            print("ERROR!!! Spawn before make ILLEGAL...!")
            sleep(100000)
        }
        
        if(mDidSpawn == true)
        {
            print("ERROR!!! Double - Spawn before make ILLEGAL...!")
            sleep(100000)
        }
    }
    var mDidSpawn:Bool = false
    func spawn(){self.spawnSafetyCheck();self.mDidSpawn = true;}
    
    func adjustContent()
    {
        self.internalAdjustContent();
        
        
        let aWidth:CGFloat=mView.frame.size.width;
        let aHeight:CGFloat=mView.frame.size.height;
        
        self.contentSize=CGSizeMake(mView.frame.size.width, mView.frame.size.height);
        
        let aFitScaleH:CGFloat = self.frame.size.width / aWidth;
        let aFitScaleV:CGFloat = self.frame.size.height / aHeight;
        var aMinZoomScale:CGFloat = aFitScaleV;
        if(aFitScaleH < aFitScaleV){aMinZoomScale = aFitScaleH;}
        
        
        var aMaxZoomScaleBase:CGFloat = aFitScaleV;
        if(aFitScaleH > aFitScaleV){aMaxZoomScaleBase = aFitScaleH;}
        
        var aMaxZoomScale:CGFloat = aMaxZoomScaleBase;
        aMaxZoomScale *= 4.0
        if(aMaxZoomScale < 2.0){aMaxZoomScale = 2.0;}
        
        self.maximumZoomScale = aMaxZoomScale;
        self.minimumZoomScale = aMinZoomScale;
        self.zoomScale = aMaxZoomScaleBase;
        self.bouncesZoom = false;
        self.bounces = false;
        
        //if(self.respondsToSelector(Selector("setAllowsRubberBanding:")))
        //{
        //    self.performSelector(Selector("setAllowsRubberBanding:"), withObject: true);
        //}
        
    }
    
    internal func internalAdjustContent()
    {
        self.mX = self.frame.origin.x;
        self.mY = self.frame.origin.y;
        self.mW = self.frame.size.width;
        self.mH = self.frame.size.height;
        self.mW2 = mW / 2.0;
        self.mH2 = mH / 2.0;
        self.mCX = mX + mW2;
        self.mCY = mY + mH2;
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews();
        
        
        let aSize:CGSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        var aFrame:CGRect = CGRectMake(self.frame.origin.x, mView.frame.origin.x, mView.frame.size.width, mView.frame.size.height);
        if(aFrame.size.width < aSize.width){aFrame.origin.x = (aSize.width - aFrame.size.width) / 2;}
        else{aFrame.origin.x = 0;}
        if (aFrame.size.height < aSize.height){aFrame.origin.y = (aSize.height - aFrame.size.height) / 2;}
        else {aFrame.origin.y = 0;}
        mView.frame = CGRectMake(aFrame.origin.x, aFrame.origin.y, aFrame.size.width, aFrame.size.height);
        
        /*
        var aTX:CGFloat = 0.0;
        var aTY:CGFloat = 0.0;
        
        let aSize:CGSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        var aFrame:CGRect = CGRectMake(self.frame.origin.x, mView.frame.origin.x, mView.frame.size.width, mView.frame.size.height);
        if(aFrame.size.width < aSize.width){aTX = (aSize.width - aFrame.size.width) / 2;}
        else{aFrame.origin.x = 0;}
        if (aFrame.size.height < aSize.height){aTY = (aSize.height - aFrame.size.height) / 2;}
        else {aFrame.origin.y = 0;}
        
        mView.transform = CGAffineTransformIdentity;
        mView.transform = CGAffineTransformMakeTranslation(aTX, aTY)
        */
    }
    
    func setRect(pRect:CGRect)
    {
        if((pRect.origin.x != mX) || (pRect.origin.y != mY) || (pRect.size.width != mW) || (pRect.size.height != mH) || (mRectSet == false))
        {
            mRectSet = true
            self.frame = CGRect(x: pRect.origin.x, y: pRect.origin.y, width: pRect.size.width, height: pRect.size.height);
            
            self.internalAdjustContent()
            if((mDidMake == true) && (mDidSpawn == true))
            {
                self.adjustContent();
            }
        }
        else{self.internalAdjustContent();}
    }
    
    func setX(pX:CGFloat){self.setRect(CGRect(x: pX, y: mY, width: mW, height: mH));}
    func setY(pY:CGFloat){self.setRect(CGRect(x: mX, y: pY, width: mW, height: mH));}
    func setWidth(pWidth:CGFloat){self.setRect(CGRect(x: mX, y: mY, width: pWidth, height: mH));}
    func setHeight(pHeight:CGFloat){self.setRect(CGRect(x: mX, y: mY, width: mW, height: pHeight));}
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView)
    {
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return mView;
    }
    
    func destroy()
    {
        if(mDestroy == false)
        {
            mDestroy = true;
            self.layer.removeAllAnimations();
            self.removeFromSuperview()
        }
    }
}
