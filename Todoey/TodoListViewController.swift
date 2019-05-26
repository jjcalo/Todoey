//
//  ViewController.swift
//  Todoey
//
//  Created by Jack Calo on 5/25/19.
//  Copyright © 2019 Jack Calo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let defaults = UserDefaults.standard
    var itemArray = ["Learn Swift", "Port SOTO", "Add Value-Added Features", "Incorporate Subscription Model", "Make Thousands"]
    var todoItemArray = [TodoListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Load array from UserDefaults
        if let items = defaults.array(forKey: "ToDoListArray") as? [TodoListModel] {
            todoItemArray = items
        } else {
            todoItemArray.append(TodoListModel(itemTitle: "First todo", isDone: true))
            todoItemArray.append(TodoListModel(itemTitle: "First todo", isDone: true))
            todoItemArray.append(TodoListModel(itemTitle: "First todo", isDone: true))
        }
        
        
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
        tableView.reloadData()
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
            self.defaults.set(self.todoItemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItemTextfield = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true)
    }
    

}

