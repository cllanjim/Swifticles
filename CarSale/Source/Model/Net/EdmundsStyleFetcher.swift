//
//  EdmundsInfoFetcher.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/5/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

//API KEY: yfwsqhj7ymscvt5sxh32f68a
//Shared secret: JQeZpBDHUdG8bzPbjQT6h6t2

//https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a
//http://api.edmunds.com/api/vehicle/v2/lexus/models?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a&callback=myFunction
//https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a&state=new&view=full
//http://api.edmunds.com/api/vehicle/v2/chevrolet/camaro/2017?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a
//http://www.froggystudios.com/bounce/fetch_scene_list.php

class EdmundsStyleFetcher : JSONFetcher
{
    var styles = [EdmundsStyle]()
    
    override func clear() {
        super.clear()
        styles.removeAll()
    }
    
    func fetch(make: EdmundsMake, model: EdmundsModel, year: EdmundsYear) {
        let url = "http://api.edmunds.com/api/vehicle/v2/\(make.name.urlEncode)/\(model.name.urlEncode)/\(year.year)?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a"
        fetch(url)
    }
    
    override func parse(data: Any) -> Bool {
        
        print(data)
        
        
        //Is it the expected format?
        var dic = data as? [String:Any]
        guard dic != nil else {
            return false
        }
        
        //EdmundsStyleFetcher
        //Populate the makes!
        styles.removeAll()
        if let _styles = dic!["styles"] as? [[String:Any]] {
            for _style in _styles {
                let style = EdmundsStyle()
                if style.load(data: _style) {
                    //If it's a good one, keep it.
                    //make.index = index
                    styles.append(style)
                }
            }
        }
        
        //If successfully parsed 0 makes, that's a fail.
        return (styles.count > 0)
    }
}




