//
//  EdmundsCategories.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/11/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

class EdmundsCategories : NSObject
{
    
    var epaClass: String = ""
    var crossover: String = ""
    var niceName: String = ""
    var market: String = ""
    var primaryBodyType: String = ""
    var vehicleSize: String = ""
    var vehicleStyle: String = ""
    var vehicleType: String = ""
    
    func load(data:[String:Any]?) -> Bool {
        
        guard let _data = data else {
            return false
        }
        
        let _vehicleSize = _data["vehicleSize"] as? String
        let _vehicleStyle = _data["vehicleStyle"] as? String
        let _vehicleType = _data["vehicleType"] as? String
        
        guard _vehicleSize != nil && _vehicleStyle != nil && _vehicleType != nil else {
            return false
        }
        
        vehicleSize = _vehicleSize!
        vehicleStyle = _vehicleStyle!
        vehicleType = _vehicleType!
        
        let _epaClass = _data["EPAClass"] as? String
        if _epaClass != nil { epaClass = _epaClass! }
        
        let _crossover = _data["crossover"] as? String
        if _crossover != nil { crossover = _crossover! }
        
        let _market = _data["market"] as? String
        if _market != nil { market = _market! }
        
        let _primaryBodyType = _data["primaryBodyType"] as? String
        if _primaryBodyType != nil { primaryBodyType = _primaryBodyType! }
        
        return true
    }
}

