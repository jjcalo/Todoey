//
//  ViewController.swift
//  Todoey
//
//  Created by Jack Calo on 5/25/19.
//  Copyright © 2019 Jack Calo. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var items : Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    let realm = try! Realm()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        // Do any additional setup after loading the view.
        searchBar.delegate = self as UISearchBarDelegate
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let categoryColor = selectedCategory?.backgroundColor {
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
            navBar.barTintColor = UIColor(hexString: categoryColor)
            searchBar.barTintColor = UIColor(hexString: categoryColor)
        }
    }

    //MARK - Table View Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print ("Error writing to Realm: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItemTextfield = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "Add a task", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when we click the Add Item buttom
            print("Successfully added \(newItemTextfield.text!)")

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = newItemTextfield.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print ("Error saving Item: \(error)")
                }
            }
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItemTextfield = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        // Super calls this method when swiping to delete
        if let itemToDelete = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print ("Error deleting item: \(error)")
            }
        }
    }

    
}


//MARK - Search bar Methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count == 0) {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
