//
//  ImageSetFetcher.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/29/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

class ImageSetFetcher : WebFetcher
{
    var sets = [ImageSet]()
    
    override func clear() {
        super.clear()
        sets.removeAll()
    }
    
    func fetchImageSets() {
        fetch("http://www.froggystudios.com/bounce/fetch_scene_list.php")
    }
    
    override func parse(data: Any) -> Bool {
        sets.removeAll()
        let _array = data as? [[String:Any]]
        guard _array != nil else {
            return false
        }
        
        var index:Int = 0
        for _set in _array! {
            let set = ImageSet()
            if set.load(data: _set) {
                set.index = index
                sets.append(set)
                index += 1
            }
        }
        return (sets.count > 0)
    }
}












