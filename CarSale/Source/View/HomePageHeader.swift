//
//  HomePageHeader.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/28/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class HomePageHeader : UIView, UITextFieldDelegate
{
    weak var homePage: HomePage!
    
    weak var searchResults: HomePageSearchResults!
    
    @IBOutlet weak var searchField: UITextField! {
        didSet {
            searchField.delegate = self
            
            searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            
        }
    }
    
    //pTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    @IBOutlet weak var defaultUIContainer: UIView!
    @IBOutlet weak var searchUIContainer: UIView! {
        didSet {
            searchUIContainer.alpha = 0.0
        }
    }
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchCancelButton: UIButton!
    

    

    @IBAction func clickSearch(_ sender: UIButton) {
        
        reset()
        
        animateSearchModeOn()
        homePage.searchMode = true
        searchField.becomeFirstResponder()
    }
    
    @IBAction func clickSearchCancel(_ sender: UIButton) {
        animateSearchModeOff()
        homePage.searchMode = false
        searchField.resignFirstResponder()
    }
    
    public func textFieldDidChange(_ textField: UITextField) {
        print("Text = \(searchField.text)")
        
        if let text = searchField.text {
            searchResults.updateSearchText(text: text)
        } else {
            searchResults.updateSearchText(text: "")
        }
    }
    
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
    
    func reset() {
        searchField.text = ""
        
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

