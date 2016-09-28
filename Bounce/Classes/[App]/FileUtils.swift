//
//  FileUtils.swift
//
//  Created by Nicholas Raptis on 9/23/15.
//

import UIKit

open class FileUtils
{
    required public init() {
        //Do something AMAZING!
    }
    
    open class var bundleDir: String {
        var result:String! = nil
        result = Bundle.main.resourcePath
        result = result + "/"
        return result
    }
    
    open class var docsDir: String {
        var result:String! = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        result = result + "/"
        return result
    }
    
    open class func getDocsPath(filePath:String?) -> String {
        var result = FileUtils.docsDir
        if let path = filePath { result = result + path }
        return result
    }
    
    open class func getBundlePath(filePath:String?) -> String {
        var result = FileUtils.bundleDir
        if let path = filePath { result = result + path }
        return result
    }
    
    open class func findAbsolutePath(filePath:String?) -> String? {
        if let path = filePath , path.characters.count > 0 {
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
    
    class func fileExists(filePath:String?) -> Bool {
        if let path = filePath , path.characters.count > 0 {
            return FileManager.default.fileExists(atPath: path)
        }
        return false
    }
    
    open class func saveData(data:inout Data?, filePath:String?) -> Bool {
            if let path = filePath, data != nil {
                do {
                    try data!.write(to: URL(fileURLWithPath: path), options: .atomicWrite)
                    return true
                } catch {
                    print("Unable to save Data [\(filePath)]")
                }
            }
        return false
    }
    
    open class func loadData(_ filePath:String?) -> Data? {
        if let path = FileUtils.findAbsolutePath(filePath: filePath) {
            return (try? Data(contentsOf: URL(fileURLWithPath: path)))
        }
        return nil
    }
    
    open class func saveImagePNG(image:UIImage?, filePath:String?) -> Bool {
        if let checkImage = image , checkImage.size.width >= 1.0 && checkImage.size.height >= 1.0 {
            var imageData = UIImagePNGRepresentation(checkImage)
            
            if FileUtils.saveData(data: &imageData, filePath: filePath) {
                return true
            } else {
                print("Unable to save image (\(checkImage.size.width)x\(checkImage.size.height)) [\(filePath)]")
            }
        }
        return false
    }
    
    class func parseJSON(data: Data?) -> Any?
    {
        var result:Any?
        if(data != nil) {
            do {
                result = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
            } catch {
                print("JSON Serialization Failed")
            }
        }
        return result
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


