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
    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
     }

    func loadItems(){
        if let data = try? Data(contentsOf: datafilepath!){
            let decoder = PropertyListDecoder()
            do{
                array = try decoder.decode([Item].self, from: data)
            }catch{
                print("\(error)")
            }
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
        
        saveData()

        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    func saveData(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(array)
            try data.write(to: datafilepath!)
        }catch{
            print("\(error)")
        }
        
        //            self.defaults.set(self.array, forKey: "ToDoeyArrayList")
        self.tableView.reloadData()

    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            let newItem = Item()
            newItem.title = textFeild.text!
            self.array.append(newItem)
            self.saveData()
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

