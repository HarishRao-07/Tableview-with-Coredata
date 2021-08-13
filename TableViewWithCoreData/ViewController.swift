//
//  ViewController.swift
//  TableViewWithCoreData
//
//  Created by rd on 23/07/21.
//  Copyright © 2021 vishnu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items : [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchpeople()
        
    }
    
    func fetchpeople(){
        
        //fetch the data from the coredata to display in the tableview
        do  {
               items =  try context.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
               self.tableView.reloadData()
            
            }
        }
        catch{
            
            }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return items?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //get the person from array and set the label
        let person = items![indexPath.row]
        
        cell.textLabel?.text = person.name
        return cell
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //selected Person
        let selectedPerson = self.items![indexPath.row]
        
        //create alert
        let alert = UIAlertController(title: "Edit Person", message: "Edit Name", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = selectedPerson.name
        
        //configure button handler
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            //get the textfield for the alert
            let textField = alert.textFields![0]
            
            //edit name property of person object
            selectedPerson.name = textField.text
            
                //save the data
                
                do{
                    try self.context.save()
                }
                catch{
                    
                }
                
                //re-fetch the dat
                self.fetchpeople()
            
      
        }
        
        //add button
        alert.addAction(saveButton)
        
        //show alert
       self.present(alert, animated: true, completion: nil)
    }

    
    
    
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        //Create aler
        let alert = UIAlertController(title: "add Person", message: "What is their name?", preferredStyle: .alert )
        alert.addTextField()
     
            //Configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            

            
            
            //get the textfield for the alert
            let textField = alert.textFields![0]
            
            //create a person object
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = "Male"
            

                //save the data
                do{
                    try self.context.save()
                }
                catch{
                    
                }
                
                //re-fetch the data
                self.fetchpeople()

        
            }
    
        //add Button
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            //which person to remove
            let personToRemove = self.items![indexPath.row]
            
            //remove the person
            self.context.delete(personToRemove)
            
            //save the data
            do{
                try self.context.save()
            }catch{
                
            }
            
            //re-fetch the data
           self.fetchpeople()
        }
        
        //return swipe action
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

