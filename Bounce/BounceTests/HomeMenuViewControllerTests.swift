//
//  HomeMenuViewControllerTests.swift
//  Bounce
//
//  Created by Raptis, Nicholas on 8/9/16.
//  Copyright © 2016 Darkswarm LLC. All rights reserved.
//

import XCTest
@testable import Bounce

class HomeMenuViewControllerTests: XCTestCase {

    var homeMenuViewController:HomeMenuViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        homeMenuViewController = storyboard.instantiateViewController(withIdentifier: "home_menu") as! HomeMenuViewController
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testImagePickerExists() {
        //HomeMenuViewController.showImagePicker()
        //XCTAssert(HomeMenuViewController.imagePickerViewController != nil)
    }

}
