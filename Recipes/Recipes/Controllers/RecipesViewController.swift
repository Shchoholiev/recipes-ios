//
//  RecipesViewController.swift
//  Recipes
//
//  Created by Serhii Shchoholiev on 12/11/22.
//

import UIKit

class RecipesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchField: UITextField!
    
    let recipesService = RecipesService()
    
    let helpersService = HelpersService()
    
    var recipes = [Recipe]()
    
    var currentPage = 1
    
    var totalPages = 1
    
    var chosenRecipe: Recipe?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPage(pageNumber: currentPage)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        searchField.delegate = self
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
            let recipesPage =  await recipesService.getPageAsync(pageNumber: pageNumber)
            if let safePage = recipesPage {
                recipes.append(contentsOf: safePage.items)
                tableView.reloadData()
            }
        }
    }

    func search(pageNumber: Int, filter: String) {
        Task {
            let recipesPage =  await recipesService.getPageAsync(pageNumber: pageNumber, filter: filter)
            if let safePage = recipesPage {
                recipes = safePage.items
                totalPages = safePage.pagesCount
                tableView.reloadData()
            }
        }
    }
    
    func addSearchPage(pageNumber: Int, filter: String) {
        Task {
            let recipesPage =  await recipesService.getPageAsync(pageNumber: pageNumber, filter: filter)
            if let safePage = recipesPage {
                recipes.append(contentsOf: safePage.items)
                tableView.reloadData()
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
extension RecipesViewController: UITableViewDataSource {
    
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

//MARK: - UITextFieldDelegate
extension RecipesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let filter = searchField.text {
            currentPage = 1
            if filter.isEmpty {
                setPage(pageNumber: currentPage)
            } else {
                search(pageNumber: currentPage, filter: filter)
            }
        }
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let search = textField.text, !search.isEmpty {
            return true
        } else {
            return false
        }
    }
}

//MARK: - UITableViewDelegate
extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = recipes.count - 1
        if indexPath.row == lastItem {
            if currentPage < totalPages {
                currentPage += 1
                if let filter = searchField.text {
                    if filter.isEmpty {
                        addPage(pageNumber: currentPage)
                    } else {
                        addSearchPage(pageNumber: currentPage, filter: filter)
                    }
                }
            }
        }
    }
}
