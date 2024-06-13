//
//  Extension.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/2/24.
//

import UIKit

// Extension 파일은 폴더로 나누지 않아도 괜찮아요!
// Extension 파일은 해당 클래스의 기능을 확장하는 기능을 담당합니다.

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

// MARK: - Double 값을 Int로 변환, 천 단위로 쉼표를 추가하여 문자열로 반환
extension Double {
    func formattedWithCommas() -> String {
        let intValue = Int(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: intValue)) ?? "\(intValue)"
    }
}
