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
        
        
    }
    
    func expand() {
        print("EXPAND")
        
        if expanded == false {
            
            
            expanded = true
            
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.15, options: .curveEaseInOut, animations: { [weakSelf = self] in
                
                weakSelf.menuHeightConstraint.constant = weakSelf.toolBar.height + weakSelf.toolMenuContainer.height
                
                }, completion: { b in
                    
            })
            
            
            //toolBar: ToolBarBottom! {
            //    didSet {
                    
            //    }
            //}
            
            //@IBOutlet weak var toolMenuContainer
            
            
            //gApp.bounce?.screenRect.
            
            
        }
        
    }
    
    func collapse() {
        print("COLLAPSE")
        if expanded == true {
            
            
            expanded = false
            
            UIView.animate(withDuration: 0.6, animations: { [weakSelf = self] in
                
                weakSelf.menuHeightConstraint.constant = weakSelf.toolBar.height
                
                //weakSelf.menuHeightConstraint.constant = 30.0
                //self.view.frame.size.height = weakSelf.toolBar.bounds.size.height
                //self.view.frame.origin.y = gApp.height - self.view.frame.size.height
                }, completion: { b in
                    
            })
        }
    }
    
}
