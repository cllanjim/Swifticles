//
//  EdmundsModel.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/28/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation

class EdmundsModel {
    
    var id: String = ""
    
    var name: String = ""
    var niceName: String = ""
    
    weak var make: EdmundsMake!
    
    var years = [EdmundsYear]()
    
    func load(make: EdmundsMake, data:[String:Any]?) -> Bool {
        
        years.removeAll()
        
        guard let _data = data else {
            return false
        }
        
        let _id = _data["id"] as? String
        let _name = _data["name"] as? String
        
        guard _id != nil && _name != nil else {
            return false
        }
        
        self.make = make
        
        name = _name!
        id = _id!
        
        let _niceName = _data["niceName"] as? String
        if _niceName != nil { niceName = _niceName! }
        
        let _years = _data["years"] as? [[String:Any]]
        if _years != nil {
            for _year in _years! {
                let year = EdmundsYear()
                if year.load(model: self, data: _year) {
                    years.append(year)
                }
            }
        }
        
        return true
    }
}
