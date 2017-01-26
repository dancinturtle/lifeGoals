//
//  DetailsViewController.swift
//  lifeGoalsBelt
//
//  Created by Amy Giver on 1/24/17.
//  Copyright © 2017 Amy Giver Squid. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    weak var cancelDelegate: CancelButtonDelegate?
    weak var saveDelegate: SaveGoalDelegate?
    var editGoal: Goal?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var goalTextField: UITextField!
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        cancelDelegate?.cancelButtonPressedBy(sender: self)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let realDateToSave = datePicker.date
        if goalTextField.text != "" {
            saveDelegate?.save(goal: goalTextField.text!, dueDate: realDateToSave, goal: editGoal)
            cancelDelegate?.cancelButtonPressedBy(sender: self)
            goalTextField.text = ""
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        print("loaded the details view controller at \(NSDate()) date picker's timezone \(datePicker.timeZone)")
        datePicker.datePickerMode = .date
        datePicker.minimumDate = NSDate() as Date
        if let goalToEdit = editGoal {
            print("We have a goal to Edit!")
            goalTextField.text = goalToEdit.goal
            self.datePicker.date = goalToEdit.dueDate! as Date
        }
    }

    
}

