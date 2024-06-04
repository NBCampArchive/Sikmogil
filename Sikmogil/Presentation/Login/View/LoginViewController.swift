//
//  SigninViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/3/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModelIO = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    private let appleSignInButton = UIButton(type: .system).then {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Sign up with Apple"
        configuration.image = UIImage(systemName: "applelogo")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let title = AttributedString("Sign up with Apple", attributes: AttributeContainer([
            .font: Suite.medium.of(size: 18),
            .foregroundColor: UIColor.black
        ]))
        configuration.attributedTitle = title
        
        $0.configuration = configuration
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customDarkGray?.cgColor
        $0.layer.cornerRadius = 15
    }
    
    private let googleSignInButton = UIButton(type: .system).then {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Sign up with Google"
        configuration.image = UIImage(named: "googleLogo")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let title = AttributedString("Sign up with Google", attributes: AttributeContainer([
            .font: Suite.medium.of(size: 18),
            .foregroundColor: UIColor.black
        ]))
        configuration.attributedTitle = title
        
        $0.configuration = configuration
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customDarkGray?.cgColor
        $0.layer.cornerRadius = 15
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        setupBindings()
    }
    
    private func setupViews() {
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubviews(appleSignInButton, googleSignInButton)
        appleSignInButton.addTarget(self, action: #selector(didTapAppleSignIn), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(didTapGoogleSignIn), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        buttonStackView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(150)
        }
        
        appleSignInButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        googleSignInButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    private func setupBindings() {
        // ViewModel Outputs
        viewModel.loginSuccess
            .subscribe(onNext: {
                print("Login succeeded")
                print("Access Token!!: \(String(describing: LoginAPIManager.shared.keychain.get("accessToken")))")
                self.navigateToOnboarding()
            })
            .disposed(by: disposeBag)
        
        viewModel.loginFailure
            .subscribe(onNext: { error in
                print("Login failed with error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func didTapAppleSignIn() {
        viewModel.signInWithApple()
    }
    
    @objc private func didTapGoogleSignIn() {
        viewModel.signInWithGoogle(presentingViewController: self)
    }
    
    private func navigateToOnboarding() {
        print("로그인 성공, 온보딩 화면으로 이동")
    }
    
}

