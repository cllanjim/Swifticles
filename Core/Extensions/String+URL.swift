//
//  String+URL.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/6/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

extension String {
    var urlEncode:String {
        let allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        if let result = addingPercentEncoding( withAllowedCharacters: allowedCharSet) {
            return result
        }
        return self
    }
}




