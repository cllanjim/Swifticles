//
//  MPGCell.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/11/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class MPGCell : StatCell
{
    @IBOutlet weak var cityLabel: UILabel?
    @IBOutlet weak var highwayLabel: UILabel?
    
    override func setUp() {
        super.setUp()
    }
    
    override func reset() {
        super.reset()
        
        cityLabel?.text = ""
        highwayLabel?.text = ""
    
    }
}

