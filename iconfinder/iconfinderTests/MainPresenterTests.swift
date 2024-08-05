//
//  MainPresenterTests.swift
//  iconfinderTests
//
//  Created by Vermut xxx on 31.07.2024.
//

import XCTest
@testable import iconfinder

class MainPresenterTests: XCTestCase {
    
    var presenter: MainPresenter!
    var mockView: MockMainView!
    var mockIconSearchService: MockIconSearchService!
    var mockDataStoreService: MockDataStoreService!
    
    override func setUp() {
        super.setUp()
        mockView = MockMainView()
        mockIconSearchService = MockIconSearchService()
        presenter = MainPresenter(view: mockView, iconSearchService: mockIconSearchService)
        mockDataStoreService = MockDataStoreService()
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockIconSearchService = nil
        mockDataStoreService = nil
        super.tearDown()
    }
    
    func testSearchIconsSuccess() {
        let icon = IconModel(icon_id: 1, tags: ["test"], raster_sizes: [])
        mockIconSearchService.icons = [icon]
        
        presenter.searchIcons(with: "test")
        
        XCTAssertTrue(mockView.reloadDataCalled)
        XCTAssertEqual(presenter.getIconCount(), 1)
    }
    
    func testSearchIconsFailure() {
        mockIconSearchService.error = NSError(domain: "", code: 0, userInfo: nil)
        
        presenter.searchIcons(with: "test")
        
        XCTAssertFalse(mockView.reloadDataCalled)
        XCTAssertEqual(presenter.getIconCount(), 0)
    }
    
    func testSaveIcon() {
        let icon = IconModel(icon_id: 1, tags: ["test"], raster_sizes: [])
        mockDataStoreService.shouldReturnSuccess = true
        
        presenter.saveIcon(icon)
        
        XCTAssertTrue(mockView.updateCellButtonStateCalled, "Expected updateCellButtonState to be called.")
        XCTAssertEqual(mockView.isSaved, true, "Expected the icon to be saved.")
    }

}

class MockMainView: MainViewProtocol {
    var reloadDataCalled = false
    var updateCellButtonStateCalled = false
    var isSaved: Bool?
    
    func reloadData() {
        reloadDataCalled = true
    }
    
    func updateCellButtonState(for iconID: Int, isSaved: Bool) {
        updateCellButtonStateCalled = true
        self.isSaved = isSaved
    }
}


class MockIconSearchService: IconSearchServiceProtocol {
    var icons: [IconModel]?
    var error: Error?
    
    func searchIcons(query: String, completion: @escaping ([IconModel]?, Error?) -> Void) {
        completion(icons, error)
    }
}

class MockDataStoreService: DataStoreServiceProtocol {
    var savedIcons: [IconModel] = []
    var shouldReturnSuccess: Bool = false
    
    func saveData(icon: IconModel) -> Bool {
        savedIcons.append(icon)
        return true
    }
    
    func isSavedData(id: Int) -> Bool {
        return savedIcons.contains(where: { $0.icon_id == id })
    }
    
    func getDatas() -> [IconModel] {
        return savedIcons
    }
    
    func deleteData(id: Int) -> [IconModel] {
        savedIcons.removeAll(where: { $0.icon_id == id })
        return savedIcons
    }
}
