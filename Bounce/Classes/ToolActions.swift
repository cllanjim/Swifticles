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
        
        if let bounce = ApplicationController.shared.bounce, bounce.isAnimatingSideMenu == false {
            if bounce.isShowingSideMenu {
                bounce.hideSideMenu()
            } else {
                bounce.showSideMenu()
            }
        }
    }
    
    class func home() {
        if let home = ApplicationController.shared.getStoryboardVC("home_menu") as? HomeMenuViewController {
            if let nc = ApplicationController.shared.navigationController {
                let transition = CATransition()
                transition.duration = 0.54
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionReveal
                nc.view.layer.add(transition, forKey: nil)
                ApplicationController.shared.navigationController?.setViewControllers([home], animated: true)
                ApplicationController.shared.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        }
    }
    
    class func new() {
        
    }
    
    class func save() {
        
    }
    
    class func upload() {
        
    }
    
    
    class func addBlob() {
        DispatchQueue.main.async {
            _ = ApplicationController.shared.engine?.addBlob()
        }
    }
    
    class func deleteBlob() {
        DispatchQueue.main.async {
            _ = ApplicationController.shared.engine?.deleteSelectedBlob()
        }
    }
    
    class func cloneBlob() {
        DispatchQueue.main.async {
            _ = ApplicationController.shared.engine?.cloneSelectedBlob()
        }
    }
    
    class func setZoomMode(zoomMode zm:Bool) {
        DispatchQueue.main.async {
            ApplicationController.shared.engine?.zoomMode = zm
        }
    }
    
    class func bottomMenuToggleExpand() {
        DispatchQueue.main.async {
            if let menu = ApplicationController.shared.bottomMenu {
                if menu.expanded {
                    menu.collapse()
                } else {
                    menu.expand()
                }
            }
        }
    }
    
    class func topMenuToggleExpand() {
        DispatchQueue.main.async {
            if let menu = ApplicationController.shared.topMenu {
                if menu.expanded {
                    menu.collapse()
                } else {
                    menu.expand()
                }
            }
        }
    }
    
    class func menusToggleShowing() {
        DispatchQueue.main.async {
            if let bottomMenu = ApplicationController.shared.bottomMenu, let topMenu = ApplicationController.shared.topMenu {
                if bottomMenu.showing || topMenu.showing {
                    if bottomMenu.showing { bottomMenu.hideAnimated() }
                    if topMenu.showing { topMenu.hideAnimated() }
                } else {
                    if bottomMenu.showing == false { bottomMenu.showAnimated() }
                    if topMenu.showing == false { topMenu.showAnimated() }
                }
            }
        }
    }
    
    class func bottomMenuToggleShowing() {
        DispatchQueue.main.async {
            if let menu = ApplicationController.shared.bottomMenu {
                if menu.showing {
                    menu.hideAnimated()
                } else {
                    menu.showAnimated()
                }
            }
        }
    }
    
    class func setStereoscopicEnabled(_ stereoscopicEnabled:Bool) {
        DispatchQueue.main.async {
            ApplicationController.shared.engine?.stereoscopic = stereoscopicEnabled
        }
    }
    
    class func setGyroEnabled(_ gyroEnabled:Bool) {
        DispatchQueue.main.async {
            ApplicationController.shared.engine?.gyro = gyroEnabled
        }
    }
    
    class func undo() {
        DispatchQueue.main.async {
            ApplicationController.shared.engine?.undo()
        }
    }
    
    class func redo() {
        DispatchQueue.main.async {
            ApplicationController.shared.engine?.redo()
        }
    }
    
    
    //class func set
    
}

//var gTool = ToolActions()
