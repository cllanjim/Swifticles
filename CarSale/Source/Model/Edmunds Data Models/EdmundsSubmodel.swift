//
//  EdmundsSubmodel.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/9/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

import UIKit

class EdmundsSubmodel
{
    var id: Int = -1
    var body: String = ""
    var name: String = ""
    var niceName: String = ""
    
    func load(data:[String:Any]?) -> Bool {
        guard let _data = data else {
            return false
        }
        
        let _body = _data["body"] as? String
        if _body != nil { body = _body! }
        
        let _name = _data["modelName"] as? String
        if _name != nil { name = _name! }
        
        let _niceName = _data["niceName"] as? String
        if _niceName != nil { niceName = _niceName! }
        
        return true
    }
    
}
