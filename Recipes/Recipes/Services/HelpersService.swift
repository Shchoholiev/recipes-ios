//
//  HelpersService.swift
//  Recipes
//
//  Created by Serhii Shchoholiev on 12/11/22.
//

import Foundation

class HelpersService {
    
    func downloadImage(from link: String) async -> Data? {
        let url = URL(string: link)
        if let safeUrl = url {
            do {
                let (data, _) = try await URLSession.shared.data(from: safeUrl)
                return data
            } catch {
                print(error)
            }
        }
        
        return nil
    }
}
