//
//  ToolBarTop.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/16/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolBarTop: UIView {
    
    @IBOutlet weak var buttonMenu: TBButton!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUp()
    }
    
    internal func setUp() {
        
    }
    
    @IBAction func clickMenu(sender: AnyObject) {
        
        ToolActions.menu()
    }
    
    deinit {
        print("ToolBarTop.deinit()")
    }
    
    
}