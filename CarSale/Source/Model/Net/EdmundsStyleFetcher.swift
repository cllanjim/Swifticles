//
//  EdmundsInfoFetcher.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/5/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

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
        //Is it the expected format?
        var dic = data as? [String:Any]
        guard dic != nil else {
            return false
        }
        
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
        
        //If successfully parsed 0 styles, that's a fail.
        return (styles.count > 0)
    }
}




