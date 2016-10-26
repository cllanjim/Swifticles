//
//  Game.swift
//  FizzBuzz
//
//  Created by Nicholas Raptis on 8/2/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import Foundation

class Game : NSObject {
    
    var score:Int
    let brain = Brain()
    
    override init() {
        score = 0
        super.init()
    }
    
    func play(move: String) -> (right: Bool, score: Int) {
        
        let result = brain.check(score + 1)
        
        //if result == move {
        //    score += 1
        //    return (true, score)
        //} else {
            return (false, score)
        //}
    }
    
    
}
