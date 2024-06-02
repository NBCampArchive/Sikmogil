//
//  CustomCircularProgressBar.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/3/24.
//

import UIKit
import SnapKit
import Then

class CustomCircularProgressBar: UIView {
    
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var trackLineWidth: CGFloat = 10
    var progressLineWidth: CGFloat = 30
    var progressColor: UIColor = .systemYellow
    var trackColor: UIColor = .lightGray
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard progress >= 0 && progress <= 1 else { return }
        
        // 기존의 subview와 sublayer 제거
        self.subviews.forEach { $0.removeFromSuperview() }
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - progressLineWidth / 2
        
        // 트랙 (전체 원)
        let trackStartAngle: CGFloat = -3.75
        let trackEndAngle: CGFloat = 0.60
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: trackStartAngle, endAngle: trackEndAngle, clockwise: true)
        let trackLayer = CAShapeLayer()
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = trackLineWidth
        trackLayer.lineCap = .round
        self.layer.addSublayer(trackLayer)
        
        // 프로그래스 바 (진행 원)
        let progressEndAngle = trackStartAngle + progress * (trackEndAngle - trackStartAngle)
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: trackStartAngle, endAngle: progressEndAngle, clockwise: true)
        let progressLayer = CAShapeLayer()
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = progressLineWidth
        progressLayer.lineCap = .round
        self.layer.addSublayer(progressLayer)
    }
}
