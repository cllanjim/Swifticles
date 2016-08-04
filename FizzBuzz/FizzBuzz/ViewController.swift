//
//  ViewController.swift
//  FizzBuzz
//
//  Created by Nicholas Raptis on 8/2/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberButton: UIButton!
    
    var game:Game!
    var gameScore:Int! {
        didSet {
            numberButton!.setTitle("\(gameScore)", forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        game = Game()
        
        guard let checkedGame = game else {
            print("Game is nil")
            return
        }
        
        gameScore = checkedGame.score
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func play(move: String) {
     
        game.play(move)
        gameScore = game.score
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
     
        guard let unwrappedScore = gameScore else {
            print("Game score is nil")
            return
        }
        
        let nextScore = unwrappedScore + 1
        play("\(nextScore)")
    }

}

