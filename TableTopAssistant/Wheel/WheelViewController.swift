//
//  WheelViewController.swift
//  TableTopAssistant
//
//  Created by Reinaldo Demori on 11/5/23.
//

import UIKit

class WheelViewController: UIViewController {
    var wheel: UIWheel!
    @IBOutlet weak var addSegmentButton: UIButton!
    @IBOutlet weak var deleteSegmentButton: UIButton!
    @IBOutlet weak var clearWheelButton: UIButton!
    @IBOutlet weak var spinWheelButton: UIButton!
    
    let indicatorLayer = CAShapeLayer()
    
    override func viewDidLoad() {
            super.viewDidLoad()

            // Setup the wheel if not already set up
            setupWheelIfNeeded()

            // Setup the indicator
            setupIndicator()
        }

        // Call this method from `viewDidLoad` or integrate its logic there
        private func setupWheelIfNeeded() {
            if wheel == nil {
                wheel = UIWheel(frame: CGRect(x: 0, y: 0, width: 300, height: 300)) // Adjust the size as needed
                wheel.center = view.center
                view.addSubview(wheel)
            }
        }

    private func setupIndicator() {
        // Define the size and path of the indicator
        let indicatorWidth: CGFloat = 30.0
        let indicatorHeight: CGFloat = 30.0
        let indicatorPath = UIBezierPath()
        
        // Start from the left corner of the triangle base
        indicatorPath.move(to: CGPoint(x: -indicatorWidth / 2, y: 0))
        
        // Draw line to the right corner of the triangle base
        indicatorPath.addLine(to: CGPoint(x: indicatorWidth / 2, y: 0))
        
        // Draw line to the point of the triangle
        indicatorPath.addLine(to: CGPoint(x: 0, y: indicatorHeight))
        
        // Close the path to complete the triangle
        indicatorPath.close()

        // Style the indicator
        indicatorLayer.path = indicatorPath.cgPath
        indicatorLayer.fillColor = UIColor.black.cgColor // Change as needed

        // Position the indicator at the top center of the wheel
                indicatorLayer.position = CGPoint(x: wheel.center.x, y: wheel.frame.minY)
                indicatorLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

                // Add the indicator layer to the view, not as a sublayer of the wheel (so that it does not spin)
                view.layer.addSublayer(indicatorLayer)
    }

    
    private func setupWheel() {
            // Initialize wheel without any item
            wheel = UIWheel(frame: CGRect(x: 0, y: 0, width: 300, height: 300)) // Size can be adjusted
            wheel.center = view.center // Center the wheel
            view.addSubview(wheel)
        }

    @IBAction func clearWheelButtonTapped(_ sender: Any) {
        wheel.resetWheel()
    }
    
    @IBAction func addSegmentButtonTapped(_ sender: Any) {
        // Alert to type the name of the item
                let alertController = UIAlertController(title: "New item", message: "Type name of the item", preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.placeholder = "Name of item"
                }
                let addAction = UIAlertAction(title: "Add", style: .default) { [unowned self] _ in
                    if let segmentName = alertController.textFields?.first?.text, !segmentName.isEmpty {
                        self.addSegment(withName: segmentName)
                    }
                }
                alertController.addAction(addAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true)
    }

    private func addSegment(withName name: String) {
            // Create and configure a new segment
            let color = UIColor(hue: CGFloat(wheel.segments.count)/6, saturation: 1, brightness: 1, alpha: 1) // This will assign a color based on the number of segments
            wheel.addSegment(color: color, labelText: name)
        }
    
    @IBAction func deleteSegmentButtonTapped(_ sender: Any) {
        wheel.removeLastSegment()
    }
    
    
    @IBAction func spinWheelButtonTapped(_ sender: Any) {
        wheel.spinWheel { selectedSegment in
            }
    }
    
}
