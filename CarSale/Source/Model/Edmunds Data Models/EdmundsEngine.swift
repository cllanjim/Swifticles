//
//  EdmundsEngine.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/11/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

class EdmundsEngine : NSObject
{
    var id: String = ""
    var index: Int = 0
    
    var name: String = ""
    var niceName: String = ""
    
    func load(data:[String:Any]?) -> Bool {
        
        guard let _data = data else {
            return false
        }
        
        let _id = _data["id"] as? String
        let _name = _data["name"] as? String
        
        guard _id != nil && _name != nil else {
            return false
        }
        
        name = _name!
        id = _id!
        
        let _niceName = _data["niceName"] as? String
        if _niceName != nil { niceName = _niceName! }
        
        return true
    }
}


/*
engine =     {
    code = "4ITCG1.4";
    compressionRatio = "9.5";
    compressorType = turbocharger;
    configuration = inline;
    cylinder = 4;
    displacement = 1364;
    equipmentType = ENGINE;
    fuelType = "regular unleaded";
    horsepower = 138;
    id = 401647994;
    manufacturerEngineCode = LUV;
    name = Luv;
    rpm =         {
        horsepower = 4900;
        torque = 1850;
    };
    size = "1.4";
    torque = 148;
    totalValves = 16;
    type = gas;
    valve =         {
        gear = "double overhead camshaft";
        timing = "variable valve timing";
    };
};
*/












