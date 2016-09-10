//
//  Reader.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import Foundation

class Reader
{
    
    /*
    required init()
    {
        super.init()
    }
    
    func dicGetDic(pName: String!, pDic: NSDictionary!) -> NSDictionary!
    {
        var aReturn:NSDictionary! = nil
        if((pName != nil) && (pDic != nil))
        {
            if(pName.characters.count > 0)
            {
                let aObject:AnyObject! = pDic.objectForKey(pName)
                if(aObject != nil)
                {
                    if(aObject.isKindOfClass(NSDictionary)){aReturn = aObject as! NSDictionary}
                }
            }
        }
        return aReturn
    }
    
    func dicGetArr(pName: String!, pDic: NSDictionary!) -> NSArray!
    {
        var aReturn:NSArray! = nil
        if((pName != nil) && (pDic != nil))
        {
            if(pName.characters.count > 0)
            {
                let aObject:AnyObject! = pDic.objectForKey(pName)
                if(aObject != nil)
                {
                    if(aObject.isKindOfClass(NSArray)){aReturn = aObject as! NSArray}
                }
            }
        }
        return aReturn
    }
    
    func dicGetStr(pName: String!, pDic: NSDictionary!) -> String!
    {
        var aReturn:String! = nil
        if((pName != nil) && (pDic != nil))
        {
            if(pName.characters.count > 0)
            {
                let aObject:AnyObject! = pDic.objectForKey(pName)
                
                //print("Obj \(aObject)");
                if(aObject != nil)
                {
                    if(aObject.isKindOfClass(NSString))
                    {
                        let aString:NSString! = aObject as! NSString
                        if(aString != nil){aReturn = String(aString)}
                    }
                    else if(aObject.isKindOfClass(NSNumber))
                    {
                        let aNumber:NSNumber! = aObject as! NSNumber
                        if(aNumber != nil){aReturn = String(aNumber)}
                    }
                    else
                    {
                        aReturn = String(aObject);
                        
                    }
                }
            }
        }
        return aReturn
    }
    
    func dicGetBool(pName: String!, pDic: NSDictionary!) -> Bool
    {
        var aReturn:Bool = false
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
                        if(aNumber != nil){aReturn = aNumber.boolValue}
                    }
                    else if(aObject.isKindOfClass(NSString))
                    {
                        let aString:NSString! = aObject as! NSString
                        if(aString != nil){aReturn = aString.boolValue;}
                    }
                }
            }
        }
        return aReturn
    }
    
    func dicGetInt(pName: String!, pDic: NSDictionary!) -> Int!
    {
        var aReturn:Int = 0
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
                        if(aNumber != nil){aReturn = Int(aNumber.intValue)}
                    }
                    else if(aObject.isKindOfClass(NSString))
                    {
                        let aString:NSString! = aObject as! NSString
                        if(aString != nil){aReturn = Int(aString.integerValue)}
                    }
                }
            }
        }
        return aReturn
    }
    
    func dicGetLong(pName: String!, pDic: NSDictionary!) -> Int64!
    {
        var aReturn:Int64 = 0
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
                        if(aNumber != nil){aReturn = aNumber.longLongValue}
                    }
                    else if(aObject.isKindOfClass(NSString))
                    {
                        let aString:NSString! = aObject as! NSString
                        if(aString != nil){aReturn = Int64(aString.longLongValue)}
                    }
                }
            }
        }
        return aReturn
    }
    
    
    class var shared: DDataParse
    {
        struct Static{static var cTokenOnce: dispatch_once_t = 0;static var cInstance: DDataParse? = nil;}
        dispatch_once(&Static.cTokenOnce){Static.cInstance = DDataParse()}
        return Static.cInstance!
    }
    
    override func destroy()
    {
        super.destroy()
    }
 
    */
}
