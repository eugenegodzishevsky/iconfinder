//
//  SecondPresenterTests.swift
//  iconfinderTests
//
//  Created by Vermut xxx on 05.08.2024.
//

import XCTest
@testable import iconfinder

class SecondPresenterTests: XCTestCase {
    
    var presenter: SecondPresenter!
    var mockView: MockSecondView!
    var mockDataStoreService: MockDataStoreService!
    
    override func setUp() {
        super.setUp()
        mockView = MockSecondView()
        mockDataStoreService = MockDataStoreService()
        presenter = SecondPresenter(view: mockView, dataStoreService: mockDataStoreService)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockDataStoreService = nil
        super.tearDown()
    }
    
    func testLoadData() {
        let icon = IconModel(icon_id: 1, tags: ["test"], raster_sizes: [])
        mockDataStoreService.savedIcons = [icon]
        
        presenter.loadData()
        
        XCTAssertTrue(mockView.reloadDataCalled)
        XCTAssertEqual(presenter.numberOfItems(), 1)
    }
    
    func testDeleteIcon() {
        let icon = IconModel(icon_id: 1, tags: ["test"], raster_sizes: [])
        mockDataStoreService.savedIcons = [icon]
        
        presenter.deleteIcon(with: 1)
        
        XCTAssertTrue(mockView.reloadDataCalled)
        XCTAssertEqual(presenter.numberOfItems(), 0)
    }
}

class MockSecondView: SecondViewProtocol {
    var reloadDataCalled = false
    
    func reloadData() {
        reloadDataCalled = true
    }
}

