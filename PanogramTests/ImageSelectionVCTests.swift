//
//  ImageSelectionVCTests.swift
//  PanogramTests
//
//  Created by TeraMo Labs on 4/24/18.
//  Copyright © 2018 Tera Mo Labs. All rights reserved.
//

import XCTest
@testable import Panogram___Panoramas_for_Instagram

class ImageSelectionVCTests: XCTestCase {

  var selectionVC: ImageSelectionVC!

  override func setUp() {
    super.setUp()

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let selectionVC =
      storyboard.instantiateViewController(withIdentifier: "ImageSelectionVC")
        as? ImageSelectionVC else {
          fatalError()
    }

    _ = selectionVC.view
    selectionVC.viewDidAppear(false)
  }

  func test_title_Panoramas() {

    XCTAssertEqual(selectionVC.title, "Panoramas")
  }

  func test_next_button_exists() {
    let nextButton = selectionVC.navigationItem.rightBarButtonItem

    XCTAssertEqual(nextButton!.title!, "Next")
  }

  func test_next_button_disabled() {
    let nextButton = selectionVC.navigationItem.rightBarButtonItem
    XCTAssert(nextButton?.isEnabled == false)
  }

  func test_left_image_view_exists() {
    let leftImageView = selectionVC.leftImageView
    XCTAssertNotNil(leftImageView)
  }

  func test_center_image_view_exists() {
    let centerImageView = selectionVC.centerImageView
    XCTAssertNotNil(centerImageView)
  }

  func test_right_image_view_exists() {
    let rightImageView = selectionVC.rightImageView
    XCTAssertNotNil(rightImageView)
  }

  func test_table_view_exists() {
    let tableView = selectionVC.tableView
    XCTAssertNotNil(tableView)
  }

  func test_table_view_separator_is_clear() {
    let tableView = selectionVC.tableView

    XCTAssert(tableView?.separatorColor == UIColor.clear)
  }

  func test_table_view_has_data_source() {
    let tableView = selectionVC.tableView
    let dataSource = tableView?.dataSource
    XCTAssertNotNil(dataSource)
    XCTAssert(dataSource is TableViewDataSource)
  }

  func test_table_view_has_delegate() {
    let tableView = selectionVC.tableView
    let delegate = tableView?.delegate
    XCTAssertNotNil(delegate)
    XCTAssert(delegate is TableViewDelegate)
  }
}
