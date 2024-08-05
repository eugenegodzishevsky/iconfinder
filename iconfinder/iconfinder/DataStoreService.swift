//
//  DataStoreService.swift
//  iconfinder
//
//  Created by Vermut xxx on 05.08.2024.
//

import Foundation

protocol DataStoreServiceProtocol {
    func saveData(icon: IconModel) -> Bool
    func isSavedData(id: Int) -> Bool
    func getDatas() -> [IconModel]
    func deleteData(id: Int) -> [IconModel]
}

final class DataStoreService: DataStoreServiceProtocol {
    
    static var dataStoreService: DataStoreServiceProtocol = DataStoreService()
    
    private let defaults = UserDefaults.standard
    private var keys: [Int] = []
    private let countFavorite: Int = 6
    
    func saveData(icon: IconModel) -> Bool {
            if isSavedData(id: icon.icon_id) {
                deleteData(id: icon.icon_id)
                return false
            } else {
                let encoder = JSONEncoder()
                guard let encoded = try? encoder.encode(icon) else { return false }
                defaults.set(encoded, forKey: String(icon.icon_id))
                saveKeys(id: icon.icon_id)
                saveTags(id: icon.icon_id, tags: icon.tags)
                limitFavorites()
                return true
            }
        }
    
    func isSavedData(id: Int) -> Bool {
        return defaults.object(forKey: String(id)) != nil
    }
    
    func getDatas() -> [IconModel] {
        var result: [IconModel] = []
        keys = getKeys()
        keys.forEach { key in
            guard let icon = getData(id: key) else { return }
            result.append(icon)
        }
        return result
    }
    
    func deleteData(id: Int) -> [IconModel] {
        var result: [IconModel] = []
        deleteKey(id: id)
        deleteTags(id: id)
        deleteDataID(id: id)
        keys = getKeys()
        keys.forEach { key in
            guard let icon = getData(id: key) else { return }
            result.append(icon)
        }
        return result
    }
    
    private func limitFavorites() {
        keys = getKeys()
        if countFavorite <= keys.count {
            if let id = keys.first {
                deleteDataID(id: id)
                deleteKey(id: id)
                deleteTags(id: id)
            }
        }
    }
    
    private func deleteDataID(id: Int) {
        if isSavedData(id: id) {
            defaults.removeObject(forKey: String(id))
        }
    }
    
    private func getData(id: Int) -> IconModel? {
        if let object = defaults.object(forKey: String(id)) as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode(IconModel.self, from: object)
        }
        return nil
    }
    
    private func getTags(id: Int) -> [String] {
        let idString = String(id) + "tags"
        if let object = defaults.object(forKey: idString) as? Data {
            let decoder = JSONDecoder()
            return (try? decoder.decode([String].self, from: object)) ?? []
        }
        return []
    }
    
    private func saveKeys(id: Int) {
        keys = getKeys()
        keys.append(id)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(keys) {
            defaults.set(encoded, forKey: "keys")
        }
    }
    
    private func deleteKey(id: Int) {
        keys = getKeys()
        keys = keys.filter { $0 != id }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(keys) {
            defaults.set(encoded, forKey: "keys")
        }
    }
    
    private func getKeys() -> [Int] {
        if let object = defaults.object(forKey: "keys") as? Data {
            let decoder = JSONDecoder()
            return (try? decoder.decode([Int].self, from: object)) ?? []
        }
        return []
    }
    
    private func saveTags(id: Int, tags: [String]) {
        let idString = String(id) + "tags"
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tags) {
            defaults.set(encoded, forKey: idString)
        }
    }
    
    private func deleteTags(id: Int) {
        let idString = String(id) + "tags"
        if defaults.object(forKey: idString) != nil {
            defaults.removeObject(forKey: idString)
        }
    }
}
