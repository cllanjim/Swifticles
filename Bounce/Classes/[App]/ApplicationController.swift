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
    
    weak internal var _navigationController:UINavigationController?
    var navigationController:UINavigationController {
        if _navigationController != nil {
            return _navigationController!
        } else {
            _navigationController = appDelegate.window!.rootViewController as? UINavigationController
            return _navigationController!
        }
    }
    
    var importScale:CGFloat {
        var result = gDevice.scale * 2.0
        if result > 4.0 {
            result = 4.0
        }
        return result
    }
    
    weak internal var _bounce:BounceViewController?
    var bounce:BounceViewController? {
        get {
            return _bounce
            /*
            if _bounce != nil {
                return _bounce
            } else {
                for vc:UIViewController in navigationController.viewControllers {
                    if vc.isKind(of: BounceViewController.self) {
                        if let bounce = vc as? BounceViewController {
                            return bounce
                        }
                    }
                }
                return nil
            }
            */
        }
        set {
            _bounce = newValue
        }
        
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
    
    weak internal var _engine:BounceEngine?
    var engine:BounceEngine? {
        get {
            return _engine
            /*
            if _engine != nil {
                return _engine
            } else {
                return bounce?.engine
                return nil
            }
            */
        }
        set {
            _engine = newValue
        }
    }
    
    var bottomMenu:BottomMenu? {
        return bounce?.bottomMenu
    }
    
}

let gApp = ApplicationController()


