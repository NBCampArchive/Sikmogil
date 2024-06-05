//
//  Step2ViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import UIKit
import SnapKit
import Then

class Step2ViewController: UIViewController {
    
    var viewModel: OnboardingViewModel?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "목표 설정"
        $0.font = Suite.bold.of(size: 28)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "목표로 하는 체중과 기간을 설정해주세요"
        $0.font =  Suite.semiBold.of(size: 14)
        $0.textColor = .customDarkGray
    }
    
    private let targetWeightLabel = UILabel().then {
        $0.text = "목표 체중"
        $0.font = Suite.medium.of(size: 20)
    }
    
    private let targetWeightTextField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    private let targetDateLabel = UILabel().then {
        $0.text = "목표 날짜"
        $0.font = Suite.medium.of(size: 20)
    }
    
    private let targetDatePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko_KR")
        $0.preferredDatePickerStyle = .wheels
    }
    
    private let nextButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.backgroundColor = .customBlack
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupAddTargets()
    }
    
    private func setupAddTargets() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, targetWeightLabel, targetWeightTextField, targetDateLabel, targetDatePicker)
        view.addSubview(nextButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        targetWeightLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        targetWeightTextField.snp.makeConstraints {
            $0.top.equalTo(targetWeightLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        targetDateLabel.snp.makeConstraints {
            $0.top.equalTo(targetWeightTextField.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        targetDatePicker.snp.makeConstraints {
            $0.top.equalTo(targetDateLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(200)
            $0.bottom.equalToSuperview().offset(-16)
        }
    
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func nextButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.saveTargetData(targetWeight: targetWeightTextField.text ?? "", targetDate: DateHelper.shared.formatDateToYearMonthDay(targetDatePicker.date))
        
        viewModel.moveToNextPage()
    }
}
