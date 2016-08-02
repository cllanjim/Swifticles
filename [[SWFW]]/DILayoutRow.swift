//
//  DIView.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DILayoutRow : DIElement
{
    var mItems:NSMutableArray! = nil;
    var mElements:NSMutableArray! = nil;
    
    var mSpacingLeft:CGFloat = 5.0;
    var mSpacingRight:CGFloat = 5.0;
    var mSpacingGaps:CGFloat = 2.0;
    var mSpacing:CGFloat = 2.0;
    
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
        
        if(mItems != nil)
        {
            
            //self.log()
            
            
            if(mItems.count > 0)
            {
                var aCount:Int = 0;
                var aCountAny:Int = 0;
                
                var aSpacingTotal:CGFloat = (mSpacingLeft + mSpacingRight);
                
                var aMinHeight:CGFloat = 0.0
                var aMaxHeight:CGFloat = 0.0
                var aCheckHeight:CGFloat = 0.0;
                
                for var aIndex:Int=0; aIndex<mItems.count; aIndex++
                    //for var aIndex:Int=(mElements.count - 1); aIndex>=0; aIndex--
                {
                    let aItem:DILayoutItem = (mItems.objectAtIndex(aIndex) as! DILayoutItem)
                    let aElement:DIElement = aItem.mElement;
                    
                    if(aItem.mLayoutType == DILayoutType.Any){aCountAny++;}
                    aCount++;
                    
                    aCheckHeight = (aElement.mH + aElement.mPaddingTop + aElement.mPaddingBottom);
                    
                    if(aIndex == 0)
                    {
                        aMinHeight = aCheckHeight;
                        aMaxHeight = aCheckHeight;
                    }
                    else
                    {
                        if(aElement.mH > aMaxHeight){aMaxHeight = aCheckHeight;}
                        if(aElement.mH < aMinHeight){aMinHeight = aCheckHeight;}
                    }
                    
                    
                    aSpacingTotal += (aElement.mPaddingLeft + aElement.mPaddingRight);
                }
                
                aSpacingTotal += CGFloat(mItems.count - 1) * mSpacingGaps;
                aSpacingTotal += CGFloat(mItems.count + 1) * mSpacing;
                
                let aTotalWidth = (self.mW - aSpacingTotal);
                
                var aWidth:CGFloat = 0.0;
                let aHeight:CGFloat = self.mH;
                var aX:CGFloat = mSpacingLeft + mSpacing;
                var aY:CGFloat = mPaddingTop;
                
                if(aCountAny == aCount)
                {
                    aWidth = (aTotalWidth / CGFloat(mItems.count))
                    
                    for var aIndex:Int=0; aIndex<mItems.count; aIndex++
                        //for var aIndex:Int=(mElements.count - 1); aIndex>=0; aIndex--
                    {
                        let aItem:DILayoutItem = (mItems.objectAtIndex(aIndex) as! DILayoutItem)
                        let aElement:DIElement = aItem.mElement;
                        
                        aX += aElement.mPaddingLeft;
                            
                        aElement.setRect(CGRectMake(aX, aY, aWidth, aHeight));
                        
                        aX += (aElement.mW + aElement.mPaddingRight + mSpacing + mSpacingGaps);
                    }
                }
                
                
                
                for var aIndex:Int=0; aIndex<mItems.count; aIndex++
                {
                    let aElement:DIElement = (mElements.objectAtIndex(aIndex) as! DIElement);
                    aElement.mkchk();
                }
                
            }
        }
    }
    
    func addEle(pEle:DIElement!)
    {
        if(mItems == nil){self.mItems = NSMutableArray();}
        if(mElements == nil){self.mElements = NSMutableArray();}
        
        if(pEle != nil)
        {
            let aItem:DILayoutItem = DILayoutItem(pElement: pEle);
            
            mItems.addObject(aItem);
            mElements.addObject(pEle);
            self.addSubview(pEle);
            
        }
    }
    
    override func initialize(){super.initialize()}
    
    
    override func baseUpdate()
    {
        if(mElements != nil)
        {
            var aElement:DIElement! = nil
            for var aIndex:Int=0; aIndex<mElements.count; aIndex++
            {
                aElement = (mElements.objectAtIndex(aIndex) as! DIElement)
                if(aElement.mUpdateAllowed == true){aElement.baseUpdate();}
            }
        }
        
        super.baseUpdate()
        self.update()
        
    }
    
    
    override func buttonClick(pButton:DIButtonView!)
    {
        
    }
    
    func destroyAllElements()
    {
        if(mItems != nil)
        {
        for var aIndex:Int=0; aIndex<mElements.count; aIndex++
        {
            (mItems.objectAtIndex(aIndex) as! DILayoutItem).destroy()
        }
            mItems.removeAllObjects();
            self.mItems = nil;
            
        }
        
        if(mElements != nil)
        {
            for var aIndex:Int=0; aIndex<mElements.count; aIndex++
            {
                (mElements.objectAtIndex(aIndex) as! DIElement).destroy()
            }
            mElements.removeAllObjects();
            self.mElements = nil;
        }
    }
    
    
    override func destroy()
    {
        if(shouldDest() == true)
        {
            self.destroyAllElements();
            
            super.destroy()
        }
    }
}



