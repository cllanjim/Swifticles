//
//  FileUtils.swift
//
//  Created by Nicholas Raptis on 9/23/15.
//

import UIKit

public class FileUtils
{
    required public init() {
        //Do something AMAZING!
    }
    
    public class var bundleDir: String {
        var result:String! = nil
        result = NSBundle.mainBundle().resourcePath
        result = result.stringByAppendingString("/")
        return result
    }
    
    public class var docsDir: String {
        var result:String! = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        result = result.stringByAppendingString("/")
        return result
    }
    
    public class func getDocsPath(filePath filePath:String?) -> String {
        var result = FileUtils.docsDir
        if let path = filePath { result = result.stringByAppendingString(path) }
        return result
    }
    
    public class func getBundlePath(filePath filePath:String?) -> String {
        var result = FileUtils.bundleDir
        if let path = filePath { result = result.stringByAppendingString(path) }
        return result
    }
    
    public class func findAbsolutePath(filePath filePath:String?) -> String? {
        if let path = filePath where path.characters.count > 0 {
            if fileExists(filePath: path) {
                return path
            }
            let bundlePath = FileUtils.getBundlePath(filePath: path)
            if fileExists(filePath: bundlePath) {
                return bundlePath
            }
            let docsPath = FileUtils.getDocsPath(filePath: path)
            if fileExists(filePath: docsPath) {
                return docsPath
            }
        }
        return nil
    }
    
    class func fileExists(filePath filePath:String?) -> Bool {
        if let path = filePath where path.characters.count > 0 {
            return NSFileManager.defaultManager().fileExistsAtPath(path)
        }
        return false
    }
    
    public class func saveData(inout data data:NSData?, filePath:String?) -> Bool {
        if let checkData = data {
            if let path = filePath {
                do {
                    try checkData.writeToFile(path, options: .AtomicWrite)
                    return true
                } catch {
                    print("Unable to save Data [\(filePath)]")
                }
            }
        }
        return false
    }
    
    public class func loadData(filePath:String?) -> NSData? {
        if let path = FileUtils.findAbsolutePath(filePath: filePath) {
            return NSData(contentsOfFile: path)
        }
        return nil
    }
    
    public class func saveImagePNG(image image:UIImage?, filePath:String?) ->Bool {
        if let checkImage = image where checkImage.size.width >= 1.0 && checkImage.size.height >= 1.0 {
            var imageData = UIImagePNGRepresentation(checkImage)
            
            if FileUtils.saveData(data: &imageData, filePath: filePath) {
                return true
            } else {
                print("Unable to save image (\(checkImage.size.width)x\(checkImage.size.height)) [\(filePath)]")
            }
        }
        return false
    }
    
    
    
    //do{aReturn = try NSJSONSerialization.JSONObjectWithData(pData!, options:.MutableLeaves)}
    //catch{aReturn = nil;}
    //imageData?.writeToFile(scene.imagePath!, options: .AtomicWrite)
    
    //public class
    
    
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


