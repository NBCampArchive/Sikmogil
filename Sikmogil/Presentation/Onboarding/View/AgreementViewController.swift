//
//  AgreementViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/20/24.
//

import UIKit
import SnapKit
import Then

class AgreementViewController: UIViewController {
    
    //MARK: - UI Components
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let welcomeLabel = UILabel().then {
        $0.text = "식목일 어쩌고\n환영합니다!"
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = Suite.bold.of(size: 24)
    }
    
    private let agreementPrivacyCheckBox = CheckBox(title: "개인정보 수집 및 이용동의(필수)")
    
    private let detailButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        config.baseForegroundColor = .appDarkGray
        $0.configuration = config
    }
    
    private let proceedButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
        addTarget()
    }
    
    private func addTarget() {
        proceedButton.addTarget(self, action: #selector(proceedButtonTapped), for: .touchUpInside)
        detailButton.addTarget(self, action: #selector(navigationDetail), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubviews(logoImageView, welcomeLabel, agreementPrivacyCheckBox, detailButton, proceedButton)
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        agreementPrivacyCheckBox.snp.makeConstraints {
            $0.bottom.equalTo(proceedButton.snp.top).offset(-32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        detailButton.snp.makeConstraints {
            $0.centerY.equalTo(agreementPrivacyCheckBox)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        proceedButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func proceedButtonTapped() {
        if agreementPrivacyCheckBox.isChecked() {
            print("동의")
            //TODO: - Navigation Onboarding
            navigationController?.pushViewController(OnboardingViewController(), animated: true)
        } else {
            print("동의해주세요")
            view.shake()
            
            let alert = UIAlertController(title: "알림", message: "개인정보 수집 및 이용에 동의해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
    
    private func setupBindings() {
        agreementPrivacyCheckBox.didToggleCheckBox = { [weak self] isChecked in
            self?.proceedButton.backgroundColor = isChecked ? .appBlack : .appLightGray
        }
    }
    
    @objc private func navigationDetail() {
        print("navigationDetail")
        let privacyPolicyVC = PrivacyPolicyViewController()
        privacyPolicyVC.onAgree = { [weak self] in
            self?.agreementPrivacyCheckBox.setChecked(true)
            self?.proceedButton.backgroundColor = .appBlack
            self?.proceedButton.isEnabled = true
        }
        self.present(privacyPolicyVC, animated: true)
    }
}

// CheckBox Custom View
class CheckBox: UIView {
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let checkBoxButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "square")
        config.baseForegroundColor = .appDarkGray
        config.imagePadding = 8
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24)
        $0.configuration = config
    }
    
    var didToggleCheckBox: ((Bool) -> Void)?
    
    init(title: String) {
        super.init(frame: .zero)
        setup(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(title: String) {
        titleLabel.text = title
        
        checkBoxButton.addTarget(self, action: #selector(toggleCheckBox), for: .touchUpInside)
        
        addSubviews(checkBoxButton, titleLabel)
        
        checkBoxButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBoxButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(checkBoxButton)
        }
        
    }
    
    @objc private func toggleCheckBox() {
        checkBoxButton.isSelected.toggle()
        updateCheckBoxImage()
        didToggleCheckBox?(checkBoxButton.isSelected)
    }
    
    private func updateCheckBoxImage() {
        var config = checkBoxButton.configuration
        config?.image = checkBoxButton.isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        checkBoxButton.configuration = config
    }
    
    func isChecked() -> Bool {
        return checkBoxButton.isSelected
    }
    
    func setChecked(_ checked: Bool) {
        checkBoxButton.isSelected = checked
        updateCheckBoxImage()
    }
}

