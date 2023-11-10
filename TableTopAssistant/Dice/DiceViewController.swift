//
//  DiceViewController.swift
//  TableTopAssistant
//
//  Created by Reinaldo Demori on 11/5/23.
//

import UIKit

class DiceViewController: UIViewController {

    @IBOutlet weak var dieMaxField: UITextField!
    
    @IBOutlet weak var diceNumberfield: UITextField!
    
    @IBOutlet weak var diceResultsView: UITextView!
    
    @IBOutlet weak var rollLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func rollButtonTapped(_ sender: UIButton) {
        
        guard let dieMaxText = dieMaxField.text,
              let diceNumberText = diceNumberfield.text,
              !dieMaxText.isEmpty, !diceNumberText.isEmpty else {
            
            showMissingFieldsAlert()
            return
            
        }
        
        guard let dieMax = Int(dieMaxText),
              let diceNumber = Int(diceNumberText) else {
            
            showNumberError()
            return
            
        }
        
        if dieMax <= 0 || diceNumber <= 0 {
            
            showNumberError()
            return
        }
        
        rollLabel.text = "You Rolled:"
        diceResultsView.text = ""
        
        for i in 1...diceNumber {
            
            var numberRolled = String(Int.random(in: 1...dieMax))
            
            if i == diceNumber {
                diceResultsView.text += "\(numberRolled)"
                
            } else {
                diceResultsView.text += "\(numberRolled), "
                
            }
            
        }
        
        
        
    }
    
    
    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func showNumberError() {
        let alertController = UIAlertController(title: "Opps...", message: "Number cannot be 0 or have letters", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)    }
}
