//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

public enum DIFormAction : Int{case Next = 0, Prev, Close}

public enum DIFormAlignmentHorizontal : Int{case Center = 0, Left, Right}
public enum DIFormAlignmentVertical : Int{case Center = 0, Top, Bottom}

protocol DIFormDelegate
{
    func formAction(form pForm: DIForm, action pAction:DIFormAction)
}

class DIForm : DIElement, UIScrollViewDelegate
{
    var mDelegate:DIFormDelegate! = nil
    
    var mHeader:DIFormHeader! = nil
    var mHeaderText:String! = nil
    
    var mFooter:DIFormFooter! = nil
    
    var mAlignmentV:DIFormAlignmentVertical = DIFormAlignmentVertical.Center
    var mAlignmentH:DIFormAlignmentHorizontal = DIFormAlignmentHorizontal.Center
    
    var mElements:NSMutableArray! = nil
    var mElementsTop:NSMutableArray! = nil
    var mElementsBottom:NSMutableArray! = nil
    
    var mContainer:DIView! = nil
    var mOverlayContainer:DIViewContainer! = nil;
    
    var mScrollViewMiddle:UIScrollView! = nil
    var mStretchElements:Bool = false
    
    //var mOverlayContainer:
    
    
    
    override func make(frame: CGRect)
    {
        self.makeSafetyCheck()
        super.make(frame)
    }
    
    override func spawn()
    {
        self.spawnSafetyCheck()
        super.spawn()
        
        var aContentTopY:CGFloat = 0.0
        var aContentBottomY:CGFloat = mH
        
        self.mHeader = self.getHeader()
        if(mHeader != nil)
        {
            self.addSubview(mHeader);
            mHeader.layer.zPosition = 769.0;
            mHeader.mForm = self;
            aContentTopY = mHeader.mH
            mHeader.mkchk(CGRectMake(0.0, 0.0, self.mW, aContentTopY))
            if(mHeader.mLabelTitle != nil){mHeader.mLabelTitle.text = mHeaderText;}
        }

        self.mFooter = self.getFooter()
        if(mFooter != nil)
        {
            self.addSubview(mFooter);
            mFooter.layer.zPosition = 768.0;
            mFooter.mForm = self;
            mFooter.mkchk(CGRectMake(0.0, mH - mFooter.mH, mW, mFooter.mH))
            aContentBottomY = (mH - mFooter.mH)
        }
        
        let aContentHeight:CGFloat = (aContentBottomY - aContentTopY)
        //self.mW =
        
        self.mContainer = DIView(frame: CGRectMake(0.0, aContentTopY, self.mW, aContentHeight));
        self.addSubview(mContainer)
        mContainer.mkchk(CGRectMake(0.0, aContentTopY, self.mW, aContentHeight))
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
        if(mHeader != nil){mHeader.setRect(CGRectMake(0.0, 0.0, mW, mHeader.mH));}
        if(mFooter != nil){mFooter.setRect(CGRectMake(0.0, mH - mFooter.mH, mW, mFooter.mH));}
        
        self.layoutForceElements()
        
        if(mFooter != nil){self.bringSubviewToFront(mFooter);}
        if(mHeader != nil){self.bringSubviewToFront(mHeader);}
        
        if(mOverlayContainer != nil){self.bringSubviewToFront(mOverlayContainer);}
        
    }

    
    required init(){super.init();}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    //override func preinitialize(){super.preinitialize();gDS.layoutView(self)}
    override func baseUpdate()
    {
        
        var aElement:DIElement! = nil
        
        if(mElements != nil)
        {
            for var aIndex:Int=0; aIndex<mElements.count; aIndex++
            {
                aElement = (mElements.objectAtIndex(aIndex) as! DIElement)
                if(aElement.mUpdateAllowed == true){aElement.baseUpdate()}
            }
        }
        
        if(mElementsTop != nil)
        {
            for var aIndex:Int=0; aIndex<mElementsTop.count; aIndex++
            {
                aElement = (mElementsTop.objectAtIndex(aIndex) as! DIElement)
                if(aElement.mUpdateAllowed == true){aElement.baseUpdate()}
            }
        }
        
        if(mElementsBottom != nil)
        {
            for var aIndex:Int=0; aIndex<mElementsBottom.count; aIndex++
            {
                aElement = (mElementsBottom.objectAtIndex(aIndex) as! DIElement)
                if(aElement.mUpdateAllowed == true){aElement.baseUpdate()}
            }
        }
        
        if(mHeader != nil){if(mHeader.mUpdateAllowed == true){mHeader.baseUpdate()}}
        if(mFooter != nil){if(mFooter.mUpdateAllowed == true){mFooter.baseUpdate()}}
        
        if(mOverlayContainer != nil)
        {
            mOverlayContainer.baseUpdate();
        }
        
        super.baseUpdate()
    }
    
    func getHeader() -> DIFormHeader!
    {
        let aHeader:DIFormHeader! = nil
        return aHeader
    }
    
    func getFooter() -> DIFormFooter!
    {
        let aFooter:DIFormFooter! = nil
        return aFooter
    }
    
    
    func setHeaderTitle(pText:String!)
    {
        if(pText != nil){mHeaderText = String(pText);}
        if(mHeaderText == nil){self.mHeaderText = ""}
        //self.prepHeader()
        
        if(mHeader != nil){if(mHeader.mLabelTitle != nil){mHeader.mLabelTitle.text = mHeaderText;}}
    }
    
    
    func click(pButton:UIButton!)
    {
        notifySend()
    }
    
    func flagNewEle(pEle:DIElement!)
    {
        if(pEle != nil)
        {
            if(pEle.mNotify == nil){pEle.mNotify = self}
        }
    }
    
    func addEleTop(pEle:DIElement!)
    {
        if(mElementsTop == nil){self.mElementsTop = NSMutableArray()}
        if(pEle == nil){return;}
        self.flagNewEle(pEle)
        mElementsTop.addObject(pEle)
        mContainer.addSubview(pEle)
        
        /*
        if(mContainerTop == nil)
        {
            if(mContainer == nil){self.mContainer = UIView(frame: CGRectMake(0.0, mContentTopY, self.mW, mContentHeight));self.addSubview(mContainer);}
            
            self.mContainerTop = UIView(frame: CGRectMake(0.0, 0.0, self.mW, pEle.mH + pEle.mPaddingTop + pEle.mPaddingBottom))
            mContainer.addSubview(mContainerTop)
        }
        mContainerTop.addSubview(pEle)
        */
    }
    
    func addEleBottom(pEle:DIElement!)
    {
        if(mElementsBottom == nil){self.mElementsBottom = NSMutableArray()}
        if(pEle == nil){return;}
        self.flagNewEle(pEle)
        mElementsBottom.addObject(pEle)
        mContainer.addSubview(pEle)
        
        /*
        if(mContainerBottom == nil)
        {
            if(mContainer == nil){self.mContainer = UIView(frame: CGRectMake(0.0, mContentTopY, self.mW, mContentHeight));self.addSubview(mContainer);}
            let aEleHeight:CGFloat = (pEle.mH + pEle.mPaddingBottom + pEle.mPaddingTop)
            self.mContainerBottom = UIView(frame: CGRectMake(0.0, ((0.0 + mContentHeight) - aEleHeight), self.mW, aEleHeight))
            mContainer.addSubview(mContainerBottom)
        }
        mContainerBottom.addSubview(pEle)
        */
    }
    
    func addEleMiddle(pEle:DIElement!)
    {
        if(mElements == nil){self.mElements = NSMutableArray()}
        if(pEle == nil){return;}
        self.flagNewEle(pEle)
        mElements.addObject(pEle)
        
        
        if(self.mScrollViewMiddle == nil)
        {
            
            //let aEleHeight:CGFloat = (pEle.mH + pEle.mPaddingBottom + pEle.mPaddingTop)
            self.mScrollViewMiddle = UIScrollView(frame: CGRectMake(0.0, 0.0, mContainer.mW, mContainer.mH))
            mContainer.addSubview(mScrollViewMiddle)
        }
        mScrollViewMiddle.addSubview(pEle)
    }
    
    func overlayAnimateInComplete(pContainer:DIViewContainer!)
    {
        
        
        
    }
    
    func overlayAnimateOutComplete(pContainer:DIViewContainer!)
    {
        if(pContainer != nil)
        {
            if(pContainer == mOverlayContainer)
            {
                self.destroyOverlayContainer();
            }
        }
    }
    
    func setOverlay(pContainer:DIViewContainer!)
    {
        self.destroyOverlayContainer();
        
        if(pContainer != nil)
        {
            self.mOverlayContainer = pContainer;
            
            if(mOverlayContainer.mForm == nil)
            {
                mOverlayContainer.mForm = self;
            }
            
            mOverlayContainer.setRect(CGRectMake(0.0, 0.0, mW, mH));
            mOverlayContainer.layer.zPosition = 2048.0;
            
            self.addSubview(mOverlayContainer);
            mOverlayContainer.mkchk(CGRectMake(0.0, 0.0, mW, mH));
            
            self.adjustContent();
        }
    }
    
    func getHeight(arr pArray:NSMutableArray!) -> CGFloat
    {
        var aReturn:CGFloat = 0.0
        
        if(pArray != nil)
        {
            for var aIndex:NSInteger=0; aIndex<pArray.count; aIndex++
            {
                let aElement:DIElement! = (pArray.objectAtIndex(aIndex) as! DIElement)
                if(aElement != nil){aReturn += (aElement.mH + aElement.mPaddingBottom + aElement.mPaddingTop);}
            }
        }
        return aReturn
    }
    
    
    
    func getHeightTop() -> CGFloat{return getHeight(arr: mElementsTop)}
    func getHeightMiddle() -> CGFloat{return getHeight(arr: mElements)}
    func getHeightBottom() -> CGFloat{return getHeight(arr: mElementsBottom)}
    
    
    func getContentTopY() -> CGFloat{if(mHeader != nil){return mHeader.mH}else{return 0.0;}}
    func getContentCenterY() -> CGFloat{return (self.getContentTopY() + self.getContentHeight() / 2.0);}
    
    func getContentBottomY() -> CGFloat{return (self.getContentTopY() + self.getContentHeight());}
    
    func getContentHeight() -> CGFloat
    {
        var aReturn:CGFloat = mH;
        if(mHeader != nil){aReturn -= mHeader.mH}
        if(mFooter != nil){aReturn -= mFooter.mH}
        return aReturn;
    }
    
    func getContentSize() -> CGSize{return CGSizeMake(mW, self.getContentHeight());}
    
    func getContentFrame() -> CGRect
    {
        var aY:CGFloat = 0.0
        if(mHeader != nil){aY += mHeader.mH}
        var aHeight:CGFloat = (mH - aY)
        if(mFooter != nil){aHeight -= mFooter.mH}
        return CGRectMake(0.0, aY, mW, aHeight)
    }
    
    func getFreeHeight() -> CGFloat
    {
        let aAvailableHeight:CGFloat = (((self.getContentHeight() - (self.getHeightBottom())) - getHeightTop()) - self.getHeightMiddle())
        return aAvailableHeight
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView){}
    func scrollViewDidZoom(scrollView: UIScrollView){}
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?{return nil;}
    
    func headerButtonClicked(pButton:UIButton!)
    {
        if((mHeader != nil) && (pButton != nil))
        {
            
        }
    }
    
    func footerButtonClicked(pButton:UIButton!)
    {
        if((mFooter != nil) && (pButton != nil))
        {
            
        }
    }
    
    
    internal func layoutForceElementsInView(arr pArray:NSMutableArray!, view pView:UIView!, offset pOffsetY:CGFloat, reverse pReverse:Bool, alignV pAlignV:DIFormAlignmentVertical) -> CGFloat
    {
        if(pArray == nil){return 0.0}
        if(pView == nil){return 0.0}
        
        let aCount:Int = pArray.count;
        let aCount1:Int = (aCount - 1);
        
        var aY:CGFloat = 0.0
        
        if(pAlignV == DIFormAlignmentVertical.Center)
        {
            aY = ((pView.frame.size.height / 2.0) - (getHeight(arr: pArray) / 2.0))
        }
        else if(pAlignV == DIFormAlignmentVertical.Bottom)
        {
            aY = ((pView.frame.size.height) - getHeight(arr: pArray))
        }
        
        var aX:CGFloat = 0.0
        var aWidth:CGFloat = 0.0
        
        for var aIndex:Int=0; aIndex<aCount; aIndex++
        {
            var aElement:DIElement! = nil
            if(pReverse == true){aElement = (pArray.objectAtIndex(aIndex) as! DIElement);}
            else{aElement = (pArray.objectAtIndex(aCount1 - aIndex) as! DIElement);}
            
            if(aElement != nil)
            {
                aY += aElement.mPaddingTop
                
                if(mStretchElements == true)
                {
                    aX = mPaddingLeft
                    aWidth = (mW - (mPaddingLeft + mPaddingRight + aElement.mPaddingLeft + aElement.mPaddingRight));}
                else
                {
                    aWidth = aElement.mW;
                    aX = ((self.mW / 2.0) - (aWidth / 2.0))
                }
                
                aElement.mkchk(CGRectMake(aX + aElement.mPaddingLeft, aY, aWidth, aElement.mH))
                aY += (aElement.mH + aElement.mPaddingBottom);
            }
        }
        return aY
    }
    
    
    internal func layoutForceElements()
    {
        let aContentTopY:CGFloat = self.getContentTopY()
        let aContentHeight:CGFloat = self.getContentHeight()
        
        let aTopHeight:CGFloat = self.getHeightTop()
        let aBottomHeight:CGFloat = self.getHeightBottom()
        
        let aContentBottom:CGFloat = (aContentTopY + aContentHeight)
        
        let aMainBottom:CGFloat = (aContentBottom - (aBottomHeight))
        let aMainHeight:CGFloat = (aMainBottom - aTopHeight)
        
        mContainer.frame = CGRectMake(0.0, aContentTopY, self.mW, aContentHeight);
        
        if(mScrollViewMiddle != nil){mScrollViewMiddle.frame = CGRectMake(0.0, aTopHeight, self.mW, aMainHeight);}
        
        self.layoutForceElementsInView(arr: mElementsTop, view: mContainer, offset:0.0, reverse: true, alignV: DIFormAlignmentVertical.Top)
        self.layoutForceElementsInView(arr: mElementsBottom, view: mContainer, offset:(aContentBottom - aBottomHeight), reverse: true, alignV: DIFormAlignmentVertical.Bottom)
        
        let aMiddleHeight:CGFloat = self.getHeightMiddle()
        if(mScrollViewMiddle != nil)
        {
            if(aMiddleHeight >= mScrollViewMiddle.frame.size.height){mScrollViewMiddle.contentSize = CGSizeMake(mScrollViewMiddle.frame.size.width, aMiddleHeight)}
            else{mScrollViewMiddle.contentSize = CGSizeMake(mScrollViewMiddle.frame.size.width, mScrollViewMiddle.frame.size.height)}
            self.layoutForceElementsInView(arr: mElements, view: mScrollViewMiddle, offset:0.0, reverse: false, alignV: DIFormAlignmentVertical.Top)
        }
    }
    
    
    
    func destroyOverlayContainer()
    {
        if(mOverlayContainer != nil)
        {
            mOverlayContainer.destroy();
            self.mOverlayContainer = nil;
        }
    }
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            self.destroyOverlayContainer();
            
            if(mElementsTop != nil)
            {
                for var aIndex:Int=0;aIndex<mElementsTop.count; aIndex++
                {
                    let aElement:DIElement! = (mElementsTop.objectAtIndex(aIndex) as! DIElement)
                    aElement.destroy()
                }
                mElementsTop.removeAllObjects()
                self.mElementsTop = nil
            }
            
            if(mElements != nil)
            {
                for var aIndex:Int=0;aIndex<mElements.count; aIndex++
                {
                    let aElement:DIElement! = (mElements.objectAtIndex(aIndex) as! DIElement)
                    aElement.destroy()
                }
                mElements.removeAllObjects()
                self.mElements = nil
            }
            
            if(mElementsBottom != nil)
            {
                for var aIndex:Int=0;aIndex<mElementsBottom.count; aIndex++
                {
                    let aElement:DIElement! = (mElementsBottom.objectAtIndex(aIndex) as! DIElement)
                    aElement.destroy()
                }
                mElementsBottom.removeAllObjects()
                self.mElementsBottom = nil
            }
            
            self.mHeaderText = nil
            
            if(mHeader != nil)
            {
                mHeader.destroy();
                self.mHeader = nil;
            }
            
            if(mFooter != nil)
            {
                mFooter.destroy();
                self.mFooter = nil;
            }
            
            if(mScrollViewMiddle != nil)
            {
                mScrollViewMiddle.delegate = nil;
                mScrollViewMiddle.removeFromSuperview();
                self.mScrollViewMiddle = nil;
            }
            
            super.destroy()
        }
    }
}



