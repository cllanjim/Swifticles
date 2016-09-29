//
//  PharmacyTableCell.swift
//  OptimizeRX
//
//  Created by Nicholas Raptis on 9/28/15.
//  Copyright © 2015 Darkswarm LLC. All rights reserved.
//

import UIKit

class WeatherCell : UITableViewCell
{
    @IBOutlet weak var labelTempMin:UILabel!
    @IBOutlet weak var labelTempMax:UILabel!
    
    @IBOutlet weak var labelWeekday:UILabel!
    
    @IBOutlet weak var labelMain:UILabel!
    @IBOutlet weak var labelDesc:UILabel!
    
    //var mPharmacyCell:PharmacyCell! = nil
    //var mPharmacy:ModPharmacy! = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
    }
    
}
