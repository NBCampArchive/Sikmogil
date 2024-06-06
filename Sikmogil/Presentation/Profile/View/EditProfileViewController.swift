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
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "default_profile")
        $0.layer.cornerRadius = 75
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray
        $0.isUserInteractionEnabled = true
    }
    
    let profileLabel = UILabel().then {
        $0.text = "프로필 수정"
        $0.font = Suite.bold.of(size: 24)
        $0.textColor = UIColor(named: "appBlack")
    }
    
    let profileSubLabel = UILabel().then {
        $0.text = "프로필을 새롭게 수정해보세요."
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = UIColor(named: "appDarkGray")
    }
    
    let nicknameView = UIView().then {
        $0.backgroundColor = UIColor(named: "appLightGray")
        $0.layer.cornerRadius = 12
    }
    
    let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = UIColor(named: "appDarkGray")
    }
    
    let nicknameTextField = UITextField().then {
        $0.text = "우주최강고양이"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = UIColor(named: "appBlack")
    }
    
    let heightView = UIView().then {
        $0.backgroundColor = UIColor(named: "appLightGray")
        $0.layer.cornerRadius = 12
    }
    
    let heightLabel = UILabel().then {
        $0.text = "키"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = UIColor(named: "appDarkGray")
    }
    
    let heightTextField = UITextField().then {
        $0.text = "000"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = UIColor(named: "appBlack")
    }
    
    let heightUnitLabel = UILabel().then {
        $0.text = "cm"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = UIColor(named: "appDarkGray")
    }
    
    let weightView = UIView().then {
        $0.backgroundColor = UIColor(named: "appLightGray")
        $0.layer.cornerRadius = 12
    }
    
    let weightLabel = UILabel().then {
        $0.text = "몸무게"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = UIColor(named: "appDarkGray")
    }
    
    let weightTextField = UITextField().then {
        $0.text = "0.0"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = UIColor(named: "appBlack")
    }
    
    let weightUnitLabel = UILabel().then {
        $0.text = "Kg"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = UIColor(named: "appDarkGray")
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(profileLabel)
        contentView.addSubview(profileSubLabel)
        
        contentView.addSubview(nicknameView)
        nicknameView.addSubview(nicknameLabel)
        nicknameView.addSubview(nicknameTextField)
        
        contentView.addSubview(heightView)
        heightView.addSubview(heightLabel)
        heightView.addSubview(heightTextField)
        heightView.addSubview(heightUnitLabel)
        
        contentView.addSubview(weightView)
        weightView.addSubview(weightLabel)
        weightView.addSubview(weightTextField)
        weightView.addSubview(weightUnitLabel)
        
        // Save button should be added to the main view, not the contentView
        view.addSubview(saveButton)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(800) // Set this as needed
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
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
        
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(profileSubLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameView.snp.top).offset(10)
            $0.leading.equalTo(nicknameView.snp.leading).offset(10)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nicknameView.snp.leading).offset(10)
            $0.trailing.equalTo(nicknameView.snp.trailing).offset(-10)
        }
        
        heightView.snp.makeConstraints {
            $0.top.equalTo(nicknameView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(heightView.snp.top).offset(10)
            $0.leading.equalTo(heightView.snp.leading).offset(10)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(5)
            $0.leading.equalTo(heightView.snp.leading).offset(10)
            $0.trailing.equalTo(heightUnitLabel.snp.leading).offset(-10)
        }
        
        heightUnitLabel.snp.makeConstraints {
            $0.centerY.equalTo(heightTextField)
            $0.trailing.equalTo(heightView.snp.trailing).offset(-10)
        }
        
        weightView.snp.makeConstraints {
            $0.top.equalTo(heightView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(weightView.snp.top).offset(10)
            $0.leading.equalTo(weightView.snp.leading).offset(10)
        }
        
        weightTextField.snp.makeConstraints {
            $0.top.equalTo(weightLabel.snp.bottom).offset(5)
            $0.leading.equalTo(weightView.snp.leading).offset(10)
            $0.trailing.equalTo(weightUnitLabel.snp.leading).offset(-50)
        }
        
        weightUnitLabel.snp.makeConstraints {
            $0.centerY.equalTo(weightTextField)
            $0.trailing.equalTo(weightView.snp.trailing).offset(-10)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
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
        print("Save button tapped")
    }
}
