//
//  DIElementGroup.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/20/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DIElementGroup : DIElement
{
    required init(){super.init()}
    required init?(coder aDecoder: NSCoder){super.init(coder: aDecoder)}
    required init(frame: CGRect){super.init(frame: frame);}
    
    var mElements:NSMutableArray!;
    var mElementsDetach:NSMutableArray!;
    var mElementsSpawn:NSMutableArray!;
    
    var mSelectedIndex:Int = -1
    
    var mScrollView:UIScrollView!;
    
    var mVertical:Bool = true;
    var mSpacing:CGFloat = 2.0
    
    var mFitPage:Bool = false
    var mFitStretch:Bool = true
    
    
    
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
        
        self.mScrollView = UIScrollView(frame: CGRectMake(0.0, 0.0, mW, mH))
        addSubview(mScrollView)
    }
    
    override func adjustContent()
    {
        super.adjustContent()
        
        self.mScrollView.frame = CGRectMake(0.0, 0.0, mW, mH)
        self.layoutForceElements()
    }
    
    override func update(){}
    
    override func baseUpdate()
    {
        if(mElements != nil)
        {
            var aElement:DIElement! = nil
            for var aIndex:Int=0; aIndex<mElements.count; aIndex++
            {
                aElement = (mElements.objectAtIndex(aIndex) as! DIElement)
                
                if(aElement.mUpdateAllowed == true)
                {
                    aElement.baseUpdate()
                }
            }
        }
    
        super.baseUpdate()
        self.update()
        
    }
    
    override func notifyObject(pObj:AnyObject)
    {
        var aSelectedIndex:Int = -1
        if(mElements != 0)
        {
            for var aIndex:Int=0; aIndex<mElements.count; aIndex++
            {
                let aObj1:NSObject! = mElements.objectAtIndex(aIndex) as! NSObject
                let aObj2:NSObject! = (pObj as! NSObject)
                if(aObj1 == aObj2){aSelectedIndex = aIndex}
            }
        }
        
        if(aSelectedIndex != -1)
        {
            mSelectedIndex = aSelectedIndex
            self.notifySend()
        }
    }
    
    
    func flagNewEle(pEle:DIElement!)
    {
        if(pEle != nil)
        {
            if(pEle.mNotify == nil){pEle.mNotify = self}
            pEle.mElementGroup = self
        }
    }
    
    func addPageVC(pController:DIViewController!)
    {
        if(pController == nil){return;}
        let aElement:DIElementVC = DIElementVC(vc: pController)
        aElement.setRect(getPageFrame())
        self.addElement(aElement)
    }
    
    func addPage(pEle:DIElement!)
    {
        if(pEle == nil){return}
        pEle.setRect(self.bounds)
        self.addElement(pEle)
    }
    
    func addVC(pController:DIViewController!)
    {
        self.addElement(DIElementVC(vc: pController))
    }
    
    func addElement(pEle:DIElement!)
    {
        if(mElements == nil){self.mElements = NSMutableArray()}
        if(pEle == nil){return;}
        mElements.addObject(pEle)
        
        self.flagNewEle(pEle)

        mScrollView.addSubview(pEle)
    }
    
    func getPageFrame() -> CGRect
    {
        return CGRectMake(mPaddingLeft, mPaddingRight, mW - (mPaddingRight + mPaddingLeft), mH - (mPaddingTop + mPaddingBottom))
    }
    
    func hideAllElements()
    {
        self.destroyDetachedElements()
        if(mElements != nil)
        {
            for var aIndex:Int=0; aIndex<mElements.count; aIndex++
            {
                let aElement:DIElement! = (mElements.objectAtIndex(aIndex) as! DIElement)
                aElement.hidden = true
                aElement.alpha = 0.0
                aElement.mUpdateAllowed = false
            }
            mElements.removeAllObjects()
        }
    }
    
    func destroyAllElements()
    {
        self.destroyDetachedElements()
        
        if(mElements != nil)
        {
            for var aIndex:Int=0; aIndex<mElements.count; aIndex++
            {
                (mElements.objectAtIndex(aIndex) as! DIElement).destroy()
            }
            mElements.removeAllObjects()
        }
    }
    
    func detachAllElements() -> NSMutableArray
    {
        let aArray:NSMutableArray = NSMutableArray()
        
        if(mElementsDetach == nil){self.mElementsDetach = NSMutableArray()}
        if(mElements == nil){return aArray;}
        
        for var aIndex:Int=0; aIndex<mElements.count; aIndex++
        {
            let aElement:DIElement! = (mElements.objectAtIndex(aIndex) as! DIElement)
            if(mScrollView != nil){aElement.setY(aElement.mY - mScrollView.contentOffset.y)}
            mElementsDetach.addObject(aElement)
            aElement.mUpdateAllowed = false
        }
        
        mElements.removeAllObjects()
        if(mScrollView != nil){mScrollView.contentOffset = CGPointMake(0.0, 0.0)}
        return aArray
    }
    
    func destroyDetachedElements()
    {
        if(mElementsDetach != nil)
        {
            for var aIndex:Int=0; aIndex<mElementsDetach.count; aIndex++
            {
                let aElement:DIElement! = (mElementsDetach.objectAtIndex(aIndex) as! DIElement)
                if(aElement != nil){aElement.destroy()}
            }
            
            mElementsDetach.removeAllObjects()
        }
    }
    
    func replaceElements(pNewCells:NSMutableArray)
    {
        
        self.destroyDetachedElements()
        self.detachAllElements()
        
        self.destroyDetachedElements()
        
        for var aIndex:Int=0; aIndex<pNewCells.count; aIndex++
        {
            let aElement:DIElement! = (pNewCells.objectAtIndex(aIndex) as! DIElement)
            self.addElement(aElement)
        }
        
        self.layoutForceElements()
    }
    
    func replaceElementsAnimatedCascade(pNewCells:NSMutableArray)
    {
        self.replaceElementsAnimatedCascadeExt(eleAry: pNewCells, delay: 0.1, dur:0.32, staggr: 0.08, spread: 1.0, spin: 0.8)
        
    }
    
    func replaceElementsAnimatedCascadeExt(eleAry pNewCells:NSMutableArray, delay pDelay:CGFloat, dur pDuration:CGFloat, staggr pStagger:CGFloat, spread pSpread:CGFloat, spin pSpin:CGFloat)
    {
        self.destroyDetachedElements()
        self.detachAllElements()
        
        for var aIndex:Int=0; aIndex<pNewCells.count; aIndex++
        {
            let aElement:DIElement! = (pNewCells.objectAtIndex(aIndex) as! DIElement)
            self.addElement(aElement)
        }
        
        self.layoutForceElements()
        
        var aOffScreenCount:Int = 0
        for var aIndex:Int=0; aIndex<mElementsDetach.count; aIndex++
        {
            let aElement:DIElement! = (mElementsDetach.objectAtIndex(aIndex) as! DIElement)
            if(aElement.mY < 0){aOffScreenCount++}
        }
        
        var aAnimationOut:CATransform3D = CATransform3DIdentity
        aAnimationOut.m34 = 1.0 / -700;
        aAnimationOut = CATransform3DTranslate(aAnimationOut, 0.0, 140.0 * pSpread, 0.0)
        aAnimationOut = CATransform3DRotate(aAnimationOut, gMath.PI, 1.0, 0.0, 0.0)
        
        var aAnimationIn:CATransform3D = CATransform3DIdentity;
        aAnimationIn.m34 = 1.0 / -700;
        aAnimationIn = CATransform3DTranslate(aAnimationIn, 0.0, -40.0 * pSpread, 0.0);
        aAnimationIn = CATransform3DScale(aAnimationIn, 0.85, 0.85, 0.85)
        aAnimationIn = CATransform3DRotate(aAnimationIn, -gMath.PI * 0.78, 1.0, 0.0, 0.0);
        
        for var aIndex:Int=0; aIndex<mElements.count; aIndex++
        {
            let aElement:DIElement! = (mElements.objectAtIndex(aIndex) as! DIElement)
            aElement.alpha = 0.0
            aElement.layer.transform = aAnimationIn
            aElement.layer.zPosition = 1280.0
            aElement.mUpdateAllowed = false
        }
        
        var aDelay:Double = Double(pDelay)
        for var aIndex:Int=(mElementsDetach.count - 1); aIndex>=0; aIndex--
        {
            let aElement:DIElement! = (mElementsDetach.objectAtIndex(aIndex) as! DIElement)
            if(aElement != nil)
            {
                aElement.layer.zPosition = 640.0
                UIView.animateWithDuration(Double(pDuration), delay: aDelay, options: UIViewAnimationOptions.TransitionNone , animations:
                    {
                        aElement.layer.transform = aAnimationOut
                        aElement.alpha = 0.0
                    }, completion: nil)
                if(aIndex >= aOffScreenCount){aDelay += Double(pStagger)}
            }
        }
        
        if(mElementsDetach.count > 0)
        {
            aDelay = Double(pDelay + pStagger * 3.0)
        }
        else
        {
            aDelay = Double(pDelay)
        }
        
        for var aIndex:Int=0; aIndex<mElements.count; aIndex++
        //for var aIndex:Int=(mElements.count - 1); aIndex>=0; aIndex--
        {
            let aElement:DIElement! = (mElements.objectAtIndex(aIndex) as! DIElement)
            
            aElement.alpha = 0.0
            UIView.animateWithDuration(Double(pDuration), delay: aDelay, options: UIViewAnimationOptions.TransitionNone , animations:
                {
                    aElement.alpha = 1.0
                    aElement.mUpdateAllowed = true
                    aElement.layer.transform = CATransform3DIdentity
                    }, completion: nil)
            
            aDelay += Double(pStagger)
        }
    }
    
    
    func replaceElementsAnimatedRight(pNewCells:NSMutableArray)
    {
        
        self.destroyDetachedElements()
        self.detachAllElements()
        
        for var aIndex:Int=0; aIndex<pNewCells.count; aIndex++
        {
            let aElement:DIElement! = (pNewCells.objectAtIndex(aIndex) as! DIElement)
            self.addElement(aElement)
        }
        
        self.layoutForceElements()
        
        var aOffScreenCount:Int = 0
        for var aIndex:Int=0; aIndex<mElementsDetach.count; aIndex++
        {
            let aElement:DIElement! = (mElementsDetach.objectAtIndex(aIndex) as! DIElement)
            if(aElement.mY < 0){aOffScreenCount++}
        }
        
        var aAnimationOut:CATransform3D = CATransform3DIdentity
        aAnimationOut.m34 = 1.0 / -500;
        aAnimationOut = CATransform3DTranslate(aAnimationOut, -200.0, 0.0, 0.0)
        aAnimationOut = CATransform3DRotate(aAnimationOut, gMath.PI_2 * 0.7, 0.1, 1.0, 0.0)
        
        var aAnimationIn:CATransform3D = CATransform3DIdentity;
        aAnimationIn.m34 = 1.0 / -500;
        aAnimationIn = CATransform3DTranslate(aAnimationIn, 240.0, 0.0, 0.0);
        aAnimationIn = CATransform3DRotate(aAnimationIn, gMath.PI_2 * 0.7, 0.1, 1.0, 0.0);
        
        for var aIndex:Int=0; aIndex<mElements.count; aIndex++
        {
            let aElement:DIElement! = (mElements.objectAtIndex(aIndex) as! DIElement)
            aElement.alpha = 0.0
            aElement.layer.transform = aAnimationIn
            aElement.layer.zPosition = 1280.0
            aElement.mUpdateAllowed = false
        }
        
        var aDelay:Double = 0.0
        for var aIndex:Int=0; aIndex<mElementsDetach.count; aIndex++
        {
            let aElement:DIElement! = (mElementsDetach.objectAtIndex(aIndex) as! DIElement)
            if(aElement != nil)
            {
                aElement.layer.zPosition = 640.0
                aElement.mUpdateAllowed = false
                
                UIView.animateWithDuration(0.36, delay: aDelay, options: UIViewAnimationOptions.TransitionNone , animations:
                    {
                        aElement.mUpdateAllowed = true
                        aElement.layer.transform = aAnimationOut
                        aElement.alpha = 0.0
                    }, completion: nil)
                if(aIndex >= aOffScreenCount){aDelay += 0.04}
            }
        }
        
        aDelay = 0.08
        for var aIndex:Int=0; aIndex<mElements.count; aIndex++
        {
            let aElement:DIElement! = (mElements.objectAtIndex(aIndex) as! DIElement)
            UIView.animateWithDuration(0.36, delay: aDelay, options: UIViewAnimationOptions.TransitionNone , animations:
                {
                    aElement.mUpdateAllowed = true
                    aElement.layer.transform = CATransform3DIdentity
                    aElement.alpha = 1.0}, completion: nil)
            
            aDelay += 0.04
        }
    }
    
    func replaceElementsAnimatedLeft(pNewCells:NSMutableArray)
    {
        self.destroyDetachedElements()
        detachAllElements()
        
        for var aIndex:Int=0; aIndex<pNewCells.count; aIndex++
        {
            let aElement:DIElement! = (pNewCells.objectAtIndex(aIndex) as! DIElement)
            self.addElement(aElement)
        }
        
        self.layoutForceElements()
        
        var aOffScreenCount:Int = 0
        for var aIndex:Int=0; aIndex<mElementsDetach.count; aIndex++
        {
            let aElement:DIElement! = (mElementsDetach.objectAtIndex(aIndex) as! DIElement)
            if(aElement.mY < 0){aOffScreenCount++}
            aElement.mUpdateAllowed = false
        }
        
        var aAnimationOut:CATransform3D = CATransform3DIdentity
        aAnimationOut.m34 = 1.0 / -500;
        aAnimationOut = CATransform3DTranslate(aAnimationOut, 220.0, 0.0, 0.0);
        aAnimationOut = CATransform3DRotate(aAnimationOut, -gMath.PI_2, 0.1, 1.0, 0.0);
        
        var aAnimationIn:CATransform3D = CATransform3DIdentity;
        aAnimationIn.m34 = 1.0 / -500;
        aAnimationIn = CATransform3DTranslate(aAnimationIn, -260.0, 0.0, 0.0);
        aAnimationIn = CATransform3DRotate(aAnimationIn, -gMath.PI_2, 0.1, 1.0, 0.0);
        
        for var aIndex:Int=0; aIndex<mElements.count; aIndex++
        {
            let aElement:DIElement! = (mElements.objectAtIndex(aIndex) as! DIElement)
            aElement.alpha = 0.0
            aElement.layer.transform = aAnimationIn
            aElement.layer.zPosition = 1280.0
            aElement.mUpdateAllowed = false
        }
        
        var aDelay:Double = 0.0
        for var aIndex:Int=0; aIndex<mElementsDetach.count; aIndex++
        {
            let aElement:DIElement! = (mElementsDetach.objectAtIndex(aIndex) as! DIElement)
            if(aElement != nil)
            {
                aElement.layer.zPosition = 640.0
                aElement.mUpdateAllowed = false
                UIView.animateWithDuration(0.36, delay: aDelay, options: UIViewAnimationOptions.TransitionNone , animations:
                    {
                        aElement.mUpdateAllowed = true
                        aElement.layer.transform = aAnimationOut
                        aElement.alpha = 0.0
                    }, completion: nil)
                if(aIndex >= aOffScreenCount)
                {
                    aDelay += 0.04
                }
            }
        }
        
        aDelay = 0.08
        for var aIndex:Int=0; aIndex<mElements.count; aIndex++
        {
            let aElement:DIElement! = (mElements.objectAtIndex(aIndex) as! DIElement)
            UIView.animateWithDuration(0.36, delay: aDelay, options: UIViewAnimationOptions.TransitionNone , animations:
                {
                    aElement.layer.transform = CATransform3DIdentity
                    aElement.alpha = 1.0
                    aElement.mUpdateAllowed = true
                }, completion: nil)
            aDelay += 0.04
        }
    }
    
    
    
    
    func layoutForceElements()
    {
        if(self.mElements == nil){return;}

        let aElementCount:Int = mElements.count;
        
        var aY:CGFloat = mPaddingTop
        var aX:CGFloat = mPaddingLeft
        var aWidth:CGFloat = 0.0
        var aHeight:CGFloat = 0.0
        
        if(mVertical)
        {
            if(aElementCount <= 0){aY = mPaddingTop + mPaddingBottom}
            else
            {
                aY = mPaddingTop;
                for var aIndex:Int=0; aIndex<mElements.count; aIndex++
                {
                    let aElement:DIElement! = (mElements.objectAtIndex(aIndex) as! DIElement)
                    if(aElement != nil)
                    {
                        if(aIndex > 0){aY += mSpacing;}
                        
                        aY += aElement.mPaddingTop
                        if(mFitStretch == true)
                        {
                            aX = mPaddingLeft
                            aWidth = (mW - (mPaddingLeft + mPaddingRight + aElement.mPaddingLeft + aElement.mPaddingRight));}
                        else
                        {
                            aWidth = aElement.mW;
                            aX = ((mScrollView.frame.size.width / 2.0) - (aWidth / 2.0))
                        }
                        
                        aElement.mkchk(CGRectMake(aX + aElement.mPaddingLeft, aY, aWidth, aElement.mH))
                        aY += (aElement.mH + aElement.mPaddingBottom);
                        
                    }
                }
                
                aY += mPaddingBottom;
                if(mScrollView != 0){mScrollView.contentSize = CGSizeMake(mW, aY);}
                else if(aY > mH){self.setHeight(aY)}
            }
        }
        else
        {
            if(aElementCount <= 0){aX = mPaddingLeft + mPaddingRight}
            else
            {
                aX = mPaddingLeft;
                for var aIndex:Int=0; aIndex<mElements.count; aIndex++
                {
                    let aElement:DIElement! = (mElements.objectAtIndex(aIndex) as! DIElement)
                    if(aElement != nil)
                    {
                        if(aIndex > 0){aX += mSpacing;}
                        if(mFitStretch == true){aHeight = (mH - (mPaddingTop + mPaddingBottom));}
                        else {aHeight = aElement.mH;}
                        aElement.mkchk(CGRectMake(aX, aY, aElement.mW, aHeight))
                        aX += aElement.mW;
                        //aElement.mLayoutAllowed = true
                    }
                }
                aX += mPaddingRight;
                if(mScrollView != 0){mScrollView.contentSize = CGSizeMake(aX, mH);}
                else if(aX > mW){self.setWidth(aX)}
            }
        }
    }

    override func destroy()
    {
        if(shouldDest() == true)
        {
            self.destroyAllElements()
            
            self.mElements = nil
            self.mElementsDetach = nil
            
            super.destroy()
        }
    }
}





