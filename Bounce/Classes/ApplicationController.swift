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
    
    func orientationLock(portrait portrait:Bool) {
        
    }
    
    func orientationUnlock() {
        
    }
    
    
}

let gApp = ApplicationController()


