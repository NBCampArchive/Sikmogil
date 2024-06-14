//
//  Double.swift
//  Sikmogil
//
//  Created by 정유진 on 6/14/24.
//

import Foundation

// MARK: - Double 값을 Int로 변환, 천 단위로 쉼표를 추가하여 문자열로 반환
extension Double {
    func formattedWithCommas() -> String {
        let intValue = Int(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: intValue)) ?? "\(intValue)"
    }
}
