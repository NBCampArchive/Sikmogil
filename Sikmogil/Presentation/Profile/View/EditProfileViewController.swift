//
//  EditProfileViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/5/24.
//

import UIKit
import SnapKit
import Then

class EditProfileViewController: UIViewController {
    
    // UI Elements
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "default_profile") // Replace with the actual image
        $0.layer.cornerRadius = 50
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    let nicknameTextField = UITextField().then {
        $0.placeholder = "우주최강고양이"
        $0.borderStyle = .roundedRect
    }
    
    let heightLabel = UILabel().then {
        $0.text = "키"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    let heightTextField = UITextField().then {
        $0.placeholder = "000 CM"
        $0.borderStyle = .roundedRect
        $0.keyboardType = .numberPad
    }
    
    let weightLabel = UILabel().then {
        $0.text = "몸무게"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    let weightTextField = UITextField().then {
        $0.placeholder = "0.0 Kg"
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
    }
    
    let saveButton = UIButton(type: .system).then {
        $0.setTitle("저장하기", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "프로필 수정"
        self.view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(heightLabel)
        view.addSubview(heightTextField)
        view.addSubview(weightLabel)
        view.addSubview(weightTextField)
        view.addSubview(saveButton)
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        weightTextField.snp.makeConstraints {
            $0.top.equalTo(weightLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(weightTextField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    @objc func saveButtonTapped() {
        // Save action
        print("Save button tapped")
    }
}
