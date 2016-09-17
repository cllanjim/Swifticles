//
//  ScriptRelief.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

//import UIKit
import Foundation

class DData : DSObject
{
    required init()
    {
        super.init()
    }

    func getBundle() -> String
    {
        var aReturn:String! = nil
        aReturn = NSBundle.mainBundle().resourcePath
        aReturn = aReturn.stringByAppendingString("/")
        return aReturn
    }
    
    func getDocs() -> String!
    {
        var aReturn:String! = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        aReturn = aReturn.stringByAppendingString("/")
        return aReturn
    }
    
    func getBundlePath(pPath:String) -> String!
    {
        var aReturn:String! = nil
        aReturn = gNet.appendURL(getBundle(), pAppend: pPath)
        return aReturn
    }
    
    func getDocsPath(pPath:String) -> String!
    {
        var aReturn:String! = nil
        aReturn = gNet.appendURL(getDocs(), pAppend: pPath)
        return aReturn
    }
    
    
    func dataConvertJSON(pData: NSData!) -> AnyObject!
    {
        var aReturn:AnyObject! = nil
        if(pData != nil)
        {
            do{aReturn = try NSJSONSerialization.JSONObjectWithData(pData!, options:.MutableLeaves)}
            catch{aReturn = nil;}
        }
        return aReturn
    }
    
    func stringFileSave(pString : String!, pPath : String!)
    {
        //pData .writeToFile(pPath, atomically: true)
        if(pString != nil)
        {
            let aData:NSData! = pString.dataUsingEncoding(NSUTF8StringEncoding)
        
            if(aData != nil)
            {
                self.dataFileSave(aData, pPath: pPath)
            }
        }
        
        
    }
    
    func stringFileLoad(pPath : String!) -> String
    {
        var aReturn:String! = nil
        
        let aData:NSData! = dataFileLoad(pPath)
        
        if(aData != nil)
        {
            aReturn = String(data: aData, encoding: NSUTF8StringEncoding)
        }
        
        return aReturn
    }
    
    
    func dataFileSave(pData : NSData!, pPath : String!)
    {
        if((pData != nil) && (pPath != nil))
        {
            pData.writeToFile(pPath, atomically: true)
        }
    }
    
    func dataFileLoad(pPath : String!) -> NSData!
    {
        var aData:NSData! = nil
        if(pPath != nil)
        {
            if(pPath.characters.count > 0)
            {
                let aPath:String = String(pPath)
                if(self.fileExists(aPath)){aData = NSData(contentsOfFile: aPath)}
            }
            if(aData == nil)
            {
                let aPath:String = gNet.appendURL(getBundle(), pAppend: pPath)
                if(self.fileExists(aPath)){aData = NSData(contentsOfFile: aPath)}
            }
            if(aData == nil)
            {
                let aPath:String = gNet.appendURL(getDocs(), pAppend: pPath)
                if(self.fileExists(aPath)){aData = NSData(contentsOfFile: aPath)}
            }
        }
        return aData
    }
    
    func fileExists(pPath: String!) -> Bool
    {
        var aReturn:Bool = false
        let aFileManager:NSFileManager = NSFileManager.defaultManager()
        if(pPath != nil)
        {
            if(pPath.characters.count > 0)
            {
                if(aFileManager.fileExistsAtPath(pPath))
                {
                    aReturn = true
                }
            }
        }
        return aReturn
    }
    
    class var shared: DData
    {
        struct Static{static var cTokenOnce: dispatch_once_t = 0;static var cInstance: DData? = nil;}
        dispatch_once(&Static.cTokenOnce){Static.cInstance = DData()}
        return Static.cInstance!
    }
    
    override func destroy()
    {
        super.destroy()
    }
}

let gData:DData = DData.shared;
