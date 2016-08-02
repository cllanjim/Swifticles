//
//  DDataModelVenue.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDataModelAddress: DDataModel
{
    var mLat:CGFloat = 0.0
    var mLon:CGFloat = 0.0
    
    var mPostalCode:Int = 0
    var mPostalCodeString:String! = nil
    
    var mCity:String! = nil
    
    var mState:String! = nil
    var mStateAbbr:String! = nil
    
    var mAddress1:String! = nil
    var mAddress2:String! = nil
    
    required init()
    {
        super.init()
    }
    
    init(address pAddress:DDataModelAddress!)
    {
        super.init()
        self.copyFrom(address: pAddress)
    }
    
    init(addr1 pAddr1:String!, addr2 pAddr2:String!,
        city pCity:String!, state pState:String!, postalCode pPostalCodeString:String!)
    {
        super.init()
        
        self.setAddress1(pAddr1)
        
        self.setAddress2(pAddr1)
        
        
        self.setCity(pCity)
        
        self.setState(pState)
        
        self.setPostalCodeString(pPostalCodeString)
    }
    
    func setAddress1(pAddr1:String!)
    {
        if(pAddr1 != nil){self.mAddress1 = String(pAddr1)}
        else{self.mAddress1 = String("")}
    }
    
    func setAddress2(pAddr2:String!)
    {
        if(pAddr2 != nil){self.mAddress2 = String(pAddr2)}
        else{self.mAddress2 = String("")}
    }
    
    func setCity(pCity:String!)
    {
        if(pCity != nil){self.mCity = String(pCity)}
        else{self.mCity = String("")}
    }
    
    func setState(pState:String!)
    {
        if(pState != nil)
        {
            self.mState = String(pState)
        }
        else
        {
            self.mState = String("")
        }
    }
    
    func setPostalCode(pPostalCode:Int32)
    {
        
    }
    
    func setPostalCodeString(pPostalCodeString:String!)
    {
        if(pPostalCodeString != nil)
        {
            self.mPostalCodeString = String(pPostalCodeString)
            self.mPostalCode = Int(mPostalCodeString)!
        }
        else
        {
            self.mPostalCodeString = String("")
            self.mPostalCode = 0
        }
    }
    
    func copyFrom(address pAddress: DDataModelAddress!)
    {
        if(pAddress != nil)
        {
            self.mLat = pAddress.mLat;
            self.mLon = pAddress.mLon;
            
            self.setAddress1(pAddress.mAddress1)
            self.setAddress2(pAddress.mAddress2)
            self.setCity(pAddress.mCity)
            self.setState(pAddress.mState)
            self.setPostalCodeString(pAddress.mPostalCodeString)
            
            super.copyFrom(model: pAddress)
        }
    }
    
    override func destroy()
    {
        self.mPostalCodeString = nil;
        self.mCity = nil;
        self.mState = nil;
        self.mStateAbbr = nil;
        self.mAddress1 = nil;
        self.mAddress2 = nil;
        
        super.destroy();
    }
    
}
