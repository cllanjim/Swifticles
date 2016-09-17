//
//  DDataModelVenue.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/23/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class DDataModelPrice : DDataModel
{
    var mValue:Double = 0.0
    var mString:String! = nil
    
    var mDollars:Int = 0
    var mCents:Int = 0
    
    
    required init()
    {
        super.init()
    }
    
    init(price pPrice: DDataModelPrice!)
    {
        super.init()
        self.copyFrom(price: pPrice)
    }
    
    init(float pFloat:Float)
    {
        super.init()
        //self.setPrice(string: String(pFloat))
        self.setPrice(float: pFloat)
    }
    
    init(double pDouble:Double)
    {
        super.init()
        self.setPrice(double: pDouble)
    }
    
    init(string pString:String!)
    {
        super.init()
        self.setPrice(string: pString)
    }
    
    func setPrice(string pString:String!)
    {
        var aDouble:Double = 0.0
        
        if(pString != nil)
        {
            if(pString.characters.count > 0)
            {
                if let aNumber:NSNumber = NSNumberFormatter().numberFromString(pString)
                {
                    aDouble = aNumber.doubleValue
                }
            }
        }
        setPrice(double: aDouble)
    }
    
    func setPrice(float pFloat:Float)
    {
        self.setPrice(double: Double(pFloat))
    }
    
    func setPrice(double pDouble:Double)
    {
        var aNumber:Double = pDouble
        var aNegative:Bool = false
        if(aNumber < 0){aNumber = (-aNumber);aNegative = true;}
        var aDollars:Int = Int(aNumber)
        let aWholeNumber:Double = Double(aDollars)
        let aFractionNumber:Double = (aNumber - aWholeNumber)
        var aCents:Int = Int((aFractionNumber * 100.0) + 0.5)
        if(aCents >= 100){aCents = 0;aDollars += 1;}
        if(aNegative == true){aDollars = -aDollars;}
        self.setPrice(dollars: aDollars, cents: aCents)
    }
    
    func setPrice(dollars pDollars:Int, cents pCents:Int)
    {
        mDollars = pDollars
        mCents = pCents
        mValue = Double(pDollars) + (Double(pCents) / 100.0)
        var aCentsString:String = String(mCents)
        while(aCentsString.characters.count <= 1)
        {aCentsString = aCentsString.stringByAppendingString(String("0"))}
        mString = String("$")
        mString = mString.stringByAppendingString(String(mDollars))
        mString = mString.stringByAppendingString(String("."))
        mString = mString.stringByAppendingString(aCentsString)
    }
    
    func copyFrom(price pPrice: DDataModelPrice!)
    {
        if(pPrice != nil)
        {
            self.mValue = pPrice.mValue;
            self.mString = String(pPrice.mString)
            self.mDollars = pPrice.mDollars
            self.mCents = pPrice.mCents
        }
    }
    
    override func destroy()
    {
        self.mString = nil;
        super.destroy();
    }
    
}
