//
//  WaveProgressView.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/7/24.
//

import UIKit

class WaveProgressView: UIView {
    private var waveLayer = CAShapeLayer()
    private var displayLink: CADisplayLink?
    private var offSet: Double = 0
    private var percent: Double = 0.0
    
    var waveColor: UIColor = .customSkyBlue ?? .systemBlue {
        didSet {
            waveLayer.fillColor = waveColor.cgColor
        }
    }
    
    var progress: Double = 0 {
        didSet {
            percent = progress
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        waveLayer.fillColor = waveColor.cgColor
        layer.addSublayer(waveLayer)
        startWaveAnimation()
    }
    
    private func startWaveAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateWave() {
        offSet += 5
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawWave(in: rect)
    }
    
    private func drawWave(in rect: CGRect) {
        let path = UIBezierPath()
        
        let lowestWave = 0.02
        let highestWave = 1.00
        
        let newPercent = lowestWave + (highestWave - lowestWave) * percent
        let waveHeight = 0.03 * rect.height
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + 360 + 10
        
        path.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet * .pi / 180))))
        
        for angle in stride(from: startAngle, through: endAngle, by: 5) {
            let x = CGFloat((angle - startAngle) / 360) * rect.width
            path.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(angle * .pi / 180))))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()
        
        waveLayer.path = path.cgPath
    }
    
    deinit {
        displayLink?.invalidate()
    }
}
