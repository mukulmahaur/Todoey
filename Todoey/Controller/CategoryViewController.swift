//
//  CategoryViewController.swift
//  Todoey
//
//  Created by BIREN on 14/04/19.
//  Copyright © 2019 cdot. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
//    TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
//    TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPressed = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPressed.row]
        }
    }
    
//    TableView Manipulation
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categories = try context.fetch(request)
        }catch{
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textFeild.text!
            self.categories.append(newCategory)
            self.saveCategories()
        }
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Create Category"
            textFeild = alertTextFeild
        }
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
}
