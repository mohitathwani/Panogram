//
//  PanogramUITests.swift
//  PanogramUITests
//
//  Created by Labs on 6/27/17.
//  Copyright © 2017 Tera Mo Labs. All rights reserved.
//

import XCTest

class PanogramUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
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
    
    func testSelectImageTap() {
        let app = XCUIApplication()
        app.buttons["Select Image"].tap()
        app.tables.children(matching: .cell).element.tap()
        
        let leftImageView = app.images["Left Image View"]
        let centerImageView = app.images["Center Image View"]
        let rightImageView = app.images["Right Image View"]
        
        XCTAssertTrue(leftImageView.exists)
        XCTAssertTrue(centerImageView.exists)
        XCTAssertTrue(rightImageView.exists)
        
    }
    
}
