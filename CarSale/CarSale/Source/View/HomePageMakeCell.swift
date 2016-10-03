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
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loadOverlayView: UIView!
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
    
    func animateLoadComplete() {
        loadSpinner.stopAnimating()
        let scaleTransform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        imageAcc1.layer.transform = scaleTransform
        imageAcc2.layer.transform = scaleTransform
        imageAcc1.isHidden = false
        imageAcc2.isHidden = false
        imageAcc1.alpha = 0.0
        imageAcc2.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: { [weak weakSelf = self] in
                weakSelf?.loadOverlayView.alpha = 0.0
            }, completion: { [weak weakSelf = self] didFinish in
                weakSelf?.loadOverlayView.isHidden = true
        })
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
        loadOverlayView.alpha = 1.0
        loadOverlayView.isHidden = false
        imageAcc1.isHidden = true
        imageAcc2.isHidden = true
        loadSpinner.isHidden = false
        loadSpinner.startAnimating()
    }
}
