//
//  EdmundsDealerFetcher.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/12/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

class EdmundsDealerFetcher : JSONFetcher
{
    var styleDetail: EdmundsStyleExtended?
    
    override func clear() {
        super.clear()
        styleDetail = nil
    }
    
    func fetch(withZip zip: Int, make: EdmundsStyle) {
        let url = "https://api.edmunds.com/api/dealer/v2/franchises?zipcode=\(zip)&make=\(make.name.urlEncode)&api_key=yfwsqhj7ymscvt5sxh32f68a"
        
        //"https://api.edmunds.com/api/vehicle/v2/styles/\(style.id)?view=full&fmt=json&api_key=yfwsqhj7ymscvt5sxh32f68a"
        fetch(url)
    }
    
    override func parse(data: Any) -> Bool {
        print(data)
        
        //Is it the expected format?
        let dic = data as? [String:Any]
        guard dic != nil else {
            return false
        }
        
        let _styleDetail = EdmundsStyleExtended()
        if _styleDetail.load(data: dic) {
            styleDetail = _styleDetail
            return true
        }
        
        return false
    }
}

