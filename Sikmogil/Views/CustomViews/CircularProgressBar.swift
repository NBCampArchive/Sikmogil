//
//  CircularProgressBar.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/2/24.
//

import UIKit
import SnapKit
import Then

class CircularProgressBar: UIView {

    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    var trackLineWidth: CGFloat = 10
    var progressLineWidth: CGFloat = 30
    var progressColor: UIColor = .systemBlue
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
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let trackLayer = CAShapeLayer()
        trackLayer.path = trackPath.cgPath
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = trackLineWidth
        self.layer.addSublayer(trackLayer)

        // 프로그래스 바 (진행 원)
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + progress * 2 * CGFloat.pi
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let progressLayer = CAShapeLayer()
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = progressLineWidth
        progressLayer.lineCap = .round
        self.layer.addSublayer(progressLayer)
    }
}
