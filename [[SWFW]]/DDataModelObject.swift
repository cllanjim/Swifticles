//
//  DDataModelVenue.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDataModelObject : DDataModel
{
    var mName:String! = nil
    
    var mID:Int! = 0
    var mIDString:String! = nil
    
    required init()
    {
        super.init()
    }
    
    func copyFrom(object pObject: DDataModelObject!)
    {
        if(pObject != nil)
        {
            self.mID = pObject.mID;
            self.mName = String(pObject.mName)
            self.mIDString = String(pObject.mIDString)
            super.copyFrom(model: pObject)
        }
    }
    
    override func destroy()
    {
        self.mName = nil;
        self.mIDString = nil;
        
        super.destroy();
    }
}
