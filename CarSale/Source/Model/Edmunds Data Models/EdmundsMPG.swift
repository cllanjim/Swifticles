//
//  EdmundsMPG.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/11/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

/*
 MPG =     {
 city = 24;
 highway = 30;
 };
 */

class EdmundsMPG : NSObject
{
    
    
    var city: String = ""
    var highway: String = ""
    
    func load(data:[String:Any]?) -> Bool {
        
        guard let _data = data else {
            return false
        }
        
        let _city = _data["city"] as? String
        let _highway = _data["highway"] as? String
        
        guard _city != nil && _highway != nil else {
            return false
        }
        
        city = _city!
        highway = _highway!
        
        return true
    }
}
