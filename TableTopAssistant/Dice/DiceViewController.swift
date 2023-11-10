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

    }
    
    // Randomly generates a number from 1 to a number specified by user, as many times as the user specifies
    @IBAction func rollButtonTapped(_ sender: UIButton) {
        
        // Prevents textfields from being empty
        guard let dieMaxText = dieMaxField.text,
              let diceNumberText = diceNumberfield.text,
              !dieMaxText.isEmpty, !diceNumberText.isEmpty else {
            
            showMissingFieldsAlert()
            return
            
        }
        // Prevents that letters are entered in the textfields
        guard let dieMax = Int(dieMaxText),
              let diceNumber = Int(diceNumberText) else {
            
            showNumberError()
            return
            
        }
        
        // Prevents user from inputing 0 or lower
        if dieMax <= 0 || diceNumber <= 0 {
            
            showNumberError()
            return
        }
        
        // Makes "You Rolled:" appear and gets rid of the text in the text view
        rollLabel.text = "You Rolled:"
        diceResultsView.text = ""
        
        // Randomly generates a number then appends it to the text view
        for i in 1...diceNumber {
            
            let numberRolled = String(Int.random(in: 1...dieMax))
            
            if i == diceNumber {
                diceResultsView.text += "\(numberRolled)"
                
            } else {
                diceResultsView.text += "\(numberRolled), "
                
            }
            
        }
        
    }
    
    // Shows pop up alert for missing field
    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    // Shows pop up alert when input is 0 or is not a number
    private func showNumberError() {
        let alertController = UIAlertController(title: "Opps...", message: "Number cannot be 0 or have letters", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)    }
}
