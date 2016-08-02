//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import UIKit
//import Foundation

public class FileUtils// : DSObject
{
    required public init() {
        
    }
    
    public class func getBundle() -> String
    {
        var result:String! = nil
        result = NSBundle.mainBundle().resourcePath
        result = result.stringByAppendingString("/")
        return result
    }
    
    public class func getDocs() -> String
    {
        var result:String! = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        result = result.stringByAppendingString("/")
        return result
    }
    
    /*
    func dataConvertJSON(pData: NSData!) -> AnyObject!
    {
        var result:AnyObject! = nil
        if(pData != nil)
        {
            do{result = try NSJSONSerialization.JSONObjectWithData(pData!, options:.MutableLeaves)}
            catch{result = nil;}
        }
        return result
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
        var result:String! = nil
        
        let aData:NSData! = dataFileLoad(pPath)
        
        if(aData != nil)
        {
            result = String(data: aData, encoding: NSUTF8StringEncoding)
        }
        
        return result
    }
    
    
    func dataFileSave(pData : NSData!, pPath : String!)
    {
        if((pData != nil) && (pPath != nil))
        {
            pData.writeToFile(pPath, atomically: true)
        }
    }
    
    class func dataFileLoad(path path: String!) -> NSData!
    {
        var aData:NSData! = nil
        if path != nil
        {
            if path.characters.count > 0 {
                let aPath:String = String(path)
                if(self.fileExists(path: aPath)){aData = NSData(contentsOfFile: aPath)}
            }
            if aData == nil {
                let aPath:String = appendPath(path:getBundle(), string:path)
                if(self.fileExists(path: aPath)){aData = NSData(contentsOfFile: aPath)}
            }
            if(aData == nil)
            {
                let aPath:String = appendPath(path:getDocs(), string:path)
                if(self.fileExists(path: aPath)){aData = NSData(contentsOfFile: aPath)}
            }
        }
        return aData
    }
    
    func appendPath(path path: String!, string:String!) -> String!
    {
        var result:String! = String("")
        
        if(path != nil)
        {
            if(path.characters.count > 0)
            {
                result = result.stringByAppendingString(path)
            }
        }
        
        if(string != nil)
        {
            if(string.characters.count > 0)
            {
                
                if(result.characters.count > 0)
                {
                    
                }
                
                result = result.stringByAppendingString(string)
            }
        }
        
        return result
    }
    
    class func fileExists(path path: String!) -> Bool
    {
        var result:Bool = false
        let aFileManager:NSFileManager = NSFileManager.defaultManager()
        if(path != nil)
        {
            if(path.characters.count > 0)
            {
                if(aFileManager.fileExistsAtPath(path))
                {
                    result = true
                }
            }
        }
        return result
    }
 
    */
    
}


