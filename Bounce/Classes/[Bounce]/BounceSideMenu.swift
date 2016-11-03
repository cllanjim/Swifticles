//
//  SideMenu.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 11/2/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class BounceSideMenu: UIView {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonHome:UIButton!
    @IBOutlet weak var buttonNew:UIButton!
    @IBOutlet weak var buttonSave:UIButton!
    @IBOutlet weak var buttonUpload:UIButton!
    
    func setUp() {
        
    }
    
    @IBAction func clickHome(sender: AnyObject) {
        ToolActions.home()
    }
    
    @IBAction func clickNew(sender: AnyObject) {
        ToolActions.new()
    }
    
    @IBAction func clickSave(sender: AnyObject) {
        ToolActions.save()
    }
    
    @IBAction func clickUpload(sender: AnyObject) {
        ToolActions.upload()
    }
    
}
