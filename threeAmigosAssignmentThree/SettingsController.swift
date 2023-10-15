//
//  SettingsController.swift
//  threeAmigosAssignmentThree
//
//  Created by Bryce Shurts on 10/11/23.
//

import UIKit

class SettingsController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var dailyGoalField: UITextField!
    
    override func viewDidLoad() {
        self.dailyGoalField.text = storage.string(forKey: "dailyGoal")
        
        self.dailyGoalField.delegate = self
        self.dailyGoalField.becomeFirstResponder()
        self.dailyGoalField.returnKeyType = .done
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.dailyGoalField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.dailyGoalField.hasText{
            print("Wrote changes")
            storage.set(self.dailyGoalField.text, forKey: "dailyGoal")
        }
        self.dailyGoalField.resignFirstResponder()
        
        return true
    }
}
