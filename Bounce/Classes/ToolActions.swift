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
        
        if let home = ApplicationController.shared.getStoryboardVC("home_menu") as? HomeMenuViewController {
            let nc = ApplicationController.shared.navigationController
            let transition = CATransition()
            transition.duration = 0.54
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionReveal
            nc?.view.layer.add(transition, forKey: nil)
            ApplicationController.shared.navigationController?.setViewControllers([home], animated: true)
            ApplicationController.shared.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    class func addBlob() {
        _ = ApplicationController.shared.engine?.addBlob()
    }
    
    class func setZoomMode(zoomMode zm:Bool) {
        ApplicationController.shared.engine?.zoomMode = zm
    }
    
    class func bottomMenuToggleExpand() {
        
        if let menu = ApplicationController.shared.bottomMenu {
            if menu.expanded {
                menu.collapse()
            } else {
                menu.expand()
            }
        }
    }
    
    class func bottomMenuToggleShowing() {
        if let menu = ApplicationController.shared.bottomMenu {
            if menu.showing {
                menu.hideAnimated()
            } else {
                menu.showAnimated()
            }
        }
    }
    
    class func undo() {
        
    }
    
    class func redo() {
        
    }
    
    
    //class func set
    
}

//var gTool = ToolActions()
