//
//  ViewController.swift
//  Recipes
//
//  Created by Serhii Shchoholiev on 12/6/22.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let categoriesService = CategoriesService()
    
    var categories = [Category]()
    
    var currentPage = 1
    
    var totalPages = 1
    
    var chosenCategory: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPage(pageNumber: currentPage)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
    }
    
    func addPage(pageNumber: Int) {
        Task {
            let categoriesPage =  await categoriesService.getPageAsync(pageNumber: pageNumber)
            if let safePage = categoriesPage {
                categories.append(contentsOf: safePage.items)
                totalPages = safePage.pagesCount
                tableView.reloadData()
            }
        }
    }
    
    @objc func showRecipesByCategory(sender: UIView) {
        chosenCategory = categories.first(where: { $0.id == sender.tag } )
        self.performSegue(withIdentifier: "showRecipesByCategory", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRecipesByCategory":
            let view = segue.destination as! RecipesByCategoryViewController
            view.category = chosenCategory
        default:
            break
        }
    }
}

//MARK: - UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = categories[indexPath.row]
        cell.categoryWrapper.tag = category.id
        cell.categoryName.text = category.name
        cell.categoryWrapper.setOnClickListener(action: showRecipesByCategory)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = categories.count - 1
        if indexPath.row == lastItem {
            if currentPage < totalPages {
                currentPage += 1
                addPage(pageNumber: currentPage)
            }
        }
    }
}
