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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
        
    @IBAction func startTimer(_ sender: UIButton) {
        
        guard let timerInfo = timeTextView.text else { return }
        
        do {
            seconds = try timeToSeconds(for: timerInfo)
        } catch {
            print("Uh-oh!")
        }
        
        guard seconds > 0 else { return }
        
        timeTextView.isEditable = false
        resetButton.isHidden = false
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
    }
    
    @IBAction func resetTimer(_ sender: UIButton) {
        reset()
    }
    
    func reset() {
        timer.invalidate()
                
        seconds = 0
        timeTextView.text = "00:00:00"
        resetButton.isHidden = true
        timeTextView.isEditable = true
    }
    
    @objc func count() {
        seconds -= 1
        timeTextView.text = secondsToTime(for: seconds)
        
        if timeTextView.text == "24:00:00"{
            reset()
        }
    }
    
}

