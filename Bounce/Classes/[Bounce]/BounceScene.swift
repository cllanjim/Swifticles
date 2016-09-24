//
//  BounceScene.swift
//
//  Created by Nicholas Raptis on 8/25/16.
//

import UIKit

class BounceScene
{
    var image:UIImage?
    
    var title:String? = "Scene 01"
    
    var scenePath:String?
    var imagePath:String?
    
    var imageName:String = "AUTOSAVE"
    
    //var orientation:UIInterfaceOrientation = .Portrait
    var isLandscape:Bool = true
    
    var size:CGSize = CGSize(width: 320.0, height: 320.0)
    
    var clone:BounceScene {
        let scene = BounceScene()
        scene.title = title
        scene.scenePath = scenePath
        scene.imagePath = imagePath
        scene.isLandscape = isLandscape
        scene.size = CGSize(width: size.width, height: size.height)
        return scene
    }
    
    
    func save() -> [String:AnyObject] {
        var info = [String:AnyObject]()
        info["image_name"] = imageName as AnyObject?
        info["image_path"] = imagePath as AnyObject?
        info["landscape"] = isLandscape as AnyObject?
        info["size_width"] = Float(size.width) as AnyObject?
        info["size_height"] = Float(size.height) as AnyObject?
        return info
    }
    
    func load(info:[String:AnyObject]) {
        if let _imageName = info["image_name"] as? String { imageName = _imageName }
        if let _imagePath = info["image_path"] as? String { imagePath = _imagePath }
        if let _isLandscape = info["landscape"] as? Bool { isLandscape = _isLandscape }
        if let _sizeWidth = info["size_width"] as? Float { size.width = CGFloat(_sizeWidth) }
        if let _sizeHeight = info["size_height"] as? Float { size.height = CGFloat(_sizeHeight) }
    }
    
}
