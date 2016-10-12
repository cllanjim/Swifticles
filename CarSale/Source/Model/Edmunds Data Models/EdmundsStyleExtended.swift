//
//  EdmundsStyleExtended.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/11/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

class EdmundsStyleExtended : NSObject
{
    var categories: EdmundsCategories?
    var mpg: EdmundsMPG?
    
    var doorCount: String = ""
    
    func load(data:[String:Any]?) -> Bool {
        
        guard let _data = data else {
            return false
        }
        
        let _categories = EdmundsCategories()
        if _categories.load(data: _data["categories"] as! [String:Any]?) {
            categories = _categories
        }
        
        let _mpg = EdmundsMPG()
        if _mpg.load(data: _data["MPG"] as! [String:Any]?) {
            mpg = _mpg
        }
        
        
        let _doorCount = _data["numOfDoors"] as? String
        if _doorCount != nil { doorCount = _doorCount! }
        
        if categories != nil || mpg != nil {
            return true
        }
        
        return false
    }
}



