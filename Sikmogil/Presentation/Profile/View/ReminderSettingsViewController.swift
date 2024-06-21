//
//  ReminderSettingsViewController.swift
//  Sikmogil
//
//  Created by 박준영 on 6/6/24.
//  [리마인드] ⏰ 리마인드 시간 설정 ⏰

import UIKit
import SnapKit
import Then
import Combine

class ReminderSettingsViewController: UIViewController {
    
    var viewModel: ProfileViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "리마인드 알림 시간 설정"
        $0.font = UIFont.boldSystemFont(ofSize: 28)
        $0.textColor = .black
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "하루 리마인드 알림을 원하는 시간을 선택해주세요"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
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
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private let completeButton = UIButton(type: .system).then {
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
        bindViewModel()
        timeTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupAddTargets() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        timeTextField.addTarget(self, action: #selector(timeTextFieldChanged(_:)), for: .editingChanged)
    }
    
    // MARK: - 리마인드 시간 저장
    private func saveReminderTime(_ time: String) {
        UserDefaults.standard.set(time, forKey: "ReminderTime")
        viewModel?.reminderTime = time
        viewModel?.saveReminderData()
    }
    
    // MARK: - 뷰모델 바인딩
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        // 뷰모델의 reminderTime과 timeTextField를 바인딩
        viewModel.$reminderTime
            .sink { [weak self] reminderTime in
                self?.timeTextField.text = reminderTime
            }
            .store(in: &cancellables)
    }
    
    @objc private func timeTextFieldChanged(_ textField: UITextField) {
        guard let time = textField.text, validateTime(time) else {
            timeTextFieldWarningLabel.isHidden = false
            return
        }
        viewModel?.reminderTime = time
        saveReminderTime(time)
        timeTextFieldWarningLabel.isHidden = true
    }
    
    // MARK: - 알림 업데이트
    private func updateNotification(time: String) {
        let isEnabled = UserDefaults.standard.bool(forKey: "NotificationEnabled")
        if isEnabled {
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
    
    // MARK: - 시간 유효성 검사
    private func validateTime(_ time: String) -> Bool {
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]),
              hours >= 0, hours < 24,
              minutes >= 0, minutes < 60 else {
            return false
        }
        return true
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, timeTextField, timeTextFieldWarningLabel)
        view.addSubview(completeButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(completeButton.snp.top).offset(-16)
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
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func completeButtonTapped() {
        guard let viewModel = viewModel else {
            print("ViewModel is nil")
            return
        }
        
        // timeTextField의 값을 뷰모델에 업데이트
        viewModel.reminderTime = timeTextField.text ?? ""
        
        // 유효성 검사 후 저장 및 프로필 업데이트
        if validateTime(viewModel.reminderTime) {
            timeTextFieldWarningLabel.isHidden = true
            viewModel.saveReminderData()
            saveReminderTime(viewModel.reminderTime) // Save to UserDefaults before updating notification
            updateNotification(time: viewModel.reminderTime) // 알림 업데이트
            
            // 데이터를 저장하는 부분 (submitProfile 호출)
            viewModel.submitProfile { [weak self] result in
                switch result {
                case .success:
                    viewModel.debugPrint()
                    self?.showAlertAndNavigateToProfile()
                case .failure(let error):
                    self?.showErrorAlert(error: error)
                }
            }
        } else {
            view.shake()
            timeTextFieldWarningLabel.isHidden = false
        }
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "에러", message: "프로필 업데이트 실패: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertAndNavigateToProfile() {
        let alert = UIAlertController(title: "성공", message: "리마인드 설정이 완료되었습니다.", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            alert.dismiss(animated: true) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension ReminderSettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
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
            if newString.count > 4 {
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
