//
//  ModelPageCell.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/5/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ModelPageCell : ImageSetCell
{
    @IBOutlet weak var labelName: UILabel!
    
    var model:EdmundsModel? {
        didSet {
            if model != nil {
                labelName.text = String(model!.name)
            }
        }
    }
    
    override func animateLoadComplete() {
        super.animateLoadComplete()
    }
    
    override func reset() {
        super.reset()
    }
}


