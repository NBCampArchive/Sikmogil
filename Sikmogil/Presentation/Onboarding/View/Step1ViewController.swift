//
//  Step1ViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class Step1ViewController: UIViewController {
    
    var viewModel: OnboardingViewModel?
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "프로필 설정"
        $0.font = Suite.bold.of(size: 24)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "프로필에 들어갈 닉네임, 키, 몸무게를 입력하세요"
        $0.font =  Suite.semiBold.of(size: 14)
        $0.textColor = .customDarkGray
    }
    
    private let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = Suite.medium.of(size: 16)
    }
    
    private let nicknameTextField = UITextField().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.layer.borderWidth = 1
        $0.addLeftPadding()
    }
    
    private let nicknameWarningLabel = UILabel().then {
        $0.text = "닉네임을 입력해주세요"
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private let heightLabel = UILabel().then {
        $0.text = "키"
        $0.font = Suite.medium.of(size: 16)
    }
    
    private let heightTextField = UITextField().then {
        $0.keyboardType = .decimalPad
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.layer.borderWidth = 1
        $0.addLeftPadding()
    }
    
    private let heightWarningLabel = UILabel().then {
        $0.text = "키를 입력해주세요"
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private let weightLabel = UILabel().then {
        $0.text = "몸무게"
        $0.font = Suite.medium.of(size: 16)
    }
    
    private let weightTextField = UITextField().then {
        $0.keyboardType = .decimalPad
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.layer.borderWidth = 1
        $0.addLeftPadding()
    }
    
    private let weightWarningLabel = UILabel().then {
        $0.text = "몸무게를 입력해주세요"
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private let genderLabel = UILabel().then {
        $0.text = "성별"
        $0.font = Suite.medium.of(size: 16)
    }
    
    private let genderWarningLabel = UILabel().then {
        $0.text = "성별을 선택해주세요"
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .red
        $0.isHidden = true
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
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.backgroundColor = .customBlack
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupAddTarget()
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
        bindViewModel()
        
        // 텍스트 필드 델리게이트 설정
        heightTextField.delegate = self
        weightTextField.delegate = self
    }
    
    private func setupAddTarget() {
        maleButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        nicknameTextField.rx.text.orEmpty
            .bind(to: viewModel.nickname)
            .disposed(by: disposeBag)
        
        heightTextField.rx.text.orEmpty
            .bind(to: viewModel.height)
            .disposed(by: disposeBag)
        
        weightTextField.rx.text.orEmpty
            .bind(to: viewModel.weight)
            .disposed(by: disposeBag)
        
        Observable.merge(
            maleButton.rx.tap.map { "남자" },
            femaleButton.rx.tap.map { "여자" }
        )
        .bind(to: viewModel.gender)
        .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(message: message)
                if message.contains("중복된 닉네임") {
                    self?.updateTextFieldBorders(isValid: false, textField: self?.nicknameTextField ?? UITextField())
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, nicknameLabel, nicknameTextField, nicknameWarningLabel, heightLabel, heightTextField, heightWarningLabel, weightLabel, weightTextField, weightWarningLabel, genderLabel, genderButtonStackView, genderWarningLabel)
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
        
        nicknameWarningLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameWarningLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        heightTextField.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        heightWarningLabel.snp.makeConstraints {
            $0.top.equalTo(heightTextField.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(heightWarningLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        weightTextField.snp.makeConstraints {
            $0.top.equalTo(weightLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        weightWarningLabel.snp.makeConstraints {
            $0.top.equalTo(weightTextField.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
        }
        
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(weightWarningLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        genderButtonStackView.snp.makeConstraints {
            $0.top.equalTo(genderLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
        genderWarningLabel.snp.makeConstraints {
            $0.top.equalTo(genderButtonStackView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
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
        
        if viewModel.profileValidateForm() {
            viewModel.checkNicknameAndProceed()
        } else {
            updateTextFieldBorders(isValid: !viewModel.nickname.value.isEmpty, textField: nicknameTextField)
            updateTextFieldBorders(isValid: !viewModel.height.value.isEmpty, textField: heightTextField)
            updateTextFieldBorders(isValid: !viewModel.weight.value.isEmpty, textField: weightTextField)
            
            nicknameWarningLabel.isHidden = !viewModel.nickname.value.isEmpty
            heightWarningLabel.isHidden = !viewModel.height.value.isEmpty
            weightWarningLabel.isHidden = !viewModel.weight.value.isEmpty
            genderWarningLabel.isHidden = !viewModel.gender.value.isEmpty
            
            view.shake()
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "중복 닉네임❗️", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func updateTextFieldBorders(isValid: Bool, textField: UITextField) {
        if isValid {
            textField.layer.cornerRadius = 8
            textField.layer.borderColor = UIColor.appDarkGray.cgColor
            textField.layer.borderWidth = 1
        } else {
            textField.layer.cornerRadius = 8
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1
        }
    }
    
}

extension Step1ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case nicknameTextField:
            let allowedCharacters = CharacterSet.alphanumerics
            let characterSet = CharacterSet(charactersIn: string)
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            return allowedCharacters.isSuperset(of: characterSet) && newLength <= 10
        case heightTextField, weightTextField:
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // 소수점이 두 번 이상 입력되지 않도록 제한
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            let decimalCount = prospectiveText.components(separatedBy: decimalSeparator).count - 1
            if decimalCount > 1 {
                return false
            }
            
            // 자연수 3자리와 소수점 이하 1자리까지 허용
            let components = prospectiveText.components(separatedBy: decimalSeparator)
            if components.count == 1 {
                // 소수점이 없는 경우
                return components[0].count <= 3
            } else if components.count == 2 {
                // 소수점이 있는 경우
                let integerPart = components[0]
                let fractionPart = components[1]
                return integerPart.count <= 3 && fractionPart.count <= 1
            } else {
                return false
            }
        default:
            return true
        }
    }
}
