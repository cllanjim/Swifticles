//
//  Config.swift
//
//  Created by Raptis, Nicholas on 8/26/16.
//

import Foundation

class Config
{
    static let shared = Config()
    private init() { }

    
    private var _uniqueIndex1:Int = 4096
    private var _uniqueIndex2:Int = 2048
    
    var uniqueString:String {
        
        var str1 = String(_uniqueIndex1)
        var str2 = String(_uniqueIndex2)
        
        while str1.characters.count < 4 { str1 = String("0") + str1 }
        while str2.characters.count < 4 { str2 = String("0") + str2 }
        
        _uniqueIndex1 -= 16
        if _uniqueIndex1 < 1280 {
            _uniqueIndex1 = 4096
            _uniqueIndex2 += 13
            if _uniqueIndex2 >= 8012 {
                _uniqueIndex2 = 2048
            }
        }
        
        return (ApplicationController.uuid + "_" + String(ApplicationController.tick) + "_" + str1 + "_") + str2
    }
    
    
    func save() {
        
    }
    
    func load() {
        
    }
}

//let Config.shared = Config()

