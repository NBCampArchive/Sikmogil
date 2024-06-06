//
//  UIViewExtensions.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/2/24.
//

import UIKit

extension UIView {

    // Adds multiple subviews to the view
    // 사용예시 : view.addSubviews(view1, view2, view3)
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    //MARK: - UI 흔들림 에니메이션 확장
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 3
        shake.autoreverses = true
        let fromPoint = CGPoint(x: self.center.x - 10, y: self.center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: self.center.x + 10, y: self.center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        self.layer.add(shake, forKey: "position")
    }
    
}

extension UIStackView {

    // Adds multiple arranged subviews to the stack view
    // 사용예시 : stackView.addArrangedSubviews(view1, view2, view3)
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
    
}

