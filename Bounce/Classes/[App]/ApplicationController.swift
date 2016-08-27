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
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
    func getStoryboardVC(name:String) -> UIViewController {
        return storyboard.instantiateViewControllerWithIdentifier(name)
    }
    
    var appDelegate:AppDelegate {
        return (UIApplication.sharedApplication().delegate as! AppDelegate)
    }
    
    var navigationController:UINavigationController {
        let navigationController = appDelegate.window!.rootViewController as? UINavigationController
        return navigationController!
    }
    
    var bounce:BounceViewController? {
        for vc:UIViewController in navigationController.viewControllers {
            if vc.isKindOfClass(BounceViewController) {
                return vc as! BounceViewController
            }
        }
        return nil
    }
    
    var engine:BounceEngine? {
        if let checkBounce = bounce {
            return checkBounce.engine
        }
        return nil
    }
    
}

let gApp = ApplicationController()


