//
//  ReminderSettingsViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/6/24.
//

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
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$reminderTime
            .sink { [weak self] reminderTime in
                self?.timeTextField.text = reminderTime
            }
            .store(in: &cancellables)
        
        timeTextField.addTarget(self, action: #selector(timeTextFieldChanged), for: .editingChanged)
    }
    
    @objc private func timeTextFieldChanged(_ textField: UITextField) {
        viewModel?.reminderTime = textField.text ?? ""
    }
    
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
        guard let viewModel = viewModel else { return }
        
        if viewModel.reminderValidateForm() {
            timeTextFieldWarningLabel.isHidden = true
            viewModel.saveReminderData()
            
            viewModel.submitProfile { [weak self] result in
                switch result {
                case .success:
                    viewModel.debugPrint()
                    print("Profile submitted successfully")
                    self?.showAlertAndNavigateToProfile()
                case .failure(let error):
                    print("Failed to submit profile: \(error)")
                }
            }
        } else {
            view.shake()
            timeTextFieldWarningLabel.isHidden = false
        }
    }
    
    private func showAlertAndNavigateToProfile() {
        let alert = UIAlertController(title: "성공", message: "리마인드 설정이 완료되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigateToProfileViewController()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
