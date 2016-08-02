//
//  DDataModelVenue.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDataModelPhoneNumber : DDataModel
{
    var mNumber:Int = 0
    var mNumberString:String! = nil
    
    required init()
    {
        super.init()
    }
    
    init(phoneNumber pPhoneNumber: DDataModelPhoneNumber!)
    {
        super.init()
        self.copyFrom(phoneNumber: pPhoneNumber)
    }
    
    init(string pString: String!)
    {
        super.init()
        
        if(pString != nil)
        {
            mNumberString = String(pString)
        }
    }
    
    
    func copyFrom(phoneNumber pPhoneNumber: DDataModelPhoneNumber!)
    {
        if(pPhoneNumber != nil)
        {
            self.mNumber = pPhoneNumber.mNumber;
            self.mNumberString = String(pPhoneNumber.mNumberString)
        }
    }
    
    override func destroy()
    {
        self.mNumberString = nil;
        super.destroy();
    }
    
}
