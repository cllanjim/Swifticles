//
//  LocateDealerCell.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class LocateDealerCell : UITableViewCell
{
    @IBOutlet weak var titleLabel:UILabel!
    
    @IBOutlet weak var buttonMap:UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp() {
        
    }
    
    func reset() {
        
    }
    
}


