//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DIFormNetwork : DIForm, DNetWebServiceDelegate
{
    var mWebService:DNetWebService! = nil
    var mWebServiceDestroy:Bool = false
    
    var mActivityContainer:DINetworkActivityContainer! = nil
    //var mActivityIndicator:DINetworkActivityIndicator! = nil
    
    var mActivityBlocksHeader:Bool = true
    var mActivityBlocksFooter:Bool = true
    
    
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
    
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    override func initialize(){self.updateStart()}
    
    
    override func baseUpdate()
    {
        if(mActivityContainer != nil)
        {
            mActivityContainer.baseUpdate()
        }
        
        super.baseUpdate()
        self.update()
    }
    
    override func overlayAnimateInComplete(pContainer:DIViewContainer!)
    {
        
        
    }
    
    override func overlayAnimateOutComplete(pContainer:DIViewContainer!)
    {
        if(mActivityContainer != nil)
        {
            self.destroyActivityContainer();
        }
    }
    
    
    func activitySpawn()
    {
        if(mActivityContainer != nil)
        {
            self.bringSubviewToFront(mActivityContainer)
        }
        else
        {
            self.mActivityContainer = self.getActivityContainer()
            
            if(mActivityContainer != nil)
            {
                //mActivityContainer.effectBlurDark(pct: 0.15)
                mActivityContainer.effectColorDark(pct: 0.44);
                
                
                mActivityContainer.mForm = self;
                mActivityContainer.mNotify = self;
                mActivityContainer.layer.zPosition = 2400.0
                
                self.addSubview(mActivityContainer)
                mActivityContainer.mkchk()
                mActivityContainer.setIndicator(self.getActivityIndicator())
                mActivityContainer.adjustContent()
                
            }
        }
    }
    
    func activityShow()
    {
        activitySpawn()
        if(mActivityContainer != nil)
        {
            mActivityContainer.setAnimationStateIn();
        }
    }
    
    func activityShowAnimated()
    {
        activitySpawn()
        if(mActivityContainer != nil)
        {
            mActivityContainer.animateIn(time: 0.7)
            //mActivityContainer.showAnimated()
            
        }
    }
    
    func activityHide()
    {
        self.destroyActivityContainer();
        
    }
    
    func activityHideAnimated()
    {
        if(mActivityContainer != nil)
        {
            mActivityContainer.animateOut(time: 0.7)
        }
    }
    
    
    
    func setWebService(pWS:DNetWebService!)
    {
        self.destroyWebService()
        self.mWebService = pWS
        if(mWebService != nil)
        {
            if(mWebService.mActive)
            {
                self.webServiceDidStart(mWebService)
            }
        }
        
    }
    
    func getActivityIndicatorRect() -> CGRect
    {
        let aContainerRect:CGRect = self.getActivityContainerRect()
        
        let aWidth:CGFloat = 136.0
        let aHeight:CGFloat = 136.0
        
        return CGRectMake((aContainerRect.size.width / 2.0) - (aWidth / 2.0),
            (aContainerRect.size.height / 2.0) - (aHeight / 2.0), aWidth, aHeight)
    }
    
    func getActivityIndicator() -> DINetworkActivityIndicator!
    {
        let aIndicatorRect:CGRect = self.getActivityIndicatorRect()
        
        let aIndicator:DINetworkActivityIndicator = DINetworkActivityIndicator(frame: aIndicatorRect)
        
        aIndicator.mkchk(aIndicatorRect);
        
        aIndicator.setUp()
        aIndicator.generateSpinner()
        
        aIndicator.userInteractionEnabled = true;
        
        return aIndicator
    }
    
    func getActivityContainerRect() -> CGRect
    {
        var aTopY:CGFloat = 0.0
        if((mActivityBlocksHeader == false) && (mHeader != nil)){aTopY += mHeader.mH}
        
        var aBottomY:CGFloat = mH
        if((mActivityBlocksFooter == false) && (mFooter != nil)){aBottomY -= mFooter.mH}
        
        return CGRectMake(0.0, aTopY, mW, (aBottomY - aTopY))
    }
    
    func getActivityContainer() -> DINetworkActivityContainer!
    {
        let aContainerRect:CGRect = self.getActivityContainerRect()
        let aContainer:DINetworkActivityContainer = DINetworkActivityContainer(frame: aContainerRect)
        
        return aContainer
    }
    
    
    
    func destroyActivityContainer()
    {
        if(mActivityContainer != nil)
        {
            mActivityContainer.destroy()
            self.mActivityContainer = nil
        }
    }
    
    func destroyWebService()
    {
        if(mWebService != nil)
        {
            if(gDS.objectsEqual(self, pObj2: mWebService.mDelegate as! NSObject))
            {
                mWebService.mDelegate = nil
            }
        }
        
        if(mWebServiceDestroy == true)
        {
            if(mWebService != nil)
            {
                mWebService.destroy()
            }
        }
        self.mWebService = nil
    }
    
    
    
    func webServiceDidStart(pWS: DNetWebService)
    {
        if(getNode().mUpdateTicks <= 5)
        {
            self.activityShow()
        }
        else
        {
            self.activityShowAnimated()
        }
    }

    func webServiceDidSucceed(pWS: DNetWebService)
    {
        if(mActivityContainer != nil)
        {
            mActivityContainer.animateOut(time: 0.95);
        }
    }
    
    func webServiceDidFail(pWS: DNetWebService)
    {
        if(mActivityContainer != nil)
        {
            mActivityContainer.animateOut(time: 0.95);
            
            //mActivityContainer.hideAnimated()
        }
    }

    func webServiceDidReceiveResponse(pWS: DNetWebService)
    {
        
    }
    
    func webServiceDidUpdate(pWS: DNetWebService)
    {
        
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            destroyActivityContainer()
            destroyWebService()
            
            super.destroy()
        }
    }
}



