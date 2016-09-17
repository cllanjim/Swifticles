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
    
    var importScale:CGFloat {
        var result = gDevice.scale * 2.0
        if result > 4.0 {
            result = 4.0
        }
        return result
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
    
    var sceneMode:SceneMode {
        get {
            if let mode = engine?.sceneMode { return mode }
            return .edit
        }
        set {
            engine?.sceneMode = newValue
        }
    }
    
    var editMode:EditMode {
        get {
            if let mode = engine?.editMode { return mode }
            return .affine
        }
        set {
            engine?.editMode = newValue
        }
    }
    
    var zoomMode:Bool {
        get {
            if engine != nil { return engine!.zoomMode }
            return true
        }
        set {
            if engine != nil { engine!.zoomMode = newValue }
        }
    }
    
    var width:CGFloat {
        if let result = bounce?.screenRect.size.width { return result }
        if gDevice.isLandscape {
            return gDevice.landscapeWidth
        } else {
            return gDevice.portraitWidth
        }
    }
    
    var height:CGFloat {
        if let result = bounce?.screenRect.size.height { return result }
        if gDevice.isLandscape {
            return gDevice.landscapeHeight
        } else {
            return gDevice.portraitHeight
        }
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


