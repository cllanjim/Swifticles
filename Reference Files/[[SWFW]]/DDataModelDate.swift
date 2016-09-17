//
//  DDataModelVenue.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDataModelDate: DDataModel
{
    
    var mMinute:Int = 0
    var mSecond:Int = 0
    var mHour:Int = 0
    var mDay:Int = 0
    var mMonth:Int = 0
    var mWeek:Int = 0
    var mYear:Int = 0
    
    required init()
    {
        super.init()
    }
    
    init(date pDate: DDataModelDate!)
    {
        super.init()
        self.copyFrom(date: pDate)
    }
    
    func copyFrom(date pDate: DDataModelDate!)
    {
        if(pDate != nil)
        {
            //self.mID = pModel.mID;
            //self.mName = String(pModel.mName)
            //self.mIDString = String(pModel.mIDString)
            
        }
    }
    
    override func destroy()
    {
        
        super.destroy();
    }
    
}
