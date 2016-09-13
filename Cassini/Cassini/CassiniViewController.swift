//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Raptis, Nicholas on 7/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {
    
    
    private struct StoryBoard {
        static let ShowImageSegue = "show_image"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == StoryBoard.ShowImageSegue {
            if let ivc = segue.destinationViewController.contentViewController as? ImageViewController {
                
                let imageName = (sender as? UIButton)?.currentTitle
                
                ivc.imageURL = DemoURL.NASAImageNamed(imageName)
                ivc.title = imageName
            }
        }
    }
    
    
    @IBAction func showImage(sender: UIButton) {
        
        if let ivc = splitViewController?.viewControllers.last?.contentViewController as? ImageViewController {
            let imageName = sender.currentTitle
            
            ivc.imageURL = DemoURL.NASAImageNamed(imageName)
            ivc.navigationItem.title = imageName
            
        } else {
            
            performSegueWithIdentifier(StoryBoard.ShowImageSegue, sender: sender)
            
        }
    }
    
    
    
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        
        if primaryViewController.contentViewController == self {
            if let ivc = secondaryViewController.contentViewController as? ImageViewController where ivc.imageURL == nil {
                return true
            }
        }
        return false
    }
}


extension UIViewController {
    
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
    
}