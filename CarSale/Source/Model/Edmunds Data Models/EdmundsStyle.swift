//
//  EdmundsStyle.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/9/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class EdmundsStyle
{
    var id: Int = -1
    var index: Int = 0
    
    var name: String = ""
    var trim: String = ""
    
    var submodel: EdmundsSubmodel?
    
    func load(data:[String:Any]?) -> Bool {
        
        submodel = nil
        
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
        
        let _trim = _data["trim"] as? String
        if _trim != nil { trim = _trim! }
        
        let _submodel = EdmundsSubmodel()
        if _submodel.load(data: _data["submodel"] as! [String : Any]?) {
            submodel = _submodel
        }
        
        return true
    }
    
}
