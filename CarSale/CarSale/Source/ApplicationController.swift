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
    static let shared = ApplicationController()
    private init() { }
    
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
    
    class var tick: Int {
        return Int(Date().timeIntervalSince1970 * 100.0)
    }
    
    class var uuid:String {
        return UUID().uuidString
    }
}
