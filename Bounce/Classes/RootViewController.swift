//
//  RootViewController.swift
//  DemoFlow
//
//  Created by Raptis, Nicholas on 10/13/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit
import CoreMotion

class RootViewController: RootViewControllerBase {
    
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        
        ApplicationController.shared.root = self
        
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        setStoryboard(storyboard, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open override var shouldAutorotate : Bool {
        
        /*
        if let nc = currentViewController as? UINavigationController {
            if (nc.visibleViewController as? BounceViewController) != nil {
                return false
            }
        }
        */
        
        return true
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        if let nc = currentViewController as? UINavigationController {
            if let vc = nc.visibleViewController {
                return vc.supportedInterfaceOrientations
            }
        }
        
        var mask = UIInterfaceOrientationMask(rawValue: 0)
        mask = mask.union(.portrait)
        mask = mask.union(.portraitUpsideDown)
        mask = mask.union(.landscapeLeft)
        mask = mask.union(.landscapeRight)
        return mask
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        motionManager.startDeviceMotionUpdates()
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        
    }
    
    override func didBecomeInactive() {
        super.didBecomeInactive()
        
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        
    }
    
}
