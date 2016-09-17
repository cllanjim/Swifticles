//
//  PopMenuUITests.swift
//  TDDMenuTest
//
//  Created by Raptis, Nicholas on 9/16/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import XCTest
//@testable import TDDMenuTest
//import ViewController
@testable import TDDMenuTest

class PopMenuUITests: XCTestCase {
    
    var storyboard:UIStoryboard!
    var vc:ViewController!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        UIApplication.shared.keyWindow!.rootViewController = vc
        
        let _ = vc.view
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPopMenuExists() {
        let popMenu = PopMenu()
        XCTAssertNotNil(popMenu)
    }
    
    func testShowPopMenuButtonExists() {
        XCTAssertNotNil(vc.popMenuButton)
    }
    
    
}
