//
//  Parser.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/30/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

class SafeParser
{
    class func readInt(name: String?, data:[String:Any]?) -> Int? {
        guard name != nil && data != nil else {
            return nil
        }
        let _result = data![name!]
        if let result = _result {
            
            if let intResult = result as? Int {
                return intResult
            }
            if let numResult = result as? NSNumber {
                return numResult.intValue
            }
            if let stringResult = result as? String {
                if let intResult = Int(stringResult) {
                    return intResult
                }
            }
        }
        
        
        
        return nil
    }
    
    //[String:Any]
    
    
}
