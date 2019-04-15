//
//  ViewController.swift
//  Todoey
//
//  Created by BIREN on 03/04/19.
//  Copyright © 2019 cdot. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{

    var array = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
//    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(datafilepath)
//        loadItems()
     }

    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        do{
            array = try context.fetch(request)
        }catch{
            print("Error while fetching data \(error)")
        }
        tableView.reloadData()
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
        do{
            try context.save()
        }catch{
            print("\(error)")
        }
        self.tableView.reloadData()

    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in

            let newItem = Item(context: self.context)
            newItem.title = textFeild.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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

extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with : request,predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
        }
    }
}
