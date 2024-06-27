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
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "backgroundImage")
        $0.contentMode = .scaleAspectFill
    }
    
    private let appleSignInButton = UIButton(type: .system).then {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Sign up with Apple"
        configuration.image = UIImage(systemName: "applelogo")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10
        configuration.background.backgroundColor = .white
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .large
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let title = AttributedString("Sign up with Apple", attributes: AttributeContainer([
            .font: Suite.medium.of(size: 18),
            .foregroundColor: UIColor.black
        ]))
        configuration.attributedTitle = title
        
        $0.configuration = configuration
    }
    
    private let googleSignInButton = UIButton(type: .system).then {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Sign up with Google"
        configuration.image = UIImage(named: "googleLogo")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10
        configuration.background.backgroundColor = .white
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .large
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let title = AttributedString("Sign up with Google", attributes: AttributeContainer([
            .font: Suite.medium.of(size: 18),
            .foregroundColor: UIColor.black
        ]))
        configuration.attributedTitle = title
        
        $0.configuration = configuration
    }
    
    private let logoLabel = UILabel().then {
        $0.text = "식목일"
        $0.font = BagelFatOne.regular.of(size: 24)
        $0.textColor = .appBlack
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupBindings()
    }
    
    private func setupViews() {
        view.addSubviews(backgroundImageView, buttonStackView, logoLabel)
        buttonStackView.addArrangedSubviews(appleSignInButton, googleSignInButton)
        appleSignInButton.addTarget(self, action: #selector(didTapAppleSignIn), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(didTapGoogleSignIn), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(130)
        }
        
        appleSignInButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        googleSignInButton.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        logoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom).offset(32)
        }
    }
    
    private func setupBindings() {
        // ViewModel Outputs
        viewModel.firstLoginSuccess
            .subscribe(onNext: {
                print("첫 로그인 성공")
                self.navigateToAgreeVC()
            })
            .disposed(by: disposeBag)
        
        viewModel.loginSuccess
            .subscribe(onNext: {
                print("로그인 성공")
                DispatchQueue.main.async {
                    self.navigateToMainScreen()
                }
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
    
    private func navigateToAgreeVC() {
        print("로그인 성공, 온보딩 화면으로 이동")
        navigationController?.pushViewController(AgreementViewController(), animated: true)
    }
    
    private func navigateToMainScreen() {
        print("로그인 성공, 메인 화면으로 이동")
        let bottomTabBarController = BottomTabBarController()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            UIView.transition(with: window, duration: 0.7, options: .transitionFlipFromRight, animations: {
                window.rootViewController = bottomTabBarController
            })
            window.makeKeyAndVisible()
        }
    }
    
}

