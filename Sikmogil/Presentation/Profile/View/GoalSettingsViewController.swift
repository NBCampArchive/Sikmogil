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
    
    // UI Elements
    let goalLabel = UILabel().then {
        $0.text = "목표 설정"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = "목표로 하는 체중과 기간을 설정해주세요"
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .gray
    }
    
    let weightTextField = UITextField().then {
        $0.placeholder = "목표 체중"
        $0.borderStyle = .roundedRect
    }
    
    let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko_KR")
        $0.minimumDate = Date()
    }
    
    let saveButton = UIButton(type: .system).then {
        $0.setTitle("저장하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        // Add subviews
        view.addSubview(goalLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(weightTextField)
        view.addSubview(datePicker)
        view.addSubview(saveButton)
        
        // Set constraints using SnapKit
        goalLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        weightTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.left.right.equalTo(view).inset(16)
            $0.height.equalTo(44)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(weightTextField.snp.bottom).offset(16)
            $0.left.right.equalTo(view).inset(16)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(16)
            $0.left.right.equalTo(view).inset(16)
            $0.height.equalTo(50)
        }
    }
}
