//
//  DetailViewController.swift
//  Midterm Project
//
//  Created by Aaron Sargento on 4/11/17.
//  Copyright © 2017 Aaron Sargento. All rights reserved.
//

// Input: The user can press the '+' to add item to list; user can swipe row to be able to delete item from list
// Output: User will get updated list based on input

import UIKit
import CoreData

class DetailViewController: UITableViewController {

    var listItems: [NSManagedObject] = []

    /*
        This function allows the user to add items to the to do list
    */
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Item", message: "What would you like to add?", preferredStyle: UIAlertControllerStyle.alert)
        let confirmAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) {
            [unowned self] action in
            
            guard let textField = alertController.textFields?.first,
                let itemToSave = textField.text else {
                    return
            }
            
            self.saveItem(itemToSave: itemToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        alertController.addTextField()
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
        This function saves the item in Core Data
    */
    func saveItem(itemToSave: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: (self.detailItem)!, in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        item.setValue(itemToSave, forKey: "item")
        do {
            try managedContext.save()
            listItems.append(item)
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    /*
        This function determines the amount of sections
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*
        This function determines the amount of rows in your list
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    /*
        This function sets the properties for the cell
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        
        let item = listItems[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "item") as? String
        cell.textLabel?.textColor = UIColor.white

        if detailItem == "Groceries" {
            cell.backgroundColor = UIColor(red: 125/255, green: 175/255, blue: 229/255, alpha: 1)
        } else if detailItem == "Work" {
            cell.backgroundColor = UIColor(red: 248/255, green: 112/255, blue: 115/255, alpha: 1)
        } else if detailItem == "Travel" {
            cell.backgroundColor = UIColor(red: 203/255, green: 151/255, blue: 135/255, alpha: 1)
        } else if detailItem == "Errands" {
            cell.backgroundColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        } else if detailItem == "Goals" {
            cell.backgroundColor = UIColor(red: 248/255, green: 182/255, blue: 86/255, alpha: 1)
        } else if detailItem == "Health" {
            cell.backgroundColor = UIColor(red: 171/255, green: 227/255, blue: 245/255, alpha: 1)
        } else if detailItem == "Personal" {
            cell.backgroundColor = UIColor(red: 236/255, green: 160/255, blue: 189/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 120/255, green: 234/255, blue: 111/255, alpha: 1)
        }
        
        return cell
    }
    
    /*
        This function allows the user to delete an item from the list
    */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            do {
                managedContext.delete(listItems[indexPath.row])
                try managedContext.save()
                listItems.remove(at: indexPath.row)
                tableView.reloadData() //refresh tableView
            } catch let error as NSError{
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
    }
    
    
    /*
        This function animates cell selection
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //update the view of the Core Data items in table view
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: (self.detailItem)!)
        do {
            listItems = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if detailItem == "Groceries" {
            tableView.backgroundColor = UIColor(red: 125/255, green: 175/255, blue: 229/255, alpha: 1)
        } else if detailItem == "Work" {
            tableView.backgroundColor = UIColor(red: 248/255, green: 112/255, blue: 115/255, alpha: 1)
        } else if detailItem == "Travel" {
            tableView.backgroundColor = UIColor(red: 203/255, green: 151/255, blue: 135/255, alpha: 1)
        } else if detailItem == "Errands" {
            tableView.backgroundColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        } else if detailItem == "Goals" {
            tableView.backgroundColor = UIColor(red: 248/255, green: 182/255, blue: 86/255, alpha: 1)
        } else if detailItem == "Health" {
            tableView.backgroundColor = UIColor(red: 171/255, green: 227/255, blue: 245/255, alpha: 1)
        } else if detailItem == "Personal" {
            tableView.backgroundColor = UIColor(red: 236/255, green: 160/255, blue: 189/255, alpha: 1)
        } else {
            tableView.backgroundColor = UIColor(red: 120/255, green: 234/255, blue: 111/255, alpha: 1)
        }
        
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: String = self.detailItem {
            self.title = detail
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        //customize the navigation bar
        if detailItem == "Groceries" {
            navigationController?.navigationBar.tintColor = UIColor(red: 125/255, green: 175/255, blue: 229/255, alpha: 1)
        } else if detailItem == "Work" {
            navigationController?.navigationBar.tintColor = UIColor(red: 248/255, green: 112/255, blue: 115/255, alpha: 1)
        } else if detailItem == "Travel" {
            navigationController?.navigationBar.tintColor = UIColor(red: 203/255, green: 151/255, blue: 135/255, alpha: 1)
        } else if detailItem == "Errands" {
            navigationController?.navigationBar.tintColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        } else if detailItem == "Goals" {
            navigationController?.navigationBar.tintColor = UIColor(red: 248/255, green: 182/255, blue: 86/255, alpha: 1)
        } else if detailItem == "Health" {
            navigationController?.navigationBar.tintColor = UIColor(red: 171/255, green: 227/255, blue: 245/255, alpha: 1)
        } else if detailItem == "Personal" {
            navigationController?.navigationBar.tintColor = UIColor(red: 236/255, green: 160/255, blue: 189/255, alpha: 1)
        } else {
            navigationController?.navigationBar.tintColor = UIColor(red: 120/255, green: 234/255, blue: 111/255, alpha: 1)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: String? {
        didSet {
            // Update the view.
        }
    }
    
}

