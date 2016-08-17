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
            
            gApp.navigationController.pushViewController(home, animated: true)
            
            
        }
        
        //let transition = CATransition()
        //transition.duration = 0.5
        //transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //transition.type = kCATransitionFade
        //self.navigationController?.view.layer.add(transition, forKey: nil)
        //_ = self.navigationController?.popToRootViewController(animated: false)
        
        
        
    }
    
    
}

//var gTool = ToolActions()
