//
//  ApplicationController.swift
//  Bounce
//
//  Created by Nicholas Raptis on 9/19/15.
//  Copyright (c) 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ApplicationController
{
    var storyboard:UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func getStoryboardVC(_ name:String) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: name)
    }
    
    var appDelegate:AppDelegate {
        return (UIApplication.shared.delegate as! AppDelegate)
    }
    
    var navigationController:UINavigationController {
        let navigationController = appDelegate.window!.rootViewController as? UINavigationController
        return navigationController!
    }
    
    var bounce:BounceViewController? {
        for vc:UIViewController in navigationController.viewControllers {
            if vc.isKind(of: BounceViewController.self) {
                if let bounce = vc as? BounceViewController {
                    return bounce
                }
            }
        }
        return nil
    }
    
    var width:CGFloat {
        if let result = bounce?.screenRect.size.width { return result }
        return 320.0
    }
    
    var height:CGFloat {
        if let result = bounce?.screenRect.size.height { return result }
        return 320.0
    }
    
    var engine:BounceEngine? {
        if let checkBounce = bounce {
            return checkBounce.engine
        }
        return nil
    }
    
    var bottomMenu:BottomMenu? {
        return bounce?.bottomMenu
    }
    
    
}

let gApp = ApplicationController()


