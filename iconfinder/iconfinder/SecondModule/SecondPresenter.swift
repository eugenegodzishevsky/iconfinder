//
//  SecondPresenter.swift
//  iconfinder
//
//  Created by Vermut xxx on 05.08.2024.
//

import UIKit

// MARK: - View Protocol
protocol SecondViewProtocol: AnyObject {
    func reloadData()

}

// MARK: - Presenter Protocol
protocol SecondPresenterProtocol {
    init(view: SecondViewProtocol, dataStoreService: DataStoreServiceProtocol)

    func loadData()
    func deleteIcon(with id: Int)
    func numberOfItems() -> Int
    func itemFor(index: Int) -> IconModel?
    func isIconSaved(id: Int) -> Bool
}

final class SecondPresenter: SecondPresenterProtocol {
    
    weak var view: SecondViewProtocol?
    private let dataStoreService: DataStoreServiceProtocol
    private var icons: [IconModel] = []
    private var savedIconIDs: Set<Int> = []
    
    init(view: SecondViewProtocol, dataStoreService: DataStoreServiceProtocol) {
        self.view = view
        self.dataStoreService = dataStoreService
    }
    
    func loadData() {
        icons = dataStoreService.getDatas()
        view?.reloadData()
    }
    
    func deleteIcon(with id: Int) {
        icons = dataStoreService.deleteData(id: id)
        view?.reloadData()
    }
    
    func isIconSaved(id: Int) -> Bool {
            return savedIconIDs.contains(id)
        }
    
    func numberOfItems() -> Int {
        return icons.count
    }
    
    func itemFor(index: Int) -> IconModel? {
        guard index >= 0 && index < icons.count else { return nil }
        return icons[index]
    }
}
