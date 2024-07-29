//
//  UIViewControllerExtension.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/6/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: - 텍스트필드 키보드 관련 확장
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            
            if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
            } else {
                // 스크롤 뷰가 아닌 경우 뷰의 위치 조정
                let bottomPadding = view.safeAreaInsets.bottom
                view.frame.origin.y = 0 - (keyboardHeight - bottomPadding)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        } else {
            // 스크롤 뷰가 아닌 경우 뷰의 위치 원상복귀
            view.frame.origin.y = 0
        }
    }
    
    //MARK: - 탭바 관련 확장
//    func setTabBar(hidden: Bool, animated: Bool) {
//        guard let tabBar = self.tabBarController?.tabBar else { return }
//        tabBar.changeTabBar(hidden: hidden, animated: animated)
//    }
    
    //MARK: - 키보드 완료 버튼
    func addDoneButtonToKeyboard(textFields: [UITextField]) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        for textField in textFields {
            textField.inputAccessoryView = toolbar
        }
    }
}
