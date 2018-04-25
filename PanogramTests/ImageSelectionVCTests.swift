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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        selectionVC = storyboard.instantiateViewController(withIdentifier: "ImageSelectionVC") as! ImageSelectionVC
        
        let _ = selectionVC.view
    }
    
    func test_title_Panoramas() {
        
        XCTAssertEqual(selectionVC.title, "Panoramas")
    }
    
    func test_next_button_exists() {
        let nextButton = selectionVC.navigationItem.rightBarButtonItem
        
        XCTAssertEqual(nextButton!.title!, "Next")
    }
}
