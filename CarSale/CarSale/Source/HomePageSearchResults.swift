//
//  HomePageSearchResults.swift
//  CarSale
//
//  Created by Nicholas Raptis on 10/1/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class HomePageSearchResults : UIView, UITableViewDelegate
{
    
    weak var homePage: HomePage!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            
        }
    }
    
    var blurEffect = UIBlurEffect(style: .extraLight)
    var _blurEffectView:UIVisualEffectView?
    var blurEffectView:UIVisualEffectView {
        if _blurEffectView == nil {
            _blurEffectView = UIVisualEffectView(frame: bounds)
        }
        return _blurEffectView!
    }
    
    
    
    func animateIn() {
        
        isHidden = false
        
        blurEffectView.frame = self.bounds
        
        tableView.alpha = 0.0
        
        if blurEffectView.superview == nil {
            self.insertSubview(blurEffectView, belowSubview: tableView)
        }
        
        UIView.animate(withDuration: 0.54, delay: 0.1, options: .curveEaseOut, animations: { [weak weakSelf = self] in
            weakSelf?.blurEffectView.effect = weakSelf?.blurEffect
            weakSelf?.tableView.alpha = 1.0
            
            }, completion: { didFinish in
        })
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.54, delay: 0.0, options: .curveEaseIn, animations: { [weak weakSelf = self] in
            weakSelf?.blurEffectView.effect = nil
            weakSelf?.tableView.alpha = 0.0
            }, completion: { [weak weakSelf = self] (didFinish:Bool) in
                
                weakSelf?.blurEffectView.removeFromSuperview()
                weakSelf?.isHidden = true
            })
        
        
    }
    
    
    
    
}












