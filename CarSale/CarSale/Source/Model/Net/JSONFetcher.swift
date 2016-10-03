//
//  JSONFetcher.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/30/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation


//Fetches JSON data asynchronously with parsing support.
class JSONFetcher : WebFetcher
{
    func parse(data: Any) -> Bool {
        print("PARSE SHOULD BE OVERRIDEN")
        return true
    }
    
    override func fetchDidComplete(_ data: Data) {
        
        let _jsonData = FileUtils.parseJSON(data: data)
        guard _jsonData != nil else {
            //It's not even JSON!
            fail(result: .error)
            return
        }
        
        //It's JSON, let's try to parse it.
        if parse(data: _jsonData!) {
            //Woohoo!
            succeed()
        } else {
            //Parsing failed, was this the expected data?
            fail(result: .error)
        }
    }
}


