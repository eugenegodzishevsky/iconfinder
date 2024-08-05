//
//  iconfinderUITests.swift
//  iconfinderUITests
//
//  Created by Vermut xxx on 31.07.2024.
//

import XCTest

final class IconFinderUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
    }

    func testTabBarItem() throws {
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssert(tabBar.buttons["Home"].exists)
        
        tabBar.tap()
    }
    
    func testTabBarItem2() throws {
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssert(tabBar.buttons["Favorites"].exists)
        
        tabBar.tap()
    }
}
