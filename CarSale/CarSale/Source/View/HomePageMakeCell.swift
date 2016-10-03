//
//  HomePageCell.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/28/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class HomePageMakeCell : ImageSetCell
{
    @IBOutlet weak var labelName: UILabel!
    
    var make:EdmundsMake? {
        didSet {
            
            if make != nil {
                labelName.text = make!.name
                
                if let _set = make!.set {
                    self.set = _set
                }
            }
        }
    }
    
    override func reset() {
        super.reset()
    }
}
