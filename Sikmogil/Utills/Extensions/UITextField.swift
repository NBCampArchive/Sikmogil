//
//  UITextField.swift
//  Sikmogil
//
//  Created by Developer_P on 6/19/24.
//

import Foundation
import Combine
import UIKit
// MARK: - 옵셔널 처리를 간단하게 하기 위해서
extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}
