//
//  FavoritesManager.swift
//  RecipieApp
//
//  Created by Neha Kukreja on 05/10/24.
//

import Foundation

protocol FavoritesManager {
    func saveFavoriteIDs(_ ids: [Int])
    func loadFavoriteIDs() -> [Int]
}

class UserDefaultsFavoritesManager: FavoritesManager {
    private let favoriteKey = "favoriteRecipes"
    
    func saveFavoriteIDs(_ ids: [Int]) {
        UserDefaults.standard.set(ids, forKey: favoriteKey)
        UserDefaults.standard.synchronize()
    }
    
    func loadFavoriteIDs() -> [Int] {
        return UserDefaults.standard.array(forKey: favoriteKey) as? [Int] ?? []
    }
}
