//
//  UIWheel.swift
//  TableTopAssistant
//
//  Created by Alex Lejarraga on 11/7/23.
//

import Foundation
import UIKit

class UIWheel: UIView {
    var segments = [CAShapeLayer]() // Use CAShapeLayer to draw the segments
    
    func addSegment(color: UIColor, labelText: String) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        let totalSegments = CGFloat(segments.count + 1) // Including the new segment
        let angleSize = (2 * CGFloat.pi) / totalSegments

        // Create and configure the new segment layer
        let segmentLayer = CAShapeLayer()
        let startAngleForNewSegment = -CGFloat.pi / 2 + angleSize * CGFloat(segments.count)
        let endAngleForNewSegment = startAngleForNewSegment + angleSize
        segmentLayer.path = createSegmentPath(startAngle: startAngleForNewSegment, endAngle: endAngleForNewSegment, radius: radius, center: center).cgPath
        segmentLayer.fillColor = color.cgColor
        
        // Create and configure the label for the new segment
        let segmentLabel = createSegmentLabel(text: labelText, radius: radius, center: center, midAngle: (startAngleForNewSegment + endAngleForNewSegment) / 2)
        segmentLayer.addSublayer(segmentLabel)
        
        // Add the new segment layer to the wheel
        layer.addSublayer(segmentLayer)
        segments.append(segmentLayer)

        // Re-draw all segments with updated angles and labels
        for index in 0..<segments.count - 1 { // Exclude the last segment which is just added
            let segment = segments[index]
            let startAngle = -CGFloat.pi / 2 + angleSize * CGFloat(index)
            let endAngle = startAngle + angleSize
            segment.path = createSegmentPath(startAngle: startAngle, endAngle: endAngle, radius: radius, center: center).cgPath
            
            // Check if a label already exists and update it
            if let textLayer = segment.sublayers?.first(where: { $0 is CATextLayer }) as? CATextLayer {
                // Update the label's properties if needed
                updateSegmentLabel(label: textLayer, center: center, radius: radius, midAngle: (startAngle + endAngle) / 2)
            } else {
                // If for some reason a segment does not have a label, create a new one
                let newLabel = createSegmentLabel(text: "Segment \(index + 1)", radius: radius, center: center, midAngle: (startAngle + endAngle) / 2)
                segment.addSublayer(newLabel)
            }
        }
    }

        private func createSegmentPath(startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat, center: CGPoint) -> UIBezierPath {
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            return path
        }

    private func createSegmentLabel(text: String, radius: CGFloat, center: CGPoint, midAngle: CGFloat) -> CATextLayer {
        let label = CATextLayer()
        label.string = text
        label.alignmentMode = .center
        label.fontSize = 12
        label.bounds = CGRect(x: 0, y: 0, width: radius / 2, height: 20) // You may need to adjust the width based on your text
        label.foregroundColor = UIColor.black.cgColor
        label.isWrapped = true
        label.contentsScale = UIScreen.main.scale
        
        // The distance from the center to the label position
        let labelRadius = radius * 0.75 // Adjust this value to move the label in or out
        let xPosition = center.x + labelRadius * cos(midAngle)
        let yPosition = center.y + labelRadius * sin(midAngle)
        
        // Set the label position
        label.position = CGPoint(x: xPosition, y: yPosition)
        
        // Rotate the label to be upright
        var transform = CGAffineTransform(rotationAngle: -midAngle)
        
        // Adjust the anchor point if the label is on the left side
        if midAngle < -CGFloat.pi / 2 || midAngle > CGFloat.pi / 2 {
            transform = transform.rotated(by: CGFloat.pi)
        }
        
        label.transform = CATransform3DMakeAffineTransform(transform)
        
        return label
    }


    private func updateSegmentLabel(label: CATextLayer, center: CGPoint, radius: CGFloat, midAngle: CGFloat) {
        // Calculate the label's position based on the midpoint angle
        let labelRadius = radius * 0.7 // Adjust as needed
        let xPosition = center.x + labelRadius * cos(midAngle)
        let yPosition = center.y + labelRadius * sin(midAngle)
        label.position = CGPoint(x: xPosition, y: yPosition)

        // Adjust the label's rotation to ensure it is upright
        let isLeftSide = midAngle > CGFloat.pi / 2 || midAngle < -CGFloat.pi / 2
        let labelRotation = isLeftSide ? midAngle - CGFloat.pi : midAngle
        label.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: -labelRotation))
    }

    // This method removes the last segment added to the wheel.
        func removeLastSegment() {
            guard !segments.isEmpty else { return }
            let lastSegment = segments.removeLast()
            lastSegment.removeFromSuperlayer()

            // Optionally, you might want to redraw the remaining segments if needed
            redrawSegments()
        }

        // This method removes all segments from the wheel.
        func resetWheel() {
            segments.forEach { $0.removeFromSuperlayer() }
            segments.removeAll()
        }

        // This method redraws all the segments in the wheel
        private func redrawSegments() {
            let center = CGPoint(x: bounds.midX, y: bounds.midY)
            let radius = min(bounds.width, bounds.height) / 2
            let angleSize = segments.isEmpty ? 0 : (2 * CGFloat.pi) / CGFloat(segments.count)

            for (index, segment) in segments.enumerated() {
                let startAngle = -CGFloat.pi / 2 + angleSize * CGFloat(index)
                let endAngle = startAngle + angleSize
                segment.path = createSegmentPath(startAngle: startAngle, endAngle: endAngle, radius: radius, center: center).cgPath

                // Update the position and rotation of the label for each segment
                if let textLayer = segment.sublayers?.first(where: { $0 is CATextLayer }) as? CATextLayer {
                    let midAngle = (startAngle + endAngle) / 2
                    updateSegmentLabel(label: textLayer, center: center, radius: radius, midAngle: midAngle)
                }
            }
        }
    
    func spinWheel(completion: @escaping (_ selectedSegment: Int) -> Void) {
        // Determine the duration of the spin
        let spinDuration = 6.0 // Adjust this value for a longer or shorter spin
        
        // Create a basic rotation animation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        // Calculate the full rotations plus a random extra angle
        let numberOfFullRotations = 10 // Full rotations for a more dramatic spin
        let randomExtraAngle = Double.random(in: 0...2 * .pi)
        let finalAngle = Double(numberOfFullRotations) * 2 * .pi + randomExtraAngle
        
        // Set the rotation animation properties
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = finalAngle
        rotationAnimation.duration = spinDuration
        rotationAnimation.isCumulative = true
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.fillMode = .forwards
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        // Add a completion block
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // Determine the selected segment based on the final angle
            let selectedSegment = self.calculateSelectedSegment(fromAngle: finalAngle)
            completion(selectedSegment)
        }
        
        // Add the animation to the wheel's layer
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        CATransaction.commit()
    }

    private func calculateSelectedSegment(fromAngle angle: Double) -> Int {
        let normalizedAngle = angle.truncatingRemainder(dividingBy: 2 * .pi)
        let angleSize = (2 * .pi) / Double(segments.count)
        
        // This adjusts the normalized angle to account for the indicator's position.
        // If your indicator is at the top (-π/2), this line should correct the angle.
        let adjustedAngle = normalizedAngle + .pi / 2

        // Ensure the adjusted angle is within 0 to 2π.
        let positiveAngle = adjustedAngle.truncatingRemainder(dividingBy: 2 * .pi)
        
        // Calculate the index of the segment. Remember that the index is 0-based.
        var segmentIndex = Int((2 * .pi - positiveAngle) / angleSize) % segments.count
        
        // Depending on the direction of indexing, you may need to subtract the index from the count.
        segmentIndex = segments.count - segmentIndex
        // Adjust by 1 if your segments are 1-indexed for display.
        segmentIndex = (segmentIndex + segments.count - 1) % segments.count
        
        return segmentIndex
    }


}

extension UIWheel: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // Handle animation stop if needed
    }
}
