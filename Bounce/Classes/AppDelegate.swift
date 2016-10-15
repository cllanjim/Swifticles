//
//  AppDelegate.swift
//  DemoFlow
//
//  Created by Raptis, Nicholas on 10/13/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /*
    open override var shouldAutorotate : Bool {
        if (visibleViewController as? BounceViewController) != nil {
            //print("NC.shouldAutorotate(false)")
            return false
        }
        return true
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if let vc = visibleViewController {
            //let supported = vc.supportedInterfaceOrientations
            //print("Supported Orientations = \(supported)")
            return vc.supportedInterfaceOrientations
        }
        
        var mask = UIInterfaceOrientationMask(rawValue: 0)
        mask = mask.union(.portrait)
        mask = mask.union(.portraitUpsideDown)
        mask = mask.union(.landscapeLeft)
        mask = mask.union(.landscapeRight)
        return mask
    }
    */
    
}

@UIApplicationMain
class AppDelegate: AppDelegateBase {
    static let root = RootViewController()
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if super.application(application, didFinishLaunchingWithOptions: launchOptions) {
            initialize(withRoot: AppDelegate.root)
            return true
        }
        return false
    }
}

