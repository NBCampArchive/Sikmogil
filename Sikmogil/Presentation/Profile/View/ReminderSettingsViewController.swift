//
//  ReminderSettingsViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/6/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ReminderSettingsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let notificationHelper = NotificationHelper.shared
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel().then {
        $0.text = "리마인드 알림 시간 설정"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "하루 리마인드 알림을 원하는 시간을 선택해주세요"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    private let timeTextField = UITextField().then {
        $0.placeholder = "12:00"
        $0.font = UIFont.systemFont(ofSize: 48, weight: .medium)
        $0.textColor = .lightGray
        $0.textAlignment = .center
        $0.keyboardType = .numberPad
        $0.borderStyle = .none
    }
    
    private let timeTextFieldWarningLabel = UILabel().then {
        $0.text = "시간을 입력해주세요"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private let doneButton = UIButton(type: .system).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupAddTargets()
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
        timeTextField.delegate = self
    }
    
    private func setupAddTargets() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, timeTextField, timeTextFieldWarningLabel)
        view.addSubview(doneButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(doneButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        timeTextField.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        timeTextFieldWarningLabel.snp.makeConstraints {
            $0.top.equalTo(timeTextField.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func doneButtonTapped() {
        guard let timeText = timeTextField.text, !timeText.isEmpty else {
            timeTextFieldWarningLabel.isHidden = false
            return
        }
        
        let timeComponents = timeText.split(separator: ":")
        guard timeComponents.count == 2,
              let hours = Int(timeComponents[0]),
              let minutes = Int(timeComponents[1]),
              hours >= 0, hours < 24,
              minutes >= 0, minutes < 60 else {
            timeTextFieldWarningLabel.isHidden = false
            return
        }
        
        timeTextFieldWarningLabel.isHidden = true
        
        // 알림 스케줄링
        var dateComponents = DateComponents()
        dateComponents.hour = hours
        dateComponents.minute = minutes
        
        notificationHelper.scheduleDailyNotification(at: dateComponents) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
                self.showAlert(title: "오류", message: "알림 설정에 실패했습니다.")
            } else {
                print("Notification scheduled successfully for \(hours):\(minutes)")
                self.showAlert(title: "성공", message: "알림이 설정되었습니다.") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
}

extension ReminderSettingsViewController: UITextFieldDelegate {
    // UITextFieldDelegate 메서드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            var newString = (text as NSString).replacingCharacters(in: range, with: string)
            newString = newString.replacingOccurrences(of: ":", with: "")
            
            if newString.count > 4 {
                return false
            }
            
            if newString.count == 2 {
                newString.insert(":", at: newString.index(newString.startIndex, offsetBy: 2))
            } else if newString.count > 2 {
                newString.insert(":", at: newString.index(newString.startIndex, offsetBy: 2))
            }
            
            if newString.count == 5 {
                let components = newString.split(separator: ":")
                if let hours = Int(components[0]), let minutes = Int(components[1]) {
                    if hours > 23 || minutes > 59 {
                        return false
                    }
                }
            }
            textField.text = newString
            return false
        }
        return true
    }
}
