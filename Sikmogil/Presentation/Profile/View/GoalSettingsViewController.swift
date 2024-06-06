//
//  GoalSettingsViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/5/24.
//

import UIKit
import SnapKit
import Then

class GoalSettingsViewController: UIViewController {
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    let contentView = UIView()
    
    let goalSettingLabel = UILabel().then {
        $0.text = "목표 설정"
        $0.font = Suite.bold.of(size: 24)
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = "목표로 하는 체중과 기간을 설정해주세요."
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = UIColor(named: "appDarkGray")
    }
    
    let goalWeightLabel = UILabel().then {
        $0.text = "목표 체중"
        $0.font = Suite.bold.of(size: 16)
    }
    
    let goalWeightTextField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    let goalDateLabel = UILabel().then {
        $0.text = "목표 날짜"
        $0.font = Suite.bold.of(size: 16)
    }
    
    let goalDatePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    let saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.backgroundColor = UIColor(named: "appBlack")
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
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
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(800)
        }
        
        goalSettingLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(goalSettingLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        goalWeightLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        goalWeightTextField.snp.makeConstraints {
            $0.top.equalTo(goalWeightLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        goalDateLabel.snp.makeConstraints {
            $0.top.equalTo(goalWeightTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        goalDatePicker.snp.makeConstraints {
            $0.top.equalTo(goalDateLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
}
