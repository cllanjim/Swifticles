//
//  EdmundsMakeModel.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/28/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class EdmundsMake
{
    var id: Int = -1
    var index: Int = 0
    
    var name: String = ""
    var niceName: String = ""
    
    var models = [EdmundsModel]()
    
    var set: ImageSet?
    
    func load(data:[String:Any]?) -> Bool {
        
        models.removeAll()
        
        guard let _data = data else {
            return false
        }
        
        let _id = _data["id"] as? Int
        let _name = _data["name"] as? String
        
        guard _id != nil && _name != nil else {
            return false
        }
        
        name = _name!
        id = _id!
        
        let _niceName = _data["niceName"] as? String
        if _niceName != nil { niceName = _niceName! }
        
        let _models = _data["models"] as? [[String:Any]]
        if _models != nil {
            for _model in _models! {
                let model = EdmundsModel()
                if model.load(make: self, data: _model) {
                    models.append(model)
                }
            }
        }
        return true
    }
    
}

