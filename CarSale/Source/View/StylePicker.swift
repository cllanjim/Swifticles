//
//  TrimPicker.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

protocol StylePickerDelegate
{
    func didPickStyle(picker: StylePicker, trim: EdmundsStyle)
}


class StylePicker : UIView
{
    var delegate:StylePickerDelegate?
    //weak var VehicleInfoPage
    
    
    
    
}

