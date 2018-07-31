//
//  ViewController.swift
//  UserActivityLifetimeRequirementTest
//
//  Created by Tim Ekl on 2018.06.20.
//  Copyright © 2018 Tim Ekl. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    enum Lifetime: CaseIterable {
        case immediate
        case runLoopTurn
        case oneSecond
        case untilNextActivity
        
        var title: String {
            switch self {
            case .immediate: return "Until method end"
            case .runLoopTurn: return "Until next run loop turn"
            case .oneSecond: return "For one second"
            case .untilNextActivity: return "Until next activity created"
            }
        }
    }
    var lifetime: Lifetime = .immediate
    var lastActivity: NSUserActivity? = nil

    @IBAction func makeUserActivity(_ sender: Any) {
        lastActivity = nil
        
        let identifier = "com.lithium3141.UserActivityLifetimeRequirementTest"
        let activity = NSUserActivity(activityType: identifier)
        activity.title = "It's a user activity!"
        activity.isEligibleForSearch = true
        activity.isEligibleForHandoff = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(identifier)
        activity.requiredUserInfoKeys = []
        activity.userInfo = [:]
        activity.becomeCurrent()
        
        switch lifetime {
        case .immediate:
            // will go out of scope and get deallocated
            break
            
        case .runLoopTurn:
            DispatchQueue.main.async {
                // hold onto the activity until the next run loop turn
                let _ = activity
            }
            
        case .oneSecond:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let _ = activity
            }
            
        case .untilNextActivity:
            lastActivity = activity
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Lifetime.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lifetime = Lifetime.allCases[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Lifetime.allCases[row].title
    }

}

