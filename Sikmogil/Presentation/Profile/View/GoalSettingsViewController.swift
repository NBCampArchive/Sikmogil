//
//  GoalSettingsViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/5/24.
//

import UIKit
import SnapKit
import Then
import Combine

class GoalSettingsViewController: UIViewController {
    
    // MARK: - 속성 정의
    var viewModel: ProfileViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    let contentView = UIView()
    
    let goalSettingLabel = UILabel().then {
        $0.text = "목표 설정"
        $0.font = Suite.bold.of(size: 24)
        $0.textColor = .appBlack
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = "목표로 하는 체중과 기간을 설정해주세요."
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    let goalWeightLabel = UILabel().then {
        $0.text = "목표 체중"
        $0.font = Suite.bold.of(size: 16)
        $0.textColor = .appBlack
    }
    
    let goalWeightTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .numberPad
    }
    
    let goalDateLabel = UILabel().then {
        $0.text = "목표 날짜"
        $0.font = Suite.bold.of(size: 16)
        $0.textColor = .appBlack
    }
    
    let goalDatePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    let saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.backgroundColor = .appBlack
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    // MARK: - 생명 주기
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        bindViewModel()
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - 뷰 모델 바인딩
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$targetWeight
            .sink { [weak self] targetWeight in
                self?.goalWeightTextField.text = targetWeight
            }
            .store(in: &cancellables)
        
        viewModel.$targetDate
            .sink { [weak self] targetDate in
                self?.goalDatePicker.date = targetDate
            }
            .store(in: &cancellables)
        
        goalWeightTextField.addTarget(self, action: #selector(goalWeightTextFieldChanged), for: .editingChanged)
        goalDatePicker.addTarget(self, action: #selector(goalDatePickerChanged), for: .valueChanged)
    }
    
    @objc private func goalWeightTextFieldChanged(_ textField: UITextField) {
        viewModel?.targetWeight = textField.text ?? ""
    }
    
    @objc private func goalDatePickerChanged(_ datePicker: UIDatePicker) {
        viewModel?.targetDate = datePicker.date
    }
    
    // MARK: - 제약 조건 설정
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(goalSettingLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(goalWeightLabel)
        contentView.addSubview(goalWeightTextField)
        contentView.addSubview(goalDateLabel)
        contentView.addSubview(goalDatePicker)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(goalSettingLabel, descriptionLabel, goalWeightLabel, goalWeightTextField, goalDateLabel, goalDatePicker)
        view.addSubview(saveButton)
        
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
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(goalSettingLabel.snp.bottom).offset(4)
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
        
        goalDateLabel.snp.makeConstraints {
            $0.top.equalTo(goalWeightTextField.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        goalDatePicker.snp.makeConstraints {
            $0.top.equalTo(goalDateLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(200)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func saveButtonTapped() {
        guard let viewModel = viewModel else { return }
        
        if viewModel.targetValidateForm() {
            viewModel.saveTargetData()
            navigationController?.popViewController(animated: true)
        } else {
            // 유효성 검사를 통과하지 못한 경우 경고 표시 등을 추가하세요
            print("목표 체중과 날짜를 모두 입력해주세요.")
        }
    }
}
