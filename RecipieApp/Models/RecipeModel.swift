//
//  RecipeModel.swift
//  RecipiesAppAssignment
//
//  Created by Neha Kukreja on 05/10/24.
//

import Foundation

enum MealType: String, Codable {
    case dinner = "Dinner"
    case lunch = "Lunch"
    case snack = "Snack"
    case snacks = "Snacks"
    case dessert = "Dessert"
    case sideDish = "Side Dish"
    case appetizer = "Appetizer"
    case breakfast = "Breakfast"
    case beverage = "Beverage"
}

struct Json4Swift_Base : Codable {
   let recipes : [Recipes]?
    let total : Int?
    let skip : Int?
    let limit : Int?

    enum CodingKeys: String, CodingKey {
        case recipes = "recipes"
        case total = "total"
        case skip = "skip"
        case limit = "limit"
    }
}

struct Recipes : Codable {
    let id : Int?
    let name : String?
    var isFavorited: Bool = false
    let ingredients : [String]?
    let instructions : [String]?
    let prepTimeMinutes : Int?
    let cookTimeMinutes : Int?
    let servings : Int?
    let difficulty : String?
    let cuisine : String?
    let caloriesPerServing : Int?
    let tags : [String]?
    let userId : Int?
    let image : String?
    let rating : Double?
    let reviewCount : Int?
    let mealType : [MealType]?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case ingredients = "ingredients"
        case instructions = "instructions"
        case prepTimeMinutes = "prepTimeMinutes"
        case cookTimeMinutes = "cookTimeMinutes"
        case servings = "servings"
        case difficulty = "difficulty"
        case cuisine = "cuisine"
        case caloriesPerServing = "caloriesPerServing"
        case tags = "tags"
        case userId = "userId"
        case image = "image"
        case rating = "rating"
        case reviewCount = "reviewCount"
        case mealType = "mealType"
    }
}
