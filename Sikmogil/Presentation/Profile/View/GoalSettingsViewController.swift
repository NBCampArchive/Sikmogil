//
//  GoalSettingsViewController.swift
//  Sikmogil
//
//  Created by 박준영 on 6/5/24.
//  [목표설정] 🚩 목표설정 🚩

import UIKit
import SnapKit
import Then
import Combine

class GoalSettingsViewController: UIViewController {
    
    var viewModel: ProfileViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    private let contentView = UIView()
    
    private let goalSettingLabel = UILabel().then {
        $0.text = "목표 설정"
        $0.font = Suite.bold.of(size: 24)
        $0.textColor = .appBlack
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "목표로 하는 체중과 기간을 설정해주세요."
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    private let goalWeightLabel = UILabel().then {
        $0.text = "목표 체중"
        $0.font = Suite.bold.of(size: 16)
        $0.textColor = .appBlack
    }
    
    private let goalWeightTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .numberPad
    }
    
    private let goalWeightWarningLabel = UILabel().then {
        $0.text = "목표 체중을 입력해주세요"
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private let goalDateLabel = UILabel().then {
        $0.text = "목표 날짜"
        $0.font = Suite.bold.of(size: 16)
        $0.textColor = .appBlack
    }
    
    private let goalDatePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .inline
        $0.locale = Locale(identifier: "ko_KR")
        $0.minimumDate = Date()
        $0.tintColor = .appBlack
    }
    
    private let saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
        $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private var targetDate = ""
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        bindViewModel()
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        // Bind goalWeightTextField
        viewModel.$targetWeight
            .sink { [weak self] text in
                self?.goalWeightTextField.text = text
            }
            .store(in: &cancellables)
        
        goalWeightTextField.addTarget(self, action: #selector(goalWeightTextFieldDidChange), for: .editingChanged)
        
        // Bind goalDatePicker
        let targetDateString = viewModel.userProfile.targetDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        if let targetDate = dateFormatter.date(from: targetDateString) {
            goalDatePicker.date = targetDate
            viewModel.targetDate = targetDate
        }
        
        goalDatePicker.addTarget(self, action: #selector(goalDatePickerDidChange), for: .valueChanged)
    }
    
    @objc private func goalWeightTextFieldDidChange(_ textField: UITextField) {
        viewModel?.targetWeight = textField.text ?? ""
    }
    
    @objc private func goalDatePickerDidChange(_ datePicker: UIDatePicker) {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        if datePicker.date > now {
            viewModel?.targetDate = datePicker.date
        } else {
            let alert = UIAlertController(title: "알림", message: "오늘 이후의 날짜를 선택해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            if let targetDateString = viewModel?.userProfile.targetDate,
               let targetDate = dateFormatter.date(from: targetDateString) {
                goalDatePicker.date = targetDate
                viewModel?.targetDate = targetDate
            }
        }
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(goalSettingLabel, descriptionLabel, goalWeightLabel, goalWeightTextField, goalWeightWarningLabel, goalDateLabel, goalDatePicker)
        view.addSubview(saveButton)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(saveButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        goalSettingLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(goalSettingLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(16)
        }
        
        goalWeightLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        goalWeightTextField.snp.makeConstraints {
            $0.top.equalTo(goalWeightLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        goalWeightWarningLabel.snp.makeConstraints {
            $0.top.equalTo(goalWeightTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        goalDateLabel.snp.makeConstraints {
            $0.top.equalTo(goalWeightTextField.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        goalDatePicker.snp.makeConstraints {
            $0.top.equalTo(goalDateLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    @objc private func saveButtonTapped() {
        guard let viewModel = viewModel else { return }
        
        if viewModel.targetValidateForm() {
            viewModel.saveTargetData()
            viewModel.submitProfile { [weak self] result in
                switch result {
                case .success:
                    self?.showAlertAndNavigateBack()
                    print("목표 설정이 성공적으로 저장되었습니다.")
                case .failure(let error):
                    self?.showError(error)
                    print("목표 설정 저장 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //    @objc private func saveButtonTapped() {
    //        guard let viewModel = viewModel else { return }
    //
    //        if viewModel.targetValidateForm() {
    //            viewModel.saveTargetData()
    //            viewModel.submitProfile { [weak self] result in
    //                switch result {
    //                case .success:
    //                    self?.showCustomAlertAndNavigateBack()
    //                    print("목표 설정이 성공적으로 저장되었습니다.")
    //                case .failure(let error):
    //                    self?.showCustomErrorAlert(error)
    //                    print("목표 설정 저장 실패: \(error.localizedDescription)")
    //                }
    //            }
    //        }
    //    }
    
    //    private func showCustomAlertAndNavigateBack(showConfirmButton: Bool = true, showCancelButton: Bool = true) {
    //        let customAlert = CustomAlertView().then {
    //            $0.setTitle("✨ 성공 ✨")
    //            $0.setMessage("목표 설정이 완료되었습니다.")
    //            $0.setCancelAction(self, action: #selector(dismissCustomAlert))
    //            $0.setConfirmAction(self, action: #selector(dismissCustomAlert))
    //            $0.showButtons(confirm: showConfirmButton, cancel: showCancelButton)
    //        }
    //
    //        customAlert.frame = self.view.bounds
    //        self.view.addSubview(customAlert)
    //
    //        customAlert.show(animated: true)
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
    //            if !showConfirmButton && !showCancelButton {
    //                customAlert.removeFromSuperview()
    //                self?.navigationController?.popViewController(animated: true)
    //            }
    //        }
    //    }
    
    //    private func showCustomErrorAlert(_ error: Error) {
    //        let customAlert = CustomAlertView().then {
    //            $0.setTitle("에러")
    //            $0.setMessage(error.localizedDescription)
    //            $0.setConfirmAction(self, action: #selector(dismissCustomAlert))
    //            $0.showButtons(confirm: true, cancel: false)
    //        }
    //        customAlert.frame = self.view.bounds
    //        self.view.addSubview(customAlert)
    //
    //        customAlert.show(animated: true)
    //    }
    
    //    @objc private func dismissCustomAlert() {
    //        if let customAlert = view.subviews.first(where: { $0 is CustomAlertView }) {
    //            customAlert.removeFromSuperview()
    //            navigationController?.popViewController(animated: true)
    //        }
    //    }
    
    private func showAlertAndNavigateBack() {
        let alert = UIAlertController(title: "성공", message: "목표 설정이 완료되었습니다.", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            alert.dismiss(animated: true) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "에러", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
