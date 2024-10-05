//
//  RecipeService.swift
//  RecipieApp
//
//  Created by Neha Kukreja on 05/10/24.
//

import Foundation

protocol RecipeService {
    func fetchRecipes(limit: Int, skip: Int, completion: @escaping (Result<[Recipes], Error>) -> Void)
}

class RecipeAPIService: RecipeService {
    
    func fetchRecipes(limit: Int, skip: Int, completion: @escaping (Result<[Recipes], Error>) -> Void) {
        let urlString = "https://dummyjson.com/recipes?limit=\(limit)&skip=\(skip)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let jsonDecoder = JSONDecoder()
                let responseData = try jsonDecoder.decode(Json4Swift_Base.self, from: data)
                completion(.success(responseData.recipes ?? []))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
