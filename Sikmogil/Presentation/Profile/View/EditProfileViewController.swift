//
//  EditProfileViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/5/24.
//

import UIKit
import SnapKit
import Then

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // UI Elements
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "default_profile") // Replace with the actual image
        $0.layer.cornerRadius = 75
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray // Placeholder background color
        $0.isUserInteractionEnabled = true
    }
    
    let profileLabel = UILabel().then {
        $0.text = "프로필 수정"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .black
    }
    
    let profileSubLabel = UILabel().then {
        $0.text = "프로필을 새롭게 수정해보세요."
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    let nicknameTextField = UITextField().then {
        $0.text = "우주최강고양이"
        $0.backgroundColor = UIColor(named: "appDarkGray")
        $0.layer.cornerRadius = 12
    }
    
    let heightLabel = UILabel().then {
        $0.text = "키"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    let heightTextField = UITextField().then {
        $0.text = "000 CM"
        $0.backgroundColor = UIColor(named: "appDarkGray")
        $0.layer.cornerRadius = 12
    }
    
    let weightLabel = UILabel().then {
        $0.text = "몸무게"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    let weightTextField = UITextField().then {
        $0.text = "0.0 Kg"
        $0.backgroundColor = UIColor(named: "appDarkGray")
        $0.layer.cornerRadius = 12
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
        
        self.view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(profileLabel)
        view.addSubview(profileSubLabel)
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
            $0.width.height.equalTo(150)
        }
        
        profileLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        profileSubLabel.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(16)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileSubLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        weightTextField.snp.makeConstraints {
            $0.top.equalTo(weightLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(weightTextField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    @objc func profileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        // Save action
        print("Save button tapped")
    }
}
