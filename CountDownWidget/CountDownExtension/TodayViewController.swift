//
//  TodayViewController.swift
//  CountDownExtension
//
//  Created by Andrew Polkinghorn on 13/10/2016.
//  Copyright © 2016 Scott Logic. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let dateKey = "COUNTDOWN_DATE"
    var endDate = Date().addingTimeInterval(60*60*10)
    var taskManager = Timer()
    
    @IBOutlet var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endDate = loadDateIfSaved()
        
        taskManager = Timer(timeInterval: 1, target: self, selector: #selector(TodayViewController.updateCountDown), userInfo: nil, repeats: true)
        RunLoop.main.add(taskManager, forMode: .commonModes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        taskManager.invalidate()
    }
    
    private func loadDateIfSaved() -> Date {
        let usrDefaults = UserDefaults.standard
        guard let date = usrDefaults.object(forKey: dateKey) else {
            usrDefaults.set(endDate, forKey: dateKey)
            return endDate
        }
        return date as! Date
    }
    
    func updateCountDown() {
        let currentDate = Date()
        
        let timeInterval = Int(endDate.timeIntervalSince(currentDate as Date))
        
        let hour = 60*60
        let seconds = timeInterval % 60
        let mins = (timeInterval % hour) / 60
        let hours = timeInterval / hour
        
        self.dateLabel.text = "\(hours) hours \(mins) minutes \(seconds) seconds"
    }
}
