//
//  SearchResultModelCell.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/2/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class SearchResultModelCell : UITableViewCell
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
