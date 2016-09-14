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
        
        
    }
    
    func expand() {
        print("EXPAND")
        
        if expanded == false {
            
            
            expanded = true
            
            
            //self.layoutIfNeeded()
            print("Expand Rect Start [\(frame.origin.x), \(frame.origin.y) \(frame.size.width), \(frame.size.height)]")
            
            
            menuHeightConstraint.constant = 88//toolBar.height + toolMenuContainer.height
            setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: 4.6, animations: {
                [weakSelf = self] in
                weakSelf.layoutIfNeeded()
                
                print("Expand Rect End [\(weakSelf.frame.origin.x), \(weakSelf.frame.origin.y) \(weakSelf.frame.size.width), \(weakSelf.frame.size.height)]")
                
                }, completion: {b in
            
                    print("Expand Rect 2 End [\(self.frame.origin.x), \(self.frame.origin.y) \(self.frame.size.width), \(self.frame.size.height)]")
                    
            })
            
            /*
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.15, options: .curveEaseInOut, animations: { [weakSelf = self] in
                
                weakSelf.menuHeightConstraint.constant = weakSelf.toolBar.height + weakSelf.toolMenuContainer.height
                self.layoutIfNeeded()
                }, completion: { b in
                    
            })
            */
            
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
            
            
            //self.layoutIfNeeded()
            
            print("Collapse Rect Start [\(frame.origin.x), \(frame.origin.y) \(frame.size.width), \(frame.size.height)]")
            
            
            menuHeightConstraint.constant = toolBar.height
            setNeedsUpdateConstraints()
            
            
            //UIViewAnimationOptionLayoutSubviews and/or UIViewAnimationOptionBeginFromCurrentState
            
            UIView.animate(withDuration: 4.6, delay: 0.0, options: [.beginFromCurrentState], animations: {
                [weakSelf = self] in
                //weakSelf.menuHeightConstraint.constant = weakSelf.toolBar.height
                weakSelf.layoutIfNeeded()
                
                print("Collapse Rect End [\(weakSelf.frame.origin.x), \(weakSelf.frame.origin.y) \(weakSelf.frame.size.width), \(weakSelf.frame.size.height)]")
                
                
                
                }, completion: {b in
            
                    print("Collapse Rect End 2 [\(self.frame.origin.x), \(self.frame.origin.y) \(self.frame.size.width), \(self.frame.size.height)]")
                    
            
            })
            
            //UIView.animate(withDuration: 4.6, animations: {
              //  [weakSelf = self] in
                //weakSelf.menuHeightConstraint.constant = weakSelf.toolBar.height
                //weakSelf.layoutIfNeeded()
                //}, completion: nil)
        }
    }
    
}
