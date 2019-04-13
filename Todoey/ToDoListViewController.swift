//
//  ViewController.swift
//  Todoey
//
//  Created by BIREN on 03/04/19.
//  Copyright © 2019 cdot. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var array = ["one","two","three","four"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "ToDoeyArrayList") as? [String] {
            array = items
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    //TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(array[indexPath.row])
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            self.array.append(textFeild.text!)
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

