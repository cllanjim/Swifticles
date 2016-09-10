//
//  ToolActions.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/16/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ToolActions {
    
    class func menu() {
        print("ToolActions.menu()")
        
        if let home = gApp.getStoryboardVC("home_menu") as? HomeMenuViewController {
            
            let nc = gApp.navigationController
            
            let transition = CATransition()
            transition.duration = 0.54
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionReveal
            nc.view.layer.addAnimation(transition, forKey: nil)
            
            gApp.navigationController.setViewControllers([home], animated: true)
            gApp.navigationController.setNavigationBarHidden(false, animated: true)
        }
    }
    
    class func addBlob() {
        gApp.engine?.addBlob()
    }
    
    class func setZoomMode(zoomMode zm:Bool) {
        gApp.engine?.zoomMode = zm
    }
    
    
    //class func set
    
    
    
}

//var gTool = ToolActions()
