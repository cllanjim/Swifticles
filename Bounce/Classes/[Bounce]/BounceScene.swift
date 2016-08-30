//
//  BounceScene.swift
//  Bounce
//
//  Created by Nicholas Raptis on 8/25/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
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
    
    
    func save() -> [String:AnyObject] {
        var info = [String:AnyObject]()
        info["image_name"] = imageName
        info["image_path"] = imagePath
        info["landscape"] = isLandscape
        info["size_width"] = Float(size.width)
        info["size_height"] = Float(size.height)
        return info
    }
    
    func load(info info:[String:AnyObject]) {
        if let _imageName = info["image_name"] as? String { imageName = _imageName }
        if let _imagePath = info["image_path"] as? String { imagePath = _imagePath }
        if let _isLandscape = info["landscape"] as? Bool { isLandscape = _isLandscape }
        if let _sizeWidth = info["size_width"] as? Float { size.width = CGFloat(_sizeWidth) }
        if let _sizeHeight = info["size_height"] as? Float { size.height = CGFloat(_sizeHeight) }
    }
    
}
