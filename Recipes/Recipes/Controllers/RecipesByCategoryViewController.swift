//
//  RecipesByCategoryViewController.swift
//  Recipes
//
//  Created by Serhii Shchoholiev on 12/12/22.
//

import UIKit

class RecipesByCategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category?
    
    let recipesService = RecipesService()
    
    let helpersService = HelpersService()
    
    var recipes = [Recipe]()
    
    var currentPage = 1
    
    var totalPages = 1
    
    var chosenRecipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let safeCategory = category {
            categoryName.text = safeCategory.name
            setPage(pageNumber: currentPage)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        }
    }
    
    func setPage(pageNumber: Int) {
        Task {
            let recipesPage =  await recipesService.getPageAsync(pageNumber: pageNumber)
            if let safePage = recipesPage {
                recipes = safePage.items
                totalPages = safePage.pagesCount
                tableView.reloadData()
            }
        }
    }
    
    func addPage(pageNumber: Int) {
        Task {
            if let safeCategory = category {
                let recipesPage =  await recipesService.getPageAsync(pageNumber: pageNumber, categoryId: safeCategory.id)
                if let safePage = recipesPage {
                    recipes.append(contentsOf: safePage.items)
                    tableView.reloadData()
                }
            }
        }
    }

    
    @objc func showRecipe(sender: UIView) {
        Task {
            chosenRecipe = await recipesService.getRecipeAsync(id: sender.tag)
            self.performSegue(withIdentifier: "showRecipe", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRecipe":
            let view = segue.destination as! RecipeViewController
            view.recipe = chosenRecipe
        default:
            break
        }
    }
}

//MARK: - UITableViewDataSource
extension RecipesByCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        cell.recipeName.text = recipe.name
        cell.recipeCategory.text = recipe.category.name
        cell.recipeWrapper.tag = recipe.id
        cell.recipeWrapper.setOnClickListener(action: showRecipe)
        Task {
            let imageData = await helpersService.downloadImage(from: recipe.thumbnail)
            if let safeData = imageData {
                cell.thumbnail.image = UIImage(data: safeData)
            }
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension RecipesByCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = recipes.count - 1
        if indexPath.row == lastItem {
            if currentPage < totalPages {
                currentPage += 1
                addPage(pageNumber: currentPage)
            }
        }
    }
}
