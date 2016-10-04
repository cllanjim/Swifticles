//
//  HomePageCell.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/28/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class HomePageMakeCell : ImageSetCell
{
    
    @IBOutlet weak var imageAcc1: UIImageView!
    @IBOutlet weak var imageAcc2: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    var make:EdmundsMake? {
        didSet {
            if make != nil {
                labelName.text = make!.name
                if let _set = make!.set {
                    self.set = _set
                }
            }
        }
    }
    
    override func animateLoadComplete() {
        super.animateLoadComplete()
        
        let scaleTransform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        
        imageAcc1.layer.transform = scaleTransform
        imageAcc1.isHidden = false
        imageAcc1.alpha = 0.0
        imageAcc2.layer.transform = scaleTransform
        imageAcc2.isHidden = false
        imageAcc2.alpha = 0.0
        UIView.animate(withDuration: 0.34, delay: 0.28, options: .curveEaseIn, animations: { [weak weakSelf = self] in
                weakSelf?.imageAcc1.layer.transform = CATransform3DIdentity
                weakSelf?.imageAcc1.alpha = 1.0
            }, completion: nil)
        UIView.animate(withDuration: 0.56, delay: 0.28, options: .curveEaseIn, animations: { [weak weakSelf = self] in
                weakSelf?.imageAcc2.layer.transform = CATransform3DIdentity
                weakSelf?.imageAcc2.alpha = 1.0
            }, completion: nil)
    }
    
    override func reset() {
        super.reset()
        imageAcc1.isHidden = true
        imageAcc2.isHidden = true
    }
}
