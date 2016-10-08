//
//  ModelTableCell.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/7/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ModelTableCell : UITableViewCell
{
    @IBOutlet weak var titleLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //fatalError("init(coder:) has not been implemented")
    }
    
    weak var model: EdmundsModel?
    
    
    //super.init()
    
    func reset() {
        
    }
    
}



