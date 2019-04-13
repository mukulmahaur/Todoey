//
//  ViewController.swift
//  Todoey
//
//  Created by BIREN on 03/04/19.
//  Copyright © 2019 cdot. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var array = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var newItem = Item()
        newItem.title = "one"
        array.append(newItem)

        var newItem2 = Item()
        newItem2.title = "two"
        array.append(newItem2)

        var newItem3 = Item()
        newItem3.title = "three"
        array.append(newItem3)

        if let items = defaults.array(forKey: "ToDoeyArrayList") as? [Item] {
            array = items
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        print("cellforrowatindex")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for: indexPath)
        cell.textLabel?.text = array[indexPath.row].title
        
        cell.accessoryType = array[indexPath.row].done ?.checkmark : .none
        return cell
    }
    
    //TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(array[indexPath.row])
        array[indexPath.row].done = !array[indexPath.row].done

        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            let newItem = Item()
            newItem.title = textFeild.text!
            self.array.append(newItem)
            self.defaults.set(self.array, forKey: "ToDoeyArrayList")
            self.tableView.reloadData()
//            print(textFeild.text)
        }
        alert.addTextField { (alertTextfeild) in
            alertTextfeild.placeholder = "Create new Todoey"
            textFeild = alertTextfeild
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

