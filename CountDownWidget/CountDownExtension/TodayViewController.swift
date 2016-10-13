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
        
        guard let date = loadDateIfSaved() else {
            self.dateLabel.text = "No Date to count from."
            return
        }
        
        endDate = date
        
        taskManager = Timer(timeInterval: 1, target: self, selector: #selector(TodayViewController.updateCountDown), userInfo: nil, repeats: true)
        RunLoop.main.add(taskManager, forMode: .commonModes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        taskManager.invalidate()
    }
    
    private func loadDateIfSaved() -> Date? {
        let usrDefaults = UserDefaults.standard
        guard let date = usrDefaults.object(forKey: dateKey) else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            guard let christmas = dateFormatter.date(from: "25/12/2016") else {
                return nil
            }
            usrDefaults.set(christmas, forKey: dateKey)
            return christmas
        }
        return date as? Date
    }
    
    func updateCountDown() {
        let currentDate = Date()
        
        let timeInterval = Int(endDate.timeIntervalSince(currentDate as Date))
        
        let min = 60
        let hour = 60*min
        let day = 24*hour
        let days = timeInterval / day
        let hours = (timeInterval % day) / hour
        let mins = (timeInterval % hour) / min
        let seconds = timeInterval % min
        
        self.dateLabel.text = "\(days) days \n\(hours) hours \n\(mins) minutes \n\(seconds) seconds"
    }
}
