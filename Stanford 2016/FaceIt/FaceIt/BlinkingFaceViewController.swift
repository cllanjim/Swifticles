//
//  BlinkingFaceViewController.swift
//  FaceIt
//
//  Created by Raptis, Nicholas on 7/21/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController {

    
    var blinking:Bool = false {
        
        didSet {
            startBlink()
        }
        
    }
    
    private struct BlinkRate {
        
        static let ClosedDuration = 0.4
        static let OpenDuration = 2.5
        
    }
    
    @objc private func startBlink() {
        
        if blinking {
            faceView.eyesOpen = false
            
            NSTimer.scheduledTimerWithTimeInterval(BlinkRate.ClosedDuration,
                target: self,
                selector: #selector(BlinkingFaceViewController.endBlink(_:)),
                userInfo: nil,
                repeats: false)
        }
    }
    
    //lol..
    //@objc private
    func endBlink(timer:NSTimer) {
        
        faceView.eyesOpen = true
        
        NSTimer.scheduledTimerWithTimeInterval(BlinkRate.OpenDuration,
            target: self,
            selector: #selector(BlinkingFaceViewController.startBlink),
            userInfo: nil,
            repeats: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        blinking = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        blinking = false
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
