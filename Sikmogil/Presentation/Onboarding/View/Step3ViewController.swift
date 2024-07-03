//
//  Step3ViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class Step3ViewController: UIViewController {
    
    var viewModel: OnboardingViewModel?
    
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "알림 설정"
        $0.font = Suite.bold.of(size: 24)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "하루 리마인드 알림을 원하는 시간을 선택해주세요"
        $0.font = Suite.semiBold.of(size: 14)
        $0.textColor = .customDarkGray
    }
    
    private let timePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.locale = Locale(identifier: "ko_KR")
        $0.preferredDatePickerStyle = .wheels
    }
    
    private let timeTextFieldWarningLabel = UILabel().then {
        $0.text = "시간을 입력해주세요"
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private let doneButton = UIButton(type: .system).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.backgroundColor = .customBlack
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupAddTargets()
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
        bindViewModel()
    }
    
    private func setupAddTargets() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.reminderTime
            .subscribe(onNext: { [weak self] time in
                guard let self = self else { return }
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                if let date = formatter.date(from: time) {
                    self.timePicker.date = date
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, timePicker, timeTextFieldWarningLabel)
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
        
        timePicker.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        timeTextFieldWarningLabel.snp.makeConstraints {
            $0.top.equalTo(timePicker.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    @objc private func doneButtonTapped() {
        guard let viewModel = viewModel else { return }
        
        // 처음 회원가입 시 공복 시간 14시간으로 설정
        let defaultTimeString = "14:00"
        UserDefaults.standard.set(defaultTimeString, forKey: "fastingTime")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let selectedTime = formatter.string(from: timePicker.date)
        
        viewModel.reminderTime.accept(selectedTime)
        
        if viewModel.reminderValidateForm() {
            timeTextFieldWarningLabel.isHidden = true
            
            viewModel.saveReminderData()
            
            viewModel.submitProfile { result in
                switch result {
                case .success:
                    print("Profile submitted successfully\(viewModel.debugPrint())")
                    self.registerNotification(time: selectedTime)
                case .failure(let error):
                    print("Failed to submit profile: \(error)")
                    // 에러 처리
                }
            }
        } else {
            view.shake()
            timeTextFieldWarningLabel.isHidden = false
        }
        
    }
    
    private func registerNotification(time: String) {
        let components = time.split(separator: ":").map { Int($0) ?? 0 }
        var dateComponents = DateComponents()
        dateComponents.hour = components[0]
        dateComponents.minute = components[1]
        NotificationHelper.shared.scheduleDailyNotification(at: dateComponents) { error in
            if let error = error {
                print("알림 예약 실패: \(error)")
            } else {
                print("알림 예약 성공")
            }
        }
    }
    
    
}

extension Step3ViewController: UITextFieldDelegate {
    // UITextFieldDelegate 메서드
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            // 숫자 입력만 허용
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            // 현재 텍스트와 입력된 문자열 결합
            var newString = (text as NSString).replacingCharacters(in: range, with: string)
            
            // : 추가 로직
            newString = newString.replacingOccurrences(of: ":", with: "")
            
            if newString.count > 5 {
                return false
            }
            
            if newString.count == 2 {
                newString.insert(":", at: newString.index(newString.startIndex, offsetBy: 2))
            } else if newString.count > 2 {
                newString.insert(":", at: newString.index(newString.startIndex, offsetBy: 2))
            }
            
            // 유효성 검사 (00:00 ~ 23:59)
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
