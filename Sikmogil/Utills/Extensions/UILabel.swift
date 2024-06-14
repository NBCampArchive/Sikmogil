//
//  UILabel.swift
//  Sikmogil
//
//  Created by 정유진 on 6/14/24.
//

import UIKit

// MARK: - 특정 문자열 스타일 변경
extension UILabel {
    func setAttributedText(fullText: String, changeText: String, color: UIColor, font: UIFont) {
        let range = (fullText as NSString).range(of: changeText)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedString.addAttribute(.font, value: font, range: range)
        self.attributedText = attributedString
    }
}
