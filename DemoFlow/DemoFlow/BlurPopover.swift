//
//  BlurPopover.swift
//  DemoFlow
//
//  Created by Raptis, Nicholas on 10/14/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class BlurPopover: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showAnotherPopover(_ sender: UIButton) {
        
        
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "popover_test") as! Popover2
        
        AppDelegate.root.showPopover(withVC: vc)
        
    }
    
    @IBAction func killPopover(_ sender: UIButton) {
    
        AppDelegate.root.killPopover()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
