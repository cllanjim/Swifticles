//
//  ImageSetFetcher.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/29/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation


//API KEY: yfwsqhj7ymscvt5sxh32f68a
//Shared secret: JQeZpBDHUdG8bzPbjQT6h6t2

//https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a
//http://api.edmunds.com/api/vehicle/v2/lexus/models?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a&callback=myFunction
//https://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a&state=new&view=full

//http://www.froggystudios.com/bounce/fetch_scene_list.php

class ImageSetFetcher : WebFetcher
{
    var sets = [ImageSet]()
    
    override func clear() {
        super.clear()
        sets.removeAll()
    }
    
    func fetchImageSets() {
        fetch("http://www.froggystudios.com/bounce/fetch_scene_list.php")
    }
    
    override func parse(data: Any) -> Bool {
        
        print(data)
        
        var dic = data as? [String:Any]
        
        guard dic != nil else {
            return false
        }
        
        
        sets.removeAll()

        
        
        return (sets.count > 0)
    }
    
    //private func fetch
    
    
    
    
}












