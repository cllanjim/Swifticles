//
//  ImageSet.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/29/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation

class ImageSet
{
    var id: Int = -1
    var index: Int = 0
    
    var imageURL: String = ""
    var thumbURL: String = ""
    
    func load(data:[String:Any]?) -> Bool {
        guard let _data = data else {
            return false
        }
        let _imageURL = _data["image_url"] as? String
        let _thumbURL = _data["thumb_url"] as? String
        guard _imageURL != nil && _thumbURL != nil else {
            return false
        }
        imageURL = String(_imageURL!)
        thumbURL = String(_thumbURL!)
        return true
    }
}
