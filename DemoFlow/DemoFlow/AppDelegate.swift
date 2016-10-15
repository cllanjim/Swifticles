//
//  AppDelegate.swift
//  DemoFlow
//
//  Created by Raptis, Nicholas on 10/13/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

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

