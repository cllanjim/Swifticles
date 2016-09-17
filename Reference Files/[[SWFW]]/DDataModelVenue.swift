//
//  DDataModelVenue.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDataModelVenue: DDataModelObject
{
    var mAddress:DDataModelAddress! = nil
    var mPhoneNumber:DDataModelPhoneNumber! = nil
    
    var mOpenHoursString:String! = nil
    
    required init()
    {
        super.init()
    }
    
    init(venue pVenue:DDataModelVenue!)
    {
        super.init()
        self.copyFrom(venue: pVenue)
    }
    
    func copyFrom(venue pVenue:DDataModelVenue!)
    {
        if(pVenue != nil)
        {
            if(mAddress != nil){mAddress.destroy();self.mAddress = nil;}
            if(pVenue.mAddress != nil)
            {
                self.mAddress = DDataModelAddress(address: pVenue.mAddress)
            }

            if(mPhoneNumber != nil){mPhoneNumber.destroy();self.mPhoneNumber = nil;}
            if(pVenue.mPhoneNumber != nil)
            {
                self.mPhoneNumber = DDataModelPhoneNumber(phoneNumber: pVenue.mPhoneNumber)
            }

            self.mOpenHoursString = String(pVenue.mOpenHoursString)
            
            super.copyFrom(object: pVenue)
        }
    }
    
    override func destroy()
    {
        if(mAddress != nil){mAddress.destroy();self.mAddress = nil;}
        if(mPhoneNumber != nil){mPhoneNumber.destroy();self.mPhoneNumber = nil;}
        
        super.destroy()
    }

}
