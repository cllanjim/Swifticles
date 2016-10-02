//
//  HomePageHeader.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/28/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class HomePageHeader : UIView, UITextFieldDelegate
{
    weak var homePage: HomePage!
    
    @IBOutlet weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
        }
    }
    
    @IBOutlet weak var defaultUIContainer: UIView!
    @IBOutlet weak var searchUIContainer: UIView! {
        didSet {
            searchUIContainer.alpha = 0.0
        }
    }
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchCancelButton: UIButton!
    
    

    @IBAction func clickSearch(_ sender: UIButton) {
        
        animateSearchModeOn()
        homePage.animateSearchModeOn()
        searchField.becomeFirstResponder()
    }
    
    @IBAction func clickSearchCancel(_ sender: UIButton) {
        animateSearchModeOff()
        homePage.animateSearchModeOff()
        searchField.resignFirstResponder()
    }
    
    
    
    //optional public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    
    
    
    // became first responder
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchField.resignFirstResponder()
        
        return true
    }
    
    
    
    internal func animateSearchModeOn() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .transitionCrossDissolve, animations: { [weak weakSelf = self] in
            weakSelf?.defaultUIContainer.alpha = 0.0
            weakSelf?.searchUIContainer.alpha = 1.0
            }, completion: { didFinish in
        })
    }
    
    internal func animateSearchModeOff() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .transitionCrossDissolve, animations: { [weak weakSelf = self] in
            weakSelf?.defaultUIContainer.alpha = 1.0
            weakSelf?.searchUIContainer.alpha = 0.0
            }, completion: { didFinish in
        })
    }
}

