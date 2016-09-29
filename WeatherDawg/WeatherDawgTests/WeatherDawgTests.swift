//
//  WeatherDawgTests.swift
//  WeatherDawgTests
//
//  Created by Nicholas Raptis on 3/23/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import XCTest
@testable import WeatherDawg

class WeatherDawgTests: XCTestCase {
    
    var vc:ViewController!
    
    override func setUp() {
        super.setUp()
        self.vc = UIApplication.sharedApplication().windows[0].rootViewController as! ViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
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
    
    //Test the whole pipeline with drag.. essentially to provide more coverage.
    func testDrags()
    {
        let expectation = expectationWithDescription("refresh")
        
        //test all scrolling branches...
        self.vc.scrollViewDidScroll(self.vc.tableViewWeather)
        self.vc.refresh = false
        self.vc.scrollViewDidScroll(self.vc.tableViewWeather)
        self.vc.tableViewWeather.contentOffset = CGPoint(x: 0.0, y: -100)
        self.vc.scrollViewDidScroll(self.vc.tableViewWeather)
        self.vc.scrollViewWillBeginDecelerating (self.vc.tableViewWeather)
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 9000 * Int64(NSEC_PER_MSEC))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10.0) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            XCTAssert(self.vc.arrayWeatherNodes.count > 14)
        }
    }
    
    func testURL() {
        
        let urlString:String = vc.webServiceURL()
        let url:NSURL! = NSURL(string: urlString)
        let data:NSMutableData! = NSMutableData(contentsOfURL: url)
        
        XCTAssert(data.length > 0)
    }
    
}
