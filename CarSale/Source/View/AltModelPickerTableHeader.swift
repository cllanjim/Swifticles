//
//  AltModelPickerTableHeader.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/7/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class AltModelPickerTableHeader : UIView
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    func setUp() {
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
    }
    
    
}

