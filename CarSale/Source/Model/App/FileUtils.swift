//
//  FileUtils.swift
//
//  Created by Nicholas Raptis on 9/23/15.
//

import UIKit

open class FileUtils
{
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
        if image != nil {
            var imageData = UIImagePNGRepresentation(image!)
            if FileUtils.saveData(data: &imageData, filePath: filePath) {
                return true
            } else {
                print("Unable to save image (\(image!.size.width)x\(image!.size.height)) [\(filePath)]")
            }
        }
        return false
    }
    
    class func parseJSON(data: Data?) -> Any? {
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
}


