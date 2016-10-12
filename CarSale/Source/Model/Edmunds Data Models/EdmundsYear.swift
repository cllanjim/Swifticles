//
//  EdmundsYear.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/28/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class EdmundsYear : NSObject
{
    var id: Int = -1
    var index: Int = 0
    
    var year: Int = -1
    
    weak var model: EdmundsModel!
    
    func load(model: EdmundsModel, data:[String:Any]?) -> Bool {
        
        guard let _data = data else {
            return false
        }
        
        let _id = _data["id"] as? Int
        let _year = _data["year"] as? Int
        
        guard _id != nil && _year != nil else {
            return false
        }
        
        self.model = model
        
        id = _id!
        year = _year!
        
        return true
    }
}

