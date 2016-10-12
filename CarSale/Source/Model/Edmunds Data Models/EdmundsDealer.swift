//
//  EdmundsDealer.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/12/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

class EdmundsDealer : NSObject
{
    
    var name: String = ""
    var id: Int = 0
    
    var lat: String = ""
    var lon: String = ""
    
    var website: String = ""
    
    
    var addrStreet: String = ""
    var addrCity: String = ""
    var addrState: String = ""
    var addrZip: String = ""
    
    var distance: String = ""

    
    
    func load(data:[String:Any]?) -> Bool {
        
        guard let _data = data else {
            return false
        }

        let _name = _data["name"] as? String
        
        
        guard _name != nil else {
            return false
        }
            
        name = _name!
        
        let _lat = _data["latitude"] as? String
        if _lat != nil { lat = _lat! }
        
        let _lon = _data["longitude"] as? String
        if _lon != nil { lon = _lon! }
        
        let _addrStreet = _data["street"] as? String
        if _addrStreet != nil { addrStreet = _addrStreet! }
        
        let _addrCity = _data["city"] as? String
        if _addrCity != nil { addrCity = _addrCity! }
        
        let _addrState = _data["stateCode"] as? String
        if _addrState != nil { addrState = _addrStreet! }
        
        let _addrZip = _data["zipcode"] as? String
        if _addrZip != nil { addrZip = _addrStreet! }
        
        return true
    }
}


