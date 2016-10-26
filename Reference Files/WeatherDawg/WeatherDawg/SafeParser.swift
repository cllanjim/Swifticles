//
//  DDataParse.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import Foundation

class SafeParser : NSObject
{
    static let sharedInstance = SafeParser() // Singleton
    
    func dicGetDic(pName: String!, pDic: NSDictionary!) -> NSDictionary!
    {
        var result:NSDictionary! = nil
        if((pName != nil) && (pDic != nil))
        {
            if(pName.characters.count > 0)
            {
                let aObject:AnyObject! = pDic.objectForKey(pName)
                if(aObject != nil)
                {
                    if(aObject.isKindOfClass(NSDictionary)){result = aObject as! NSDictionary}
                }
            }
        }
        return result
    }
    
    func dicGetArr(pName: String!, pDic: NSDictionary!) -> NSArray!
    {
        var result:NSArray! = nil
        if((pName != nil) && (pDic != nil))
        {
            if(pName.characters.count > 0)
            {
                let aObject:AnyObject! = pDic.objectForKey(pName)
                if(aObject != nil)
                {
                    if(aObject.isKindOfClass(NSArray)){result = aObject as! NSArray}
                }
            }
        }
        return result
    }
    
    func dicGetStr(pName: String!, pDic: NSDictionary!) -> String!
    {
        var result:String! = nil
        if((pName != nil) && (pDic != nil))
        {
            if(pName.characters.count > 0)
            {
                let aObject:AnyObject! = pDic.objectForKey(pName)
                
                if(aObject != nil)
                {
                    if(aObject.isKindOfClass(NSString))
                    {
                        let aString:NSString! = aObject as! NSString
                        if(aString != nil){result = String(aString)}
                    }
                    else if(aObject.isKindOfClass(NSNumber))
                    {
                        let aNumber:NSNumber! = aObject as! NSNumber
                        if(aNumber != nil){result = String(aNumber)}
                    }
                    else
                    {
                        result = String(aObject);
                        
                    }
                }
            }
        }
        return result
    }

    func dicGetFloat(pName: String!, pDic: NSDictionary!) -> Float!
    {
        var result:Float = 0
        if((pName != nil) && (pDic != nil))
        {
            if(pName.characters.count > 0)
            {
                let aObject:AnyObject! = pDic.objectForKey(pName)
                if(aObject != nil)
                {
                    if(aObject.isKindOfClass(NSNumber))
                    {
                        let aNumber:NSNumber! = aObject as! NSNumber
                        if(aNumber != nil){result = Float(aNumber.floatValue)}
                    }
                    else if(aObject.isKindOfClass(NSString))
                    {
                        let aString:NSString! = aObject as! NSString
                        if(aString != nil){result = Float(aString.floatValue)}
                    }
                }
            }
        }
        return result
    }

}

let gParse:SafeParser = SafeParser.sharedInstance;

