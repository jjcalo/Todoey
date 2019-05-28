//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jack Calo on 5/27/19.
//  Copyright © 2019 Jack Calo. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let tableViewCell = "CategoryCell"
    var categoryArray = [Category]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCell, for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(String(tableView.cellForRow(at: indexPath)?.textLabel?.text ?? ""))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Tableview Delegate Methods
    
    
    //MARK - Add New Categories
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var newCategoryTextfield = UITextField()

        // Alert message to capture new Category Name.
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "New Category", style: .default) { (action) in

            // Create new Category record with new Category name
            let newCategory = Category(context: self.context)
            newCategory.name = newCategoryTextfield.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()

        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter category name"
            newCategoryTextfield = textfield
        }

        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    
    
    //MARK - Data Manipulation Methods
    
    func loadCategories (with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print ("Error fetching Item data: \(error)")
        }
        tableView.reloadData()
    }

    func saveCategories () {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
}
