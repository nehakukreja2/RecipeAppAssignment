//
//  RecipeViewModel.swift
//  RecipiesAppAssignment
//
//  Created by Neha Kukreja on 05/10/24.
//

import Foundation

protocol RecipiesProtocol: AnyObject {
    func updateTableData()
    func displayError(_ error: Error)
}

class RecipeViewModel {
    
    // MARK: - PROPERTIES
    weak var delegate: RecipiesProtocol?
    private let recipeService: RecipeService
    private let favoritesManager: FavoritesManager
    var recipes: [Recipes] = []
    var currentPage: Int = 1
    let limit: Int = 20
    var isLoading: Bool = false {
        didSet {
            delegate?.updateTableData()
        }
    }
    
    init(recipeService: RecipeService = RecipeAPIService(),
         favoritesManager: FavoritesManager = UserDefaultsFavoritesManager()) {
        self.recipeService = recipeService
        self.favoritesManager = favoritesManager
    }
    
    // MARK: - METHODS
    func hitAPIToGetRecipies() {
        guard !isLoading else { return }
        isLoading = true
        
        let skip = (currentPage - 1) * limit
        recipeService.fetchRecipes(limit: limit, skip: skip) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let fetchedRecipes):
                self.recipes.append(contentsOf: fetchedRecipes)
                self.currentPage += 1
                DispatchQueue.main.async {
                    self.loadFavorites()
                    self.delegate?.updateTableData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.displayError(error)
                }
            }
        }
    }
    
    func resetRecipes() {
        recipes.removeAll()
        currentPage = 1
        isLoading = false
    }
    
    func saveFavorites() {
        let favoriteIDs = recipes
            .filter { $0.isFavorited }
            .compactMap { $0.id }
        favoritesManager.saveFavoriteIDs(favoriteIDs)
    }
    
    func loadFavorites() {
        let favoriteIDs = favoritesManager.loadFavoriteIDs()
        for index in recipes.indices {
            if favoriteIDs.contains(recipes[index].id ?? 0) {
                recipes[index].isFavorited = true
            } else {
                recipes[index].isFavorited = false
            }
        }
    }
    
}
