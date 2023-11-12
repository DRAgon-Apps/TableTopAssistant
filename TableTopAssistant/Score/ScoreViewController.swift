//
//  ScoreViewController.swift
//  TableTopAssistant
//
//  Created by Reinaldo Demori on 11/5/23.
//

import UIKit

class ScoreViewController: UIViewController {

    
    @IBOutlet weak var p1Score: UILabel!
    @IBOutlet weak var p2Score: UILabel!
    
    var p1Count = 0
    var p2Count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func p1PlusOne() {
        p1Count += 1
        p1Score.text = String(p1Count)
    }
    
    @IBAction func p1MinusOne() {
        p1Count -= 1
        p1Score.text = String(p1Count)
    }
    
    @IBAction func p2PlusOne() {
        p2Count += 1
        p2Score.text = String(p2Count)
    }
    
    @IBAction func p2MinusOne() {
        p2Count -= 1
        p2Score.text = String(p2Count)
    }
}
