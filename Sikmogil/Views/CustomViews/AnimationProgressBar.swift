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
        
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - progressLineWidth / 2
        
        // 트랙 (전체 원) 그리기
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = trackLineWidth
        self.layer.addSublayer(trackLayer)
        
        // 프로그래스 바 (진행 원) 그리기
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
       
        let targetValue = max(0, min(1, value))
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progress
        animation.toValue = targetValue
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        progress = targetValue
        progressLayer.add(animation, forKey: "progressAnimation")
    }
}
