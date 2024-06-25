//
//  Font.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/3/24.
//

import UIKit

/// 폰트를 사용할 때는 아래와 같이 사용해주세요.
/// let font = Suite.bold.of(size: 16)
enum Suite: String{
    case heavy = "SUITE-Heavy"
    case extraBold = "SUITE-ExtraBold"
    case bold = "SUITE-Bold"
    case semiBold = "SUITE-SemiBold"
    case medium = "SUITE-Medium"
    case regular = "SUITE-Regular"
    case light = "SUITE-Light"
    
    func of(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            fatalError("Failed to load font: \(self.rawValue)")
        }
        return font
    }
}

enum BagelFatOne: String {
    case regular = "BagelFatOne-Regular"
    
    func of(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            fatalError("Failed to load font: \(self.rawValue)")
        }
        return font
    }
}
