//
//  TimerViewController.swift
//  TableTopAssistant
//
//  Created by Reinaldo Demori on 11/5/23.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeTextView: UITextView!
    
    var seconds = 0
    var timer = Timer()
    
    var hasStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
        
    @IBAction func startTimer(_ sender: UIButton) {
        
        if hasStarted {
            //pause timer
            timer.invalidate()
            sender.setTitle("START", for: .normal)
            
            hasStarted = false
        } else {
            //start timer
            guard let timerInfo = timeTextView.text else {
                Alerts.showBasicAlert(title: "Error", message: "There was some kind of error when trying to countdown", on: self)
                return
            }
            
            do {
                seconds = try timeToSeconds(for: timerInfo)
            } catch {
                Alerts.showBasicAlert(title: "Invalid Time Format", message: "Please make sure you enter the time in the proper format of Hours:Minutes:Seconds. For example, 3 hours 15 minutes and 8 seconds should be entered as 03:15:08", on: self)
            }
            
            guard seconds > 0 else {
                Alerts.showBasicAlert(title: "Invalid Time Format", message: "Please enter the time in the proper format", on: self)
                
                return
            }
            
            timeTextView.isEditable = false
            resetButton.isHidden = false
            
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
            
            sender.setTitle("PAUSE", for: .normal)
            hasStarted = true
        }
        
    }
    
    @IBAction func resetTimer(_ sender: UIButton) {
        reset()
    }
    
    func reset() {
        timer.invalidate()
        resetButton.isHidden = true
        
        seconds = 0
        
        timeTextView.isEditable = true
        hasStarted = false
       
        startButton.setTitle("START", for: .normal)
        timeTextView.text = "00:00:00"
        
    }
    
    @objc func count() {
        seconds -= 1
        timeTextView.text = secondsToTime(for: seconds)
        
        if timeTextView.text == "24:00:00" || timeTextView.text == "00:00:00"{
            reset()
            Alerts.showBasicAlert(title: "Timer has finished!", message: "The time has finished counting down!", on: self)
        }
        
    }
    
}

