//
//  RecipesService.swift
//  Recipes
//
//  Created by Serhii Shchoholiev on 12/6/22.
//

import Foundation

class RecipesService: ServiceBase {
    
    init() {
        super.init(url: "/recipes")
    }
    
    func getPageAsync(pageNumber: Int) async -> PaginationWrapper<Recipe>? {
        let url = URL(string: "\(baseUrl)/page/\(pageNumber)")
        if let safeUrl = url {
            do {
                let (data, _) = try await URLSession.shared.data(from: safeUrl)
                let recipes = try JSONDecoder().decode(PaginationWrapper<Recipe>.self, from: data)
                return recipes
            } catch {
                print(error)
            }
        }
        
        return nil
    }
    
    func getPageAsync(pageNumber: Int, filter: String) async -> PaginationWrapper<Recipe>? {
        let url = URL(string: "\(baseUrl)/page/\(pageNumber)/\(filter)")
        if let safeUrl = url {
            do {
                let (data, _) = try await URLSession.shared.data(from: safeUrl)
                let recipes = try JSONDecoder().decode(PaginationWrapper<Recipe>.self, from: data)
                return recipes
            } catch {
                print(error)
            }
        }
        
        return nil
    }
    
    func getPageAsync(pageNumber: Int, categoryId: Int) async -> PaginationWrapper<Recipe>? {
        let url = URL(string: "\(baseUrl)/page-by-category-id/\(pageNumber)/\(categoryId)")
        if let safeUrl = url {
            do {
                let (data, _) = try await URLSession.shared.data(from: safeUrl)
                let recipes = try JSONDecoder().decode(PaginationWrapper<Recipe>.self, from: data)
                return recipes
            } catch {
                print(error)
            }
        }
        
        return nil
    }
    
    func getRecipeAsync(id: Int) async -> Recipe? {
        let url = URL(string: "\(baseUrl)/\(id)")
        if let safeUrl = url {
            do {
                let (data, _) = try await URLSession.shared.data(from: safeUrl)
                let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                return recipe
            } catch {
                print(error)
            }
        }
        
        return nil
    }
}
