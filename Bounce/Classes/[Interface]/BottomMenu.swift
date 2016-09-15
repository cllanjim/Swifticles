//
//  TopMenu.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/12/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class BottomMenu: ToolView
{
    var toolRows = [ToolView]()
    var currentToolRow: ToolView?
    
    @IBOutlet weak internal var toolRowEdit: ToolRowBottomEdit!
    @IBOutlet weak internal var toolRowView: ToolRowBottomView!
    
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    //@IBOutlet weak var menuBottomConstraint: NSLayoutConstraint!
    
    var expanded:Bool = true
    
    @IBOutlet weak var toolBar: ToolBarBottom! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var toolMenuContainer: UIView! {
        didSet {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("BottomMenu.awakeFromNib()")
        
    }
    
    override func setUp() {
        super.setUp()
        
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
