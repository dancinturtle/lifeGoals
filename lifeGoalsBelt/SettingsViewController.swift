//
//  SettingsViewController.swift
//  lifeGoalsBelt
//
//  Created by Amy Giver on 1/24/17.
//  Copyright © 2017 Amy Giver Squid. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    weak var cancelDelegate: CancelButtonDelegate?
    weak var doneDelegate: FilterDelegate?
    
    @IBOutlet weak var filterSwitch: UISwitch!
    
    @IBAction func switchIsFlipped(_ sender: UISwitch) {
        print("Switch is flipping!", sender.isOn)
        if(sender.isOn){
            defaults.set(true, forKey:"Filter")
        }
        else {
            defaults.set(false, forKey:"Filter")
        }
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        print("Done button pressed")
        cancelDelegate?.cancelButtonPressedBy(sender: self)
        doneDelegate?.doneButtonPressedBy(sender: self, filter: self.filterSwitch.isOn)
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        print("cancel button pressed")
        cancelDelegate?.cancelButtonPressedBy(sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.bool(forKey:"Filter"){
            filterSwitch.isOn = true
        }
        else {
            filterSwitch.isOn = false
        }

    }

    
    
}
