//
//  Alerts.swift
//  TableTopAssistant
//
//  Created by Daniel Garcia Smester on 11/12/23.
//

import UIKit

struct Alerts {
    static func showBasicAlert(title: String, message: String, on vc: UIViewController) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel)
        
        alert.addAction(dismiss)
        vc.present(alert, animated: true)
    }
}


