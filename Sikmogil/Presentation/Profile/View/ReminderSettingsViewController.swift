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
        $0.font = Suite.bold.of(size: 28)
        $0.textColor = .black
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "하루 리마인드 알림을 원하는 시간을 선택해주세요"
        $0.font = Suite.semiBold.of(size: 14)
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
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private let completeButton = UIButton(type: .system).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
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
    
    private func setupAddTargets() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - binding
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        // 뷰모델의 reminderTime과 timeTextField를 바인딩
        viewModel.$reminderTime
            .sink { [weak self] reminderTime in
                self?.timeTextField.text = reminderTime
            }
            .store(in: &cancellables)
        
        // timeTextField의 값이 변경될 때 뷰모델의 reminderTime을 업데이트
        timeTextField.addTarget(self, action: #selector(timeTextFieldChanged), for: .editingChanged)
    }
    
    @objc private func timeTextFieldChanged(_ textField: UITextField) {
        viewModel?.reminderTime = textField.text ?? ""
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
        if viewModel.reminderValidateForm() {
            timeTextFieldWarningLabel.isHidden = true
            viewModel.saveReminderData()
            
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
    
    private func navigateToProfileViewController() {
        if let navigationController = self.navigationController {
            for controller in navigationController.viewControllers {
                if let profileVC = controller as? ProfileViewController {
                    navigationController.popToViewController(profileVC, animated: true)
                    return
                }
            }
        }
    }
}

extension ReminderSettingsViewController: UITextFieldDelegate {
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
