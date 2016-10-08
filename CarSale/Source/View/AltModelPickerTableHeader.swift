//
//  AltModelPickerTableHeader.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 10/7/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class AltModelPickerTableHeader : UIView
{
    
    
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
        
    }

    func setUp() {
        imageView = UIImageView(frame: bounds)
        
        imageView?.image = UIImage(named: "fair_logo.png")
        
        addSubview(imageView!)
        imageView?.backgroundColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 0.7)
    }
    
    
}

