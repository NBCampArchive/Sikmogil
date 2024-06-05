//
//  Step1ViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import UIKit
import SnapKit
import Then

class Step1ViewController: UIViewController {
    
    var viewModel: OnboardingViewModel?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "프로필 설정"
        $0.font = Suite.bold.of(size: 28)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "프로필에 들어갈 닉네임, 키, 몸무게를 입력하세요"
        $0.font =  Suite.semiBold.of(size: 14)
        $0.textColor = .customDarkGray
    }
    
    private let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = Suite.medium.of(size: 20)
    }
    
    private let nicknameTextField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    private let heightLabel = UILabel().then {
        $0.text = "키"
        $0.font = Suite.medium.of(size: 20)
    }
    
    private let heightTextField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    private let weightLabel = UILabel().then {
        $0.text = "몸무게"
        $0.font = Suite.medium.of(size: 20)
    }
    
    private let weightTextField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    
    private let genderLabel = UILabel().then {
        $0.text = "성별"
        $0.font = Suite.medium.of(size: 20)
    }
    
    private let genderButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
    }
    
    private let maleButton = UIButton(type: .custom).then {
        $0.setTitle("남자", for: .normal)
        $0.setTitleColor(.customDarkGray, for: .normal)
        $0.titleLabel?.font = Suite.regular.of(size: 17)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customDarkGray?.cgColor
        $0.layer.cornerRadius = 8
    }
    
    private let femaleButton = UIButton(type: .custom).then {
        $0.setTitle("여자", for: .normal)
        $0.setTitleColor(.customDarkGray, for: .normal)
        $0.titleLabel?.font = Suite.regular.of(size: 17)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customDarkGray?.cgColor
        $0.layer.cornerRadius = 8
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
        setupAddTarget()
    }
    
    private func setupAddTarget() {
        maleButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, nicknameLabel, nicknameTextField, heightLabel, heightTextField, weightLabel, weightTextField, genderLabel, genderButtonStackView)
        genderButtonStackView.addArrangedSubviews(maleButton, femaleButton)
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
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        weightTextField.snp.makeConstraints {
            $0.top.equalTo(weightLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(weightTextField.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        genderButtonStackView.snp.makeConstraints {
            $0.top.equalTo(genderLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func maleButtonTapped() {
        maleButton.isSelected = true
        femaleButton.isSelected = false
        updateGenderButtons()
    }
    
    @objc private func femaleButtonTapped() {
        maleButton.isSelected = false
        femaleButton.isSelected = true
        updateGenderButtons()
    }
    
    private func updateGenderButtons() {
        if maleButton.isSelected {
            maleButton.setTitleColor(.black, for: .normal)
            maleButton.layer.borderColor = UIColor.black.cgColor
            femaleButton.setTitleColor(.lightGray, for: .normal)
            femaleButton.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            maleButton.setTitleColor(.lightGray, for: .normal)
            maleButton.layer.borderColor = UIColor.lightGray.cgColor
            femaleButton.setTitleColor(.black, for: .normal)
            femaleButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    
    @objc private func nextButtonTapped() {
        print("Next button tapped")
            guard let viewModel = viewModel else {
                print("ViewModel is nil")
                return
            }
        viewModel.saveProfileData(nickname: nicknameTextField.text ?? "",
                                  height: heightTextField.text ?? "",
                                  weight: weightTextField.text ?? "",
                                  gender: maleButton.isSelected ? "남자" : "여자")
        
        viewModel.moveToNextPage()
    }
    
}
