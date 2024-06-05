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

    let goalWeightLabel = UILabel().then {
        $0.text = "목표 체중"
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    let goalWeightTextField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    let goalDateLabel = UILabel().then {
        $0.text = "목표 날짜"
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    let goalDatePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    let saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.backgroundColor = .darkGray
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
        view.addSubview(goalWeightLabel)
        view.addSubview(goalWeightTextField)
        view.addSubview(goalDateLabel)
        view.addSubview(goalDatePicker)
        view.addSubview(saveButton)
    }
    
    func setupConstraints() {
        goalWeightLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
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
            $0.top.equalTo(goalDatePicker.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
}
