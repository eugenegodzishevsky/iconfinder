//
//  MainPresenter.swift
//  iconfinder
//
//  Created by Vermut xxx on 02.08.2024.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func reloadData()
    func updateCellButtonState(for iconID: Int, isSaved: Bool)
}

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, iconSearchService: IconSearchServiceProtocol)
    
    func searchIcons(with text: String)
    func saveIcon(_ icon: IconModel)
    func checkIfIconIsSaved(_ iconID: Int) -> Bool
    func getIconCount() -> Int
    func getIcon(at index: Int) -> IconModel?
}

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    private let iconSearchService: IconSearchServiceProtocol!
    private var icons: [IconModel] = []
    
    required init(view: MainViewProtocol, iconSearchService: IconSearchServiceProtocol) {
        self.view = view
        self.iconSearchService = iconSearchService
    }
    
    func searchIcons(with text: String) {
        iconSearchService.searchIcons(query: text) { [weak self] icons, error in
            if let error = error {
                print("Error fetching icons: \(error)")
                return
            }
            self?.icons = icons ?? []
            self?.view?.reloadData()
        }
    }
    
    func saveIcon(_ icon: IconModel) {
        let isSaved = DataStoreService.dataStoreService.saveData(icon: icon)
        view?.updateCellButtonState(for: icon.icon_id, isSaved: isSaved)
    }
    
    func checkIfIconIsSaved(_ iconID: Int) -> Bool {
        return DataStoreService.dataStoreService.isSavedData(id: iconID)
    }
    
    func getIconCount() -> Int {
        return icons.count
    }
    
    func getIcon(at index: Int) -> IconModel? {
        guard index < icons.count else { return nil }
        return icons[index]
    }
}
