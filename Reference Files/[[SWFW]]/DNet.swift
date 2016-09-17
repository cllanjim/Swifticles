//
//  ScriptRelief.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

//import UIKit
import Foundation

class DNet : DSObject
{
    required init()
    {
        super.init()
    }
    
    func appendURL(pURL: String!, pAppend: String!) -> String!
    {
        var aReturn:String! = String("")
        
        if(pURL != nil)
        {
            if(pURL.characters.count > 0)
            {
                aReturn = aReturn.stringByAppendingString(pURL)
            }
        }
        
        if(pAppend != nil)
        {
            if(pAppend.characters.count > 0)
            {
                
                if(aReturn.characters.count > 0)
                {
                    /*
                    
                    if(aReturn[aReturn.characters.count - 1] == "/")
                    {
                        
                    }
                    
                    
                    et stringLength = count(name) // Since swift1.2 `countElements` became `count`
                    let substringIndex = stringLength - 1
                    name.substringToIndex(advance(name.startIndex, substringIndex)) // "Dolphi"
                    
                    */
                }
                
                aReturn = aReturn.stringByAppendingString(pAppend)
            }
            
            //et stringLength = count(name) // Since swift1.2 `countElements` became `count`
            //let substringIndex = stringLength - 1
            //name.substringToIndex(advance(name.startIndex, substringIndex)) // "Dolphi"
            
        }
        
        
        return aReturn
    }
    
    class var shared: DNet
    {
        struct Static{static var cTokenOnce: dispatch_once_t = 0;static var cInstance: DNet? = nil;}
        dispatch_once(&Static.cTokenOnce){Static.cInstance = DNet()}
        return Static.cInstance!
    }
    
    override func destroy()
    {
        super.destroy()
    }
}

let gNet:DNet = DNet.shared;
