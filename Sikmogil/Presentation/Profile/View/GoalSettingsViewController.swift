//
//  GoalSettingsViewController.swift
//  Sikmogil
//
//  Created by 박준영 on 6/5/24.
//  [목표설정] 🚩 목표설정 🚩

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GoalSettingsViewController: UIViewController {
    
    var viewModel: OnboardingViewModel?
    
    private let disposeBag = DisposeBag()
    
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
    
    let goalWeightWarningLabel = UILabel().then {
        $0.text = "목표 체중을 입력해주세요"
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .red
        $0.isHidden = true
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
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupAddTargets()
        bindViewModel()
    }
    
    private func setupAddTargets() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - binding
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.targetWeight
            .bind(to: goalWeightTextField.rx.text)
            .disposed(by: disposeBag)
        
        goalWeightTextField.rx.text
            .orEmpty
            .bind(to: viewModel.targetWeight)
            .disposed(by: disposeBag)
        
        goalDatePicker.rx.date
            .bind(to: viewModel.targetDate)
            .disposed(by: disposeBag)
    }
    
    // MARK: - setupViews
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(goalSettingLabel, descriptionLabel, goalWeightLabel, goalWeightTextField, goalWeightWarningLabel, goalDateLabel, goalDatePicker)
        view.addSubview(saveButton)
    }
    
    // MARK: - setupConstraints
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
            viewModel.moveToNextPage()
            showAlertAndNavigateBack()
        } else {
            goalWeightWarningLabel.isHidden = !(goalWeightTextField.text ?? "").isEmpty
            view.shake()
        }
    }
    
    private func showAlertAndNavigateBack() {
        let alert = UIAlertController(title: "성공", message: "목표 설정이 완료되었습니다.", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            alert.dismiss(animated: true) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
