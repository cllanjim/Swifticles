//
//  ImageSetCell.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/29/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ImageSetCell : UICollectionViewCell
{
    var set: ImageSet?
    
    var needsFetch: Bool = true
    func setNeedsFetch() {
        needsFetch = true
    }
    
    @IBOutlet weak var imageView: UIImageView? {
        didSet {
            
        }
    }
    
    
}
