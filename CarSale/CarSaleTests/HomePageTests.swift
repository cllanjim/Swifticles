//
//  HomePageTests.swift
//  CarSale
//
//  Created by Nicholas Raptis on 9/28/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import XCTest

@testable import CarSale

class HomePageTests: XCTestCase {
    
    var homePage: HomePage!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        homePage = storyboard.instantiateViewController(withIdentifier: "home_page") as! HomePage
        UIApplication.shared.keyWindow!.rootViewController = homePage
        
        homePage.loadViewIfNeeded()
        homePage.view.layoutIfNeeded()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomePageExists() {
        let h = HomePage()
        XCTAssertNotNil(h)
    }
    
    func testHomePageHeaderExists() {
        let h = HomePageHeader()
        XCTAssertNotNil(h)
    }
    
    func testHomePageFromStoryboard() {
        XCTAssertNotNil(homePage)
    }
    
    func testHomePageLoaded() {
        XCTAssertNotNil(homePage.view)
    }
    
    func testHomePageCollectionViewExists() {
        XCTAssertNotNil(homePage.collectionView)
    }
    
    func testMakeFetch()
    {
        let exp = expectation(description: "refresh")
        
        homePage.makeFetcher.fetchAllMakes()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0) {
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            XCTAssert(self.homePage.makes.count > 0)
        }
        
    }
    
    
}
