//
//  AppController.swift
//  threeAmigosAssignmentThree
//
//  Created by Bryce Shurts on 10/11/23.
//

import UIKit
import CoreMotion

let storage = UserDefaults.standard

class AppController: UIViewController {
    
    // MARK: Class Variables
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    // MARK: Private Properties
    private var previousSteps: Int = -1
    
    // MARK: UI Outlets
    
    @IBOutlet weak var rewardNotif: UILabel!
    @IBOutlet weak var currentSteps: UILabel!
    @IBOutlet weak var currentActivity: UILabel!
    @IBOutlet weak var yesterdaySteps: UILabel!
    
    @IBOutlet weak var dailyGoalLabel: UILabel!
    @IBOutlet weak var gameButton: UIButton!
    
    @IBOutlet weak var progressBar: CircleProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if storage.object(forKey: "dailyGoal") == nil {
            storage.set(1000, forKey: "dailyGoal")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.monitorActivity()
        self.monitorSteps()
    }
    
    // MARK: Motion Methods
        func monitorActivity(){
            // is activity is available
            if CMMotionActivityManager.isActivityAvailable(){
                // update from this queue (should we use the MAIN queue here??.... )
                self.activityManager.startActivityUpdates(to: OperationQueue.main)
                {(activity:CMMotionActivity?)->Void in
                    // unwrap the activity and display
                    // using the real time pedometer influences how often we get activity updates...
                    // so these updates can come through less often than we may want
                    if let unwrappedActivity = activity {
                        var outputString: String = ""
                        
                        if unwrappedActivity.stationary{
                            outputString += "Stationary\n"
                        }
                        if unwrappedActivity.walking{
                            outputString += "Walking\n"
                        }
                        if unwrappedActivity.running{
                            outputString += "Running\n"
                        }
                        if unwrappedActivity.cycling{
                            outputString += "Cycling\n"
                        }
                        if unwrappedActivity.automotive{
                            outputString += "Driving\n"
                        }
                        if unwrappedActivity.unknown{
                            outputString += "Unknown\n"
                        }
                        self.currentActivity.text = outputString
                    }
                }
            }
            else{
                self.currentActivity.text = "No Activity Data"
            }
        }
        
        func monitorSteps(){
            // check if pedometer is okay to use
            if CMPedometer.isStepCountingAvailable(){
                
                // start updating the pedometer from the start of the current day
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                
                let startOfToday = dateFormatter.date(from: dateFormatter.string(from: Calendar.current.startOfDay(for: Date())))
                let startOfYesterday = Calendar.current.date(byAdding: .day, value: -1, to: startOfToday!)
                
                pedometer.startUpdates(from: startOfYesterday!)
                {(pedData:CMPedometerData?, error:Error?)->Void in
                    if let data = pedData {
                        DispatchQueue.main.async {
                            self.yesterdaySteps.text = "\(data.numberOfSteps.intValue)"
                        }
                    }
                }
                
                pedometer.startUpdates(from: startOfToday!)
                {(pedData:CMPedometerData?, error:Error?)->Void in
                    
                    // if no errors, update the main UI
                    if let data = pedData {
                        
                        // display the output directly on the phone
                        DispatchQueue.main.async {
                            
                            if self.previousSteps == -1 {
                                self.previousSteps = data.numberOfSteps.intValue
                                self.progressBar.increaseBy(steps: data.numberOfSteps.intValue)
                            }
                            
                            let stepsTaken = data.numberOfSteps.intValue
                            let newSteps = self.previousSteps + (stepsTaken - self.previousSteps)
                            
                            // this goes into the large gray area on view
                            self.currentSteps.text = newSteps.description
                            
                            if newSteps >= storage.integer(forKey: "dailyGoal") {
                                self.rewardNotif.isHidden = false
                                self.dailyGoalLabel.isHidden = false
                                self.gameButton.isHidden = false
                            }
                            else{
                                self.rewardNotif.isHidden = true
                                self.dailyGoalLabel.isHidden = true
                                self.dailyGoalLabel.isHidden = true
                            }
                            
                            //self.progressBar.increaseBy(steps: (stepsTaken - self.previousSteps))
                            self.progressBar.increaseBy(steps: newSteps)
                            
                            self.previousSteps = newSteps
                        }
                    }
                }
            }
            else{
                self.currentSteps.text = "No Step Data"
                self.yesterdaySteps.text = "No Step Data"
                self.progressBar.increaseBy(steps: storage.integer(forKey: "dailyGoal"), color: UIColor.red.cgColor)
            }
        }
}
