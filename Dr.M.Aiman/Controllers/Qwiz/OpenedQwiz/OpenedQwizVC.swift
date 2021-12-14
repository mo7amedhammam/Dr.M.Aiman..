//
//  OpenedQwizVC.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 26/05/2021.
//

import UIKit

//----------------------- DOWN ----------------------------
// Descending Counter
class OpenedQwizVC:  UIViewController {
    
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var startButtonOut: UIButton!
    @IBOutlet weak var stopButtonOut: UIButton!


var timer: Timer?
var hours: Int = 01
var mins: Int = 01
var secs: Int = 00

override func viewDidLoad() {
    super.viewDidLoad()

    stopButtonOut.isUserInteractionEnabled = false
}

@IBAction func startButtonPressed(_ sender: Any) {
    startTimer()
    startButtonOut.isUserInteractionEnabled = false
    stopButtonOut.isUserInteractionEnabled = true
}
    
    @IBAction func StopBtnPressed(_ sender: Any) {
        stopTimer()
        startButtonOut.isUserInteractionEnabled = true
        stopButtonOut.isUserInteractionEnabled = false
    }
    
    func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
        
        self.updateTimer()
    })
}
    func updateTimer(){
        if self.secs > 0 {
            self.secs = self.secs - 1
        }
        else if self.mins > 0 && self.secs == 0 {
            self.mins = self.mins - 1
            self.secs = 59
        }
        else if self.hours > 0 && self.mins == 0 && self.secs == 0 {
            self.hours = self.hours - 1
            self.mins = 59
            self.secs = 59
        }
        self.updateLabel()
    }
    


private func updateLabel() {
    TimerLabel.text = "\(hours):\(mins):\(secs)"
}
    
    func stopTimer() {
        timer!.invalidate()
        remainingTime()
    }
    func remainingTime()  {
        let RemainingHours = hours
        let RemainingMinutes = hours
        let RemainingSeconds = hours
        print("\(RemainingHours)h & \(RemainingMinutes)m & \(RemainingSeconds)s ")
    }
}


// --------------------- UP --------------------------
// Aescending Counter
//class OpenedQwizVC:  UIViewController
//{
//    @IBOutlet weak var TimerLabel: UILabel!
//    @IBOutlet weak var startStopButton: UIButton!
//    @IBOutlet weak var resetButton: UIButton!
//
//    var timer:Timer = Timer()
//    var count:Int = 0
//    var timerCounting:Bool = false
//
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        startStopButton.setTitleColor(UIColor.green, for: .normal)
//    }
//
//    @IBAction func resetTapped(_ sender: Any)
//    {
//        let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you would like to reset the Timer?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
//            //do nothing
//        }))
//
//        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
//            self.count = 0
//            self.timer.invalidate()
//            self.TimerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
//            self.startStopButton.setTitle("START", for: .normal)
//            self.startStopButton.setTitleColor(UIColor.green, for: .normal)
//        }))
//
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    @IBAction func startStopTapped(_ sender: Any)
//    {
//        if(timerCounting)
//        {
//            timerCounting = false
//            timer.invalidate()
//            startStopButton.setTitle("START", for: .normal)
//            startStopButton.setTitleColor(UIColor.green, for: .normal)
//        }
//        else
//        {
//            timerCounting = true
//            startStopButton.setTitle("STOP", for: .normal)
//            startStopButton.setTitleColor(UIColor.red, for: .normal)
//            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
//        }
//    }
//
//    @objc func timerCounter() -> Void
//    {
//        count = count + 1
//        let time = secondsToHoursMinutesSeconds(seconds: count)
//        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
//        TimerLabel.text = timeString
//    }
//
//    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
//    {
//        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
//    }
//
//    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
//    {
//        var timeString = ""
//        timeString += String(format: "%02d", hours)
//        timeString += " : "
//        timeString += String(format: "%02d", minutes)
//        timeString += " : "
//        timeString += String(format: "%02d", seconds)
//        return timeString
//    }
//
//
//}


