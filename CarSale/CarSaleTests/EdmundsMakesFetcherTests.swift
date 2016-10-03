//
//  EdmundsMakesFetcherTests.swift
//  CarSale
//
//  Created by Raptis, Nicholas on 9/28/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import XCTest

@testable import CarSale

class EdmundsMakesFetcherTests: XCTestCase {
    
    var fetcher:EdmundsMakesFetcher!
    
    override func setUp() {
        super.setUp()
        
        fetcher = EdmundsMakesFetcher()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEdmundsMakesFetcherExists() {
        XCTAssert(fetcher != nil)
    }
    
    func testFetch() {
        
    }
    
    /*
    //Test the whole pipeline.. location, web service, etc
    func testWebService()
    {
        let expectation = expectationWithDescription("refresh")
        
        self.vc.refreshBegin(false);
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 9000 * Int64(NSEC_PER_MSEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10.0) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            XCTAssert(self.vc.arrayWeatherNodes.count > 11)
        }
        
    }
    */
    
    
}
