//
//  RootViewController.swift
//  DemoFlow
//
//  Created by Raptis, Nicholas on 10/13/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class RootViewController: RootViewControllerBase {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        setStoryboard(storyboard, animated: false)
        
        //navigation_controller
        
        /*
        let nc = storyboard.instantiateViewController(withIdentifier: "main_nav") as! UINavigationController
        nc.view.frame = view.bounds
        view.addSubview(nc.view)
        nc.view.setNeedsLayout()
        */
        
        
        
        //let home = storyboard.instantiateViewController(withIdentifier: "tutorial_root") as! TutorialRoot
        
        //view.addSubview(home.view)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open override var shouldAutorotate : Bool {
        
        if let nc = currentViewController as? UINavigationController {
            if (nc.visibleViewController as? BounceViewController) != nil {
                return false
            }
        }
        
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
    
}
