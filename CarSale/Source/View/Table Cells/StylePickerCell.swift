//
//  StylePickerCell.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//


import UIKit

class StylePickerCell : UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var buttonDetail: UIButton?
    
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



