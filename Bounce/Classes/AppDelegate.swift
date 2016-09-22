//
//  AppDelegate.swift
//  Bounce
//
//  Created by Nicholas Raptis on 8/7/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit


extension UINavigationController {
    open override var shouldAutorotate : Bool {
        if (visibleViewController as? BounceViewController) != nil {
            //print("NC.shouldAutorotate(false)")
            //return false
        }
        return true
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if let vc = visibleViewController {
            return vc.supportedInterfaceOrientations
        }
        var mask = UIInterfaceOrientationMask(rawValue: 0)
        mask = mask.union(.portrait)
        mask = mask.union(.portraitUpsideDown)
        mask = mask.union(.landscapeLeft)
        mask = mask.union(.landscapeRight)
        return mask
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //for i in 0..<100000 {
        //    print("\(Config.shared.uniqueString)")
        //}
        //print("___")
        
        /*
        //let oq = NSOperationQueue.mainQueue()
        let oq = NSOperationQueue()
        
        
        let oper1 = NSBlockOperation { 
            
            print("oper1.mainBlock...")
            
            let url = NSURL(string: "http://allstarcharts.com/wp-content/uploads/2012/01/1-9-12-DJIA-1896-2012.jpg")
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            print("Image Size [\(image!.size.width) x \(image!.size.height)]")
            
        }
        

        oper1.completionBlock = {
            
            print("oper1.completionBlock")
            
        }
        
        let oper2 = NSOperation()
        oper2.completionBlock = {
            print("oper2.completionBlock")
            
        }
        
        oper2.addDependency(oper1)
        //oper1.addDependency(oper2)
    
        
        let oper3 = NSOperation()
        oper3.completionBlock = {
            print("oper3.completionBlock")
            
        }
        
        oper3.addDependency(oper1)
        oper3.addDependency(oper2)
        
        
        
        
        
        //oper1.addDependency(oper1)
        
        
        oq.addOperations([oper1, oper2, oper3], waitUntilFinished: false)
        */
        
        
        
        print("device width = \(Device.shared.width)\ndevice height = \(Device.shared.height)")
        print("portrait width = \(Device.shared.portraitWidth)\nportrait height = \(Device.shared.portraitHeight)")
        print("landscape width = \(Device.shared.landscapeWidth)\nlandscape height = \(Device.shared.landscapeHeight)")
        
        
        ApplicationController.shared.navigationController.delegate = self
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    class ViewController: UIViewController, UINavigationControllerDelegate {
        func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
}

