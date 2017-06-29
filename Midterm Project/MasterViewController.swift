//
//  MasterViewController.swift
//  Midterm Project
//
//  Created by Aaron Sargento on 4/11/17.
//  Copyright © 2017 Aaron Sargento. All rights reserved.
//

// Input: The user can select row to go to corresponding list
// Output: The user will be taken to view controller with corresponding list

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext = [NSManagedObjectContext]()
    
    var listItems: [NSManagedObject] = []
    
    var categories = ["Groceries",
                      "Work",
                      "Travel",
                      "Errands",
                      "Goals",
                      "Health",
                      "Personal",
                      "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
        self.title = "To-Do List"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
            let object = categories[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    /*
        This function determines the amount of sections of table
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /*
        This function determines the amount of rows of table
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    /*
        This function sets the properties for each cell
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = categories[indexPath.row]
        
        //grab the data to list the item count for each entity
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return cell
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: (categories[indexPath.row]))
        do {
            listItems = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if listItems.count == 1 {
            cell.detailTextLabel?.text = "\(listItems.count) item"
        } else {
            cell.detailTextLabel?.text = "\(listItems.count) items"
        }
        
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        cell.tintColor = UIColor.white
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(red: 125/255, green: 175/255, blue: 229/255, alpha: 1)
        } else if indexPath.row == 1 {
            cell.backgroundColor = UIColor(red: 248/255, green: 112/255, blue: 115/255, alpha: 1)
        } else if indexPath.row == 2 {
            cell.backgroundColor = UIColor(red: 203/255, green: 151/255, blue: 135/255, alpha: 1)
        } else if indexPath.row == 3 {
            cell.backgroundColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        } else if indexPath.row == 4 {
            cell.backgroundColor = UIColor(red: 248/255, green: 182/255, blue: 86/255, alpha: 1)
        } else if indexPath.row == 5 {
            cell.backgroundColor = UIColor(red: 171/255, green: 227/255, blue: 245/255, alpha: 1)
        } else if indexPath.row == 6 {
            cell.backgroundColor = UIColor(red: 236/255, green: 160/255, blue: 189/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 120/255, green: 234/255, blue: 111/255, alpha: 1)
        }
        
        if listItems.count == 1 {
            cell.detailTextLabel?.text = "\(listItems.count) item"
        } else {
            cell.detailTextLabel?.text = "\(listItems.count) items"
        }
        
        return cell
    }
    
    /*
        Allow the list count to be updated when user changes the count in the detail view controller
    */
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

