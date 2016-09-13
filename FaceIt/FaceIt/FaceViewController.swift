//
//  ViewController.swift
//  FaceIt
//
//  Created by Raptis, Nicholas on 7/14/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    
    var expression = FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown) {
        
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet{
            
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(_:))))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness))
            happierSwipeGestureRecognizer.direction = .Up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
            sadderSwipeGestureRecognizer.direction = .Down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            
            
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(recognizer: UITapGestureRecognizer) {
        
        if recognizer.state == .Ended {
            
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
            
        }
        
    }
    
    private struct Animation {
        
        static let ShakeAngle = CGFloat(M_PI / 6)
        static let ShakeDuration = 0.5125
        
    }
    
    @IBAction func headShake(sender: UITapGestureRecognizer) {
        
        UIView.animateWithDuration(Animation.ShakeDuration, animations: {
            
            self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
            
            }, completion:  { finished in
                
                UIView.animateWithDuration(Animation.ShakeDuration, animations: {
                    
                    self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, -Animation.ShakeAngle)
                    
                    }, completion:  { finished in
                        
                        UIView.animateWithDuration(Animation.ShakeDuration, animations: {
                            
                            self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
                            }, completion:nil
                        )
                    }
                )
            }
        )
    }
    
    func increaseHappiness(){
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness(){
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown:-1.0,.Grin:0.5,.Smile:1.0,.Smirk:-0.5,.Neutral:0.0]
    
    private var eyebrowTilt = [FacialExpression.EyeBrows.Relaxed:0.5, .Furrowed: -0.5, .Normal: 0.0]
    
    private func updateUI() {
        
        if faceView != nil {
            
            
            switch expression.eyes {
            case .Open:
                faceView.eyesOpen = true
            case .Closed:
                faceView.eyesOpen = false
            case .Squinting:
                faceView.eyesOpen = false
            }
            
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyebrowTilt[expression.eyeBrows] ?? 0.0
            
        }
    }
    
    
}

