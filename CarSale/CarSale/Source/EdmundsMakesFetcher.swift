//
//  EdmundsMakesFetcher.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/28/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

//API KEY: yfwsqhj7ymscvt5sxh32f68a
//Shared secret: JQeZpBDHUdG8bzPbjQT6h6t2

//https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a
//http://api.edmunds.com/api/vehicle/v2/lexus/models?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a&callback=myFunction
//https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a&state=new&view=full

//http://www.froggystudios.com/bounce/fetch_scene_list.php

class EdmundsMakesFetcher : JSONFetcher
{
    var makes = [EdmundsMake]()
    
    override func clear() {
        super.clear()
        makes.removeAll()
    }
    
    func fetchAllMakes() {
        fetch("https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a")
    }
    
    override func parse(data: Any) -> Bool {
        
        //Is it the expected format?
        var dic = data as? [String:Any]
        guard dic != nil else {
            return false
        }
        
        //Populate the makes!
        makes.removeAll()
        if let _makes = dic!["makes"] as? [[String:Any]] {
            var index:Int = 0
            for _make in _makes {
                let make = EdmundsMake()
                if make.load(data: _make) {
                    //If it's a good one, keep it.
                    make.index = index
                    makes.append(make)
                    index += 1
                }
            }
        }
        
        //If successfully parsed 0 makes, that's a fail.
        return (makes.count > 0)
    }
}











