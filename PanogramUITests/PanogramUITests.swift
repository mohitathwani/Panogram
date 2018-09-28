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
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
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
