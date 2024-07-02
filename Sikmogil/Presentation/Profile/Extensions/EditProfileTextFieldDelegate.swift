//
//  EditProfileTextFieldDelegate.swift
//  Sikmogil
//
//  Created by 박준영 on 7/2/24.
//  [extension] **설명** EditProfileViewController text제한 Delegate

import UIKit

extension EditProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case nickname:
            // 특수 문자 제거
            let allowedCharacters = CharacterSet.alphanumerics
            let characterSet = CharacterSet(charactersIn: string)
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            return allowedCharacters.isSuperset(of: characterSet) && newLength <= 10
        case height, weight:
            // 숫자만 입력 가능
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            // 0에서 999 범위 확인
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            if prospectiveText.isEmpty {
                return true
            }
            if let value = Int(prospectiveText), value >= 0 && value <= 999 {
                return true
            } else {
                return false
            }
            
        default:
            return true
        }
    }
}
