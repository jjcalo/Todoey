//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jack Calo on 5/27/19.
//  Copyright © 2019 Jack Calo. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    let TABLE_VIEW_CELL = "CategoryCell"
    let SEGUE_TO_ITEMS = "goToItems"
    var categories : Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80.0

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    //MARK - Tableview Datasource Methods
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL, for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(String(tableView.cellForRow(at: indexPath)?.textLabel?.text ?? ""))
        performSegue(withIdentifier: SEGUE_TO_ITEMS, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK - Tableview Delegate Methods
    
    
    //MARK - Add New Categories
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var newCategoryTextfield = UITextField()

        // Alert message to capture new Category Name.
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "New Category", style: .default) { (action) in

            // Create new Category record with new Category name
            let newCategory = Category()
            newCategory.name = newCategoryTextfield.text!
            self.save(category: newCategory)
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter category name"
            newCategoryTextfield = textfield
        }

        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    
    
    //MARK - Data Manipulation Methods
    
    func loadCategories () {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    func save (category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        tableView.reloadData()
    }
}

//MARK - Swipe Cell Delegate Methods
extension CategoryViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let categoryToDelete = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryToDelete)
                    }
                } catch {
                    print ("Error deleting category: \(error)")
                }
                //tableView.reloadData()
            }

        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
