//
//  DropItViewController.swift
//  DropIt
//
//  Created by Raptis, Nicholas on 7/21/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController {
    
    @IBOutlet weak var gameView: DropItView! {
        didSet {
            
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addDrop(_:))))
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: gameView, action: #selector(DropItView.grabDrop(_:))))
            
        }
    }
    
    
    func addDrop(rec: UITapGestureRecognizer) {
        
        if rec.state == .Ended {
            gameView.addDrop()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        gameView.animating = true
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        gameView.animating = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
