//
//  DealerPickerCell.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/12/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class DealerPickerCell : UITableViewCell
{
    
    @IBOutlet weak var titleLabel:UILabel!
    
    @IBOutlet weak var streetLabel:UILabel!
    @IBOutlet weak var cityLabel:UILabel!
    @IBOutlet weak var stateLabel:UILabel!
    @IBOutlet weak var zipLabel:UILabel!
    
    @IBOutlet weak var latLabel:UILabel!
    @IBOutlet weak var lonLabel:UILabel!
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reset() {
        
    }
    
}

