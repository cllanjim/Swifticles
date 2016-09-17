//
//  DSStringUtils.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DSStringUtils : NSObject
{
    override init(){super.init();}
    
    func strcat(pString1:String!, pString2:String!) -> String
    {
        return ""
    }
    
    func stringToNSString(pString:String!) -> NSString!
    {
        if(pString != nil){return NSString(string: pString)}
        return NSString(string: "")
    }
    
    func stringArrayClone(pArray:NSMutableArray!) -> NSMutableArray
    {
        let aReturn:NSMutableArray = NSMutableArray()
        
        self.stringArrayCloneTo(source: pArray, dest: aReturn)
        
        return aReturn
    }
    
    func stringArrayCloneTo(source pArraySource:NSMutableArray!, dest pArrayDest:NSMutableArray!)
    {
        if((pArraySource != nil) && (pArrayDest != nil))
        {
            for var aIndex:NSInteger=0; aIndex<pArraySource.count; aIndex++
            {
                pArrayDest.addObject(self.anyToString(pArraySource.objectAtIndex(aIndex)))
            }
        }
    }
    
    func stringArraySortAsNumbers(arr pArray:NSMutableArray!, asc pAscending:Bool) -> NSMutableArray!
    {
        var aReturn:NSMutableArray! = nil
        
        /*
        BoardGenericMatch *aMatchSortKey = 0;
        BoardGenericMatch *aMatchHold = 0;
        
        int aCheck = 0;
        
        for(int aStart = 1;aStart<mMatchCount;aStart++)
        {
        aMatchSortKey = mMatch[aStart];
        aCheck=aStart-1;
        while(aCheck >= 0 && (mMatch[aCheck]->mCount) < aMatchSortKey->mCount)
        {
        mMatch[aCheck+1] = mMatch[aCheck];
        aCheck--;
        }
        mMatch[aCheck+1]=aMatchSortKey;
        }
        */
        
        if(pArray != nil)
        {
            aReturn = NSMutableArray(capacity: pArray.count)
            
            if(pArray.count >= 1)
            {
                var aSortArr:[(str: String!, val: CGFloat)] = []
                
                for var aIndex:NSInteger=0; aIndex<pArray.count; aIndex++
                {
                    let aString:String! = self.anyToString(pArray.objectAtIndex(aIndex));
                    let aFloat:CGFloat = self.stringToFloat(aString)
                    aSortArr.append(str:aString, val:aFloat)
                }
                
                if(pAscending)
                {
                aSortArr.sortInPlace({ $0.val < $1.val})
                }
                else
                {
                    aSortArr.sortInPlace({ $0.val > $1.val})
                }
                for var aIndex:NSInteger=0; aIndex<aSortArr.count; aIndex++
                {
                    aReturn.addObject(String(aSortArr[aIndex].str))
                }
            }
        }
        
        return aReturn
    }
    
    func anyToString(pAnyObject:AnyObject!) -> String
    {
        if(pAnyObject != nil)
        {
            if(pAnyObject.isKindOfClass(NSNumber))
            {
                let aNumber:NSNumber! = pAnyObject as! NSNumber
                return String(aNumber)
                
            }
            if(pAnyObject.isKindOfClass(NSString))
            {
                let aString:NSString! = pAnyObject as! NSString
                
                if(aString != nil)
                {
                    if(aString.length > 0)
                    {
                        return String(aString)
                    }
                }
            }
        }
        return String("")
    }
    
    func stringsEqualI(str1 pString1:String!, str2 pString2:String!) -> Bool
    {
        var aReturn:Bool = false;
        if((pString1 != nil) && (pString2 != nil))
        {
            if(pString1.characters.count == pString2.characters.count)
            {
                if(pString1.compare(pString2, options: NSStringCompareOptions.CaseInsensitiveSearch, range: pString1.rangeOfString(pString1), locale: nil) == NSComparisonResult.OrderedSame)
                {
                    aReturn = true
                }
            }
        }
        
        return aReturn;
    }
    
    func stringArrayFind(text pText:String!, arr pArray:NSMutableArray!) -> Int
    {
        var aReturn:Int = -1
        
        if((pText != nil) && (pArray != nil))
        {
            for var aIndex:NSInteger=0; aIndex<pArray.count; aIndex++
            {
                let aCheck:String = self.anyToString(pArray[aIndex])
                
                if(pText.compare(aCheck, options: NSStringCompareOptions.CaseInsensitiveSearch, range: pText.rangeOfString(pText), locale: nil) == NSComparisonResult.OrderedSame)
                {
                    aReturn = aIndex
                }
            }
        }
        
        return aReturn
    }
    
    func stringToFloat(pString:String!) -> CGFloat
    {
        var aReturn:CGFloat = 0.0
        
        if(pString != nil)
        {
            let aString:NSString! = self.stringToNSString(pString)
            if(aString != nil)
            {
                if(aString.length > 0)
                {
                    aReturn = CGFloat(aString.floatValue)
                }
            }
        }
        return aReturn
    }
    
    class var shared: DSStringUtils
    {
        struct Static{static var cTokenOnce: dispatch_once_t = 0;static var cInstance: DSStringUtils? = nil;}
        dispatch_once(&Static.cTokenOnce){Static.cInstance = DSStringUtils()}
        return Static.cInstance!
    }
}

let gString:DSStringUtils = DSStringUtils.shared;


