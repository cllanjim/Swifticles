//
//  Popover2.swift
//  DemoFlow
//
//  Created by Raptis, Nicholas on 10/14/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class Popover2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showAnotherPopover(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: "Tutorial", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "popover_test") as! BlurPopover
        
        AppDelegate.root.showPopover(withVC: vc)
        
    }
    
    @IBAction func killPopover(_ sender: UIButton) {
        
        AppDelegate.root.killPopover()
        
    }
}
