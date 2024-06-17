//
//  AnimationProgressBar.swift
//  Sikmogil
//
//  Created by 정유진 on 6/17/24.
//

import UIKit
import SnapKit
import Then

class AnimationProgressBar: UIView {
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var trackLineWidth: CGFloat = 10
    var progressLineWidth: CGFloat = 30
    var progressColor: UIColor = .systemBlue
    var trackColor: UIColor = .lightGray
    
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard progress >= 0 && progress <= 1 else { return }
        
        // Remove previous layers
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - progressLineWidth / 2
        
        // Track (full circle)
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = trackLineWidth
        self.layer.addSublayer(trackLayer)
        
        // Progress bar (progress circle)
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + progress * 2 * CGFloat.pi
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = progressLineWidth
        progressLayer.lineCap = .round
        self.layer.addSublayer(progressLayer)
    }
    
    func animateProgress(to value: CGFloat, duration: TimeInterval) {
        // Ensure the value is within the range [0, 1]
        let targetValue = max(0, min(1, value))
        
        // Create a CABasicAnimation to animate the strokeEnd of progressLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progress
        animation.toValue = targetValue
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        // Update progress property with the target value
        progress = targetValue
        
        // Add the animation to progressLayer
        progressLayer.add(animation, forKey: "progressAnimation")
    }
}
