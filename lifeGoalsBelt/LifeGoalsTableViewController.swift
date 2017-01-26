//
//  ViewController.swift
//  lifeGoalsBelt
//
//  Created by Amy Giver on 1/24/17.
//  Copyright © 2017 Amy Giver Squid. All rights reserved.
//

import UIKit
import CoreData

class LifeGoalsTableViewController: UITableViewController, CancelButtonDelegate, FilterDelegate, SaveGoalDelegate {
    
    
   
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    var goals = [Goal]()
    
    let defaults = UserDefaults.standard

    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllGoals()
        settingsButton.title = NSString(string: "\u{2699}\u{0000FE0E}") as String

        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("goals in array", goals.count)
        return goals.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "subtitleCell")
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = DateFormatter.Style.short
        let stringDate = formatter.string(from: goals[indexPath.row].dueDate! as Date)
        cell.textLabel?.text = stringDate
        cell.detailTextLabel?.text = goals[indexPath.row].goal!
        if(goals[indexPath.row].completed){
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenGoal = goals[indexPath.row]
        if chosenGoal.completed == false {
            chosenGoal.completed = true
        }
        checkForChange()
        fetchAllGoals()
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete"){ (action, indexPath) in
            let alert = UIAlertController(title: "Warning", message: "Remove item?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {action in
                let deleting = self.goals[indexPath.row]
                self.moc.delete(deleting)
                self.checkForChange()
                self.fetchAllGoals()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        let edit = UITableViewRowAction(style: .normal, title:"Edit"){(action, indexPath) in
            let editing = self.goals[indexPath.row]
            self.performSegue(withIdentifier: "detailsSegue", sender: editing)
        }
        return [delete, edit]
        
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        print("settings button pressed")
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navcontroller = segue.destination as! UINavigationController
        if(segue.identifier == "detailsSegue"){
            let controller = navcontroller.topViewController as! DetailsViewController
            controller.cancelDelegate = self
            controller.saveDelegate = self
            if let goalToEdit = sender as? Goal {
                controller.editGoal = goalToEdit
            }
        }
        if(segue.identifier == "settingsSegue"){
            let controller = navcontroller.topViewController as! SettingsViewController
            controller.cancelDelegate = self
            controller.doneDelegate = self
        }
    }
    
    func cancelButtonPressedBy(sender controller: UIViewController){
        dismiss(animated: true, completion: nil)
    }
    
    func doneButtonPressedBy(sender controller: UIViewController, filter filterSwitch: Bool) {
        fetchAllGoals()
    }
    
    func save(goal goalToSave: String, dueDate completionDate: Date, goal editedGoal: Goal?){
        if let editingGoal = editedGoal {
            editingGoal.goal = goalToSave
            editingGoal.dueDate = completionDate as NSDate?
        }
        else {
            let newGoal = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: moc) as! Goal
            newGoal.goal = goalToSave
            newGoal.completed = false
            newGoal.dueDate = completionDate as NSDate?
        }
        checkForChange()
        fetchAllGoals()
    }
    
    func checkForChange(){
        if moc.hasChanges {
            do {
                try moc.save()
                print("Success saving!!!")
            }
            catch {
                print(error)
            }
        }

    }
    
    func fetchAllGoals(){
        let userRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        if defaults.bool(forKey: "Filter") {
            userRequest.predicate = NSPredicate(format: "completed == false")
        }
        let sortDesc = NSSortDescriptor(key: "dueDate", ascending: true)
        let sortDescriptors = [sortDesc]
        userRequest.sortDescriptors = sortDescriptors
       
        do {
            let results = try moc.fetch(userRequest)
            goals = results as! [Goal]
            for goal in goals {
                print(goal.completed, goal.dueDate!, goal.goal!)
            }
        }
        catch {
            print(error)
        }
        tableView.reloadData()
    }



}

