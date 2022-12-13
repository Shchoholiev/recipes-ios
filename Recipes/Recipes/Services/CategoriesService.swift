//
//  CategoriesService.swift
//  Recipes
//
//  Created by Serhii Shchoholiev on 12/6/22.
//

import Foundation

class CategoriesService: ServiceBase {
    
    init() {
        super.init(url: "/categories")
    }
    
    func getPageAsync(pageNumber: Int) async -> PaginationWrapper<Category>? {
        let url = URL(string: "\(baseUrl)/page/\(pageNumber)")
        if let safeUrl = url {
            do {
                let (data, _) = try await URLSession.shared.data(from: safeUrl)
                let categories = try JSONDecoder().decode(PaginationWrapper<Category>.self, from: data)
                return categories
            } catch {
                print(error)
            }
        }
        
        return nil
    }
}
