//
//  ViewController.swift
//  Todoey
//
//  Created by Jack Calo on 5/25/19.
//  Copyright © 2019 Jack Calo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Learn Swift", "Port SOTO", "Add Value-Added Features", "Incorporate Subscription Model", "Make Thousands"]
    var todoItemArray = [TodoListModel]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        print(dataFilePath!)
        
        loadItems()
        
        //Load array from Items.plist
//        if let items = defaults.array(forKey: "ToDoListArray") as? [TodoListModel] {
//            todoItemArray = items
//        } else {
//            todoItemArray.append(TodoListModel(itemTitle: "First todo", isDone: true))
//            todoItemArray.append(TodoListModel(itemTitle: "First todo", isDone: true))
//            todoItemArray.append(TodoListModel(itemTitle: "First todo", isDone: true))
//        }
        
        
    }

    //MARK - Table View Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let todoItem = todoItemArray[indexPath.row]
        cell.textLabel?.text = todoItem.ItemTitle
        cell.accessoryType = todoItem.IsDone ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(String(tableView.cellForRow(at: indexPath)?.textLabel?.text ?? ""))
        tableView.deselectRow(at: indexPath, animated: true)
        todoItemArray[indexPath.row].IsDone = !todoItemArray[indexPath.row].IsDone
        saveItems()
    }
    
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItemTextfield = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "Add a task", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when we click the Add Item buttom
            print("Successfully added \(newItemTextfield.text!)")
            let newTodoItem = TodoListModel(itemTitle: newItemTextfield.text!)
            
            self.todoItemArray.append(newTodoItem)
            self.saveItems()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItemTextfield = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    //MARK - Model Manipulation Methods
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(todoItemArray)
            try data.write(to: dataFilePath!)
            tableView.reloadData()
        } catch {
            print("Error encoding todoItemArray, \(error)")
        }
    }
    
    func loadItems() {
        do {
            let data = try Data.init(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            todoItemArray = try decoder.decode([TodoListModel].self, from: data)
        } catch {
            print("Error loading data from Items.plist, \(error)")
        }
    }

}

