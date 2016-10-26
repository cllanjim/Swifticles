//
//  ViewControllerTests.swift
//  FizzBuzz
//
//  Created by Nicholas Raptis on 8/3/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import XCTest
@testable import FizzBuzz

class ViewControllerTests: XCTestCase {
    
    var viewController : ViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController
        
        let _ = viewController.view
    }
    
    func testMove1IncrementsScore() {
        viewController.play("1")
        let newScore = viewController.gameScore
        XCTAssertEqual(newScore, 1)
    }
    
    func testMove2IncrementScore() {
        viewController.play("1")
        viewController.play("2")
        let newScore = viewController.gameScore
        XCTAssertEqual(newScore, 2)
    }
    
    func testHasAGame() {
        XCTAssertNotNil(viewController.game)
    }
    
    func testOnWrongMoveScoreNotIncremented() {
        viewController.play("Fizz")
        let newScore = viewController.gameScore
        XCTAssertEqual(newScore, 0)
    }
    
    
}