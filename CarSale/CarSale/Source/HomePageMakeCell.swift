//
//  HomePageCell.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/28/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class HomePageMakeCell : ImageSetCell
{
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelURL: UILabel!
    @IBOutlet weak var labelThumbURL: UILabel!
    
    var make:EdmundsMake? {
        didSet {
            
            if make != nil {
                labelName.text = make!.name
                
                if let _set = make!.set {
                    self.set = _set
                    
                    labelURL.text = _set.imageURL
                    labelThumbURL.text = _set.thumbURL
                    
                }
                else {
                    labelURL.text = "O_O"
                    labelThumbURL.text = "O BOI"
                }
            }
        }
    }
    
    override func reset() {
        super.reset()
        
        labelURL.text = "O_O"
        labelThumbURL.text = "O BOI"
    }
    
    
}
