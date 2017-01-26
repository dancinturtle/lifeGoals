//
//  Protocols.swift
//  lifeGoalsBelt
//
//  Created by Amy Giver on 1/24/17.
//  Copyright © 2017 Amy Giver Squid. All rights reserved.
//

import UIKit


protocol CancelButtonDelegate: class {
    func cancelButtonPressedBy(sender controller: UIViewController)

}

protocol FilterDelegate: class {
    func doneButtonPressedBy(sender controller: UIViewController, filter filterSwitch: Bool)
}

protocol SaveGoalDelegate: class {
    func save(goal goalToSave: String, dueDate completionDate: Date, goal editedGoal: Goal?)
}
