//
//  RecipeController.swift
//  Recipes
//
//  Created by Serhii Shchoholiev on 12/12/22.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var recipeName: UILabel!
    
    @IBOutlet weak var ingredients: UILabel!
    
    @IBOutlet weak var recipeText: UILabel!
    
    var recipe: Recipe?
    
    let helpersService = HelpersService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let safeRecipe = recipe {
            Task {
                let imageData = await helpersService.downloadImage(from: safeRecipe.thumbnail)
                if let safeData = imageData {
                    thumbnail.image = UIImage(data: safeData)
                }
            }
            categoryName.text = safeRecipe.category.name
            recipeName.text = safeRecipe.name
            ingredients.text = safeRecipe.ingredients
            recipeText.text = safeRecipe.text
        }
    }
}
