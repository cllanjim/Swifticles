//
//  EdmundsSearchModel.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/1/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class EdmundsSearchModel : SearchNode
{
    var model:EdmundsModel? {
        didSet {
            if model != nil {
                setUp(model: model!)
            }
        }
    }
    
    internal func setUp(model: EdmundsModel) {
        
        
    }
    
    
}


