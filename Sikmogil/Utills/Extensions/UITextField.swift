//
//  UITextField.swift
//  Sikmogil
//
//  Created by 박준영 on 6/19/24.
//  [extension] **설명** UI텍스트 필드의 옵셔널 처리를 간단하게 하기 위해서

import Foundation
import Combine
import UIKit

extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}
