//
//  GameTests.swift
//  FizzBuzz
//
//  Created by Nicholas Raptis on 8/2/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import XCTest

@testable import FizzBuzz

class GameTests: XCTestCase {

    let game = Game()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGameStartsAtZero() {
        XCTAssertTrue(game.score == 0)
    }
    
    func testOnPlayScoreIncremented() {
        game.play("1")
        XCTAssertTrue(game.score == 1)
    }
    
    func testIfMoveIsRight() {
        game.score = 2
        let result = game.play("Fizz")
        XCTAssertEqual(result, true)
    }
    
    func testIfMoveIsWrong() {
        game.score = 1
        let result = game.play("Fizz")
        XCTAssertFalse(result)
    }
    
    func testIfBuzzMoveIsRight() {
        game.score = 4
        let result = game.play("Buzz")
        XCTAssertTrue(result)
    }
    
    func testIfBuzzMoveIsWrong() {
        game.score = 5
        let result = game.play("Buzz")
        XCTAssertFalse(result)
    }
    
    func testIfFizzBuzzMoveIsRight() {
        game.score = 14
        let result = game.play("FizzBuzz")
        XCTAssertTrue(result)
    }
    
    func testIfFizzBuzzMoveIsWrong() {
        game.score = 20
        let result = game.play("FizzBuzz")
        XCTAssertFalse(result)
    }
    
    
    func testIfNumberMoveIsRight() {
        game.score = 1
        let result = game.play("2")
        XCTAssertTrue(result)
    }
    
    func testIfNumberMoveIsWrong() {
        game.score = 6
        let result = game.play("6")
        XCTAssertFalse(result)
    }
    
    func testIfMoveWrongScoreNotIncremented() {
        game.score = 1
        game.play("Fizz")
        XCTAssertEqual(game.score, 1)
    }
    
    

}












































