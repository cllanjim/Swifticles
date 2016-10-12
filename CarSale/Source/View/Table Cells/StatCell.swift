//
//  SpecCell.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class StatCell : UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var valueLabel: UILabel?
    
    @IBOutlet weak var insetBackground: UIView?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp() {
        
        selectionStyle = .none
        
        if insetBackground != nil {
            
            
            insetBackground!.layer.shadowOffset = CGSize(width: -2, height: 2.0)
            insetBackground!.layer.shadowColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 0.20).cgColor
            insetBackground!.layer.shadowRadius = 3.0
            insetBackground!.layer.shadowOpacity = 1.0
        }
        
    }
    
    func reset() {
        
    }
}
