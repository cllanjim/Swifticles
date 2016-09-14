//
//  TopMenu.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/12/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class BottomMenu: UIView
{
    
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBottomConstraint: NSLayoutConstraint!
    
    
    var expanded:Bool = true
    
    @IBOutlet weak var toolBar: ToolBarBottom! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var toolMenuContainer: UIView! {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func awakeFromNib() {
        setUp()
    }
    
    func setUp() {
        print("func setUp() {")
        
        clipsToBounds = false
        isMultipleTouchEnabled = false
        
        
        //loadViewIfNeeded()
        //layoutIfNeeded()
        
        //menuHeightConstraint.constant = toolBar.height + toolMenuContainer.height
        //setNeedsUpdateConstraints()
        //superview?.setNeedsUpdateConstraints()
    }
    
    func expand() {
        print("EXPAND")
        
        if expanded == false {
            expanded = true
            
            menuHeightConstraint.constant = toolBar.height + toolMenuContainer.height
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 0.4, animations: {
                [weakSelf = self] in
                weakSelf.superview?.layoutIfNeeded()
                }, completion: nil)
        }
        
    }
    
    func collapse() {
        print("COLLAPSE")
        if expanded == true {
            
            expanded = false
            
            menuHeightConstraint.constant = toolBar.height
            setNeedsUpdateConstraints()
            superview?.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 0.4, animations: {
                [weakSelf = self] in
                weakSelf.superview?.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
}
