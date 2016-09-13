//
//  TopMenu.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 9/12/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class BottomMenu: UIViewController
{
    var expanded:Bool = true
    
    @IBOutlet weak var toolBar: ToolBarBottom! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var toolMenuContainer: UIView! {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func expand() {
        print("EXPAND")
        
        if expanded == false {
            
            
            expanded = true
            
            self.view.frame.size.height = 88.0 //= CGRect(x: self.view.frame.origin.x, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
            
        }
        
    }
    
    func collapse() {
        print("COLLAPSE")
        if expanded == true {
            
            
            expanded = false
            
            self.view.frame.size.height = 44.0 //= CGRect(x: self.view.frame.origin.x, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
            
        }
    }
    
}
