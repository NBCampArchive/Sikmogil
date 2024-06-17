//
//  ProfileViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/3/24.
//

//import UIKit
//import SnapKit
//import Then
//import RxSwift
//import RxCocoa
//import KeychainSwift
//
//class ProfileViewController: UIViewController {
//    
////    let viewModel = ProfileViewModel()
//    
//    let spacerView = UIView()
//    let scrollView = UIScrollView()
//    let contentView = UIView()
//    let topBar = UIView()
//    
//    let profileLabel = UILabel().then {
//        $0.text = "프로필"
//        $0.font = Suite.bold.of(size: 28)
//    }
//    
//    let settingsButton = UIButton().then {
//        $0.setImage(.setting, for: .normal)
//        $0.tintColor = .appBlack
//    }
//    
//    let profileImageView = UIImageView().then {
//        $0.image = UIImage(systemName: "person.crop.circle.fill")
//        $0.contentMode = .scaleAspectFill
//        $0.clipsToBounds = true
//    }
//    
//    let levelBadgeView = UIImageView().then {
//        $0.image = .levelbar
//    }
//    
//    let levelBadgeLabel = UILabel().then {
//        $0.text = "Lv.0"
//        $0.font = Suite.regular.of(size: 10)
//        $0.textColor = .appBlack
//        $0.textAlignment = .right
//    }
//    
//    let levelStackView = UIStackView().then {
//        $0.axis = .horizontal
//        $0.alignment = .center
//        $0.spacing = 4
//    }
//    
//    var nicknameLabel = UILabel().then {
//        $0.text = "아무개"
//        $0.font = Suite.bold.of(size: 24)
//    }
//    
//    let profileInfoView = ProfileInfoView()
//    let profileTableView = ProfileTableView()
//    
//    let logoutButton = UIButton().then {
//        $0.setTitle("로그아웃", for: .normal)
//        $0.setTitleColor(.appDarkGray, for: .normal)
//        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//    }
//    
//    private let disposeBag = DisposeBag()
//    private let viewModel = ProfileViewModel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        bindViewModel()
//        
//        settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
//        logoutButton.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
//        
//        updateContentSize()
//        
//        profileImageView.layer.cornerRadius = 50
//        profileImageView.layer.masksToBounds = true
//        
//        viewModel.fetchUserProfile()
//        viewModel.nickname.asObservable()
//            .distinctUntilChanged()
//            .subscribe(onNext: { [weak self] newnickname in
////                self?.updateUIWithFetchedData()
//            })
//            .disposed(by: disposeBag)
//            
//    }
//    
////    private func updateUIWithFetchedData() {
////        nicknameLabel.text = viewModel.userProfile.nickname
////        print("updateUIWithFetchedData")
//////        viewModel.nickname.accept(viewModel.userProfile.nickname)
//////        viewModel.height.accept(viewModel.userProfile.height)
//////        viewModel.weight.accept(viewModel.userProfile.weight)
//////        viewModel.gender.accept(viewModel.userProfile.gender)
////    }
//    
//    private func bindViewModel() {
//        viewModel.nickname
//            .bind(to: nicknameLabel.rx.text)
//            .disposed(by: disposeBag)
//        
//        viewModel.height
//            .bind(to: profileInfoView.heightLabel.rx.text)
//            .disposed(by: disposeBag)
//        
//        viewModel.weight
//            .bind(to: profileInfoView.weightLabel.rx.text)
//            .disposed(by: disposeBag)
//        
//        viewModel.gender
//            .bind(to: profileInfoView.genderLabel.rx.text)
//            .disposed(by: disposeBag)
//    }
//    
//    private func setupViews() {
//        view.backgroundColor = .white
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        
//        contentView.addSubview(topBar)
//        topBar.addSubview(profileLabel)
//        topBar.addSubview(settingsButton)
//        
//        [profileImageView, levelBadgeView, nicknameLabel, profileInfoView, profileTableView, logoutButton].forEach {
//            contentView.addSubview($0)
//        }
//        
//        levelStackView.addArrangedSubview(levelBadgeLabel)
//        levelBadgeView.addSubview(levelStackView)
//        levelStackView.addArrangedSubview(spacerView)
//        
//        setupConstraints()
//    }
//    
//    private func setupConstraints() {
//        scrollView.snp.makeConstraints {
//            $0.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//        contentView.snp.makeConstraints {
//            $0.edges.equalTo(scrollView)
//            $0.width.equalTo(scrollView)
//        }
//        
//        topBar.snp.makeConstraints {
//            $0.top.equalTo(contentView).offset(0)
//            $0.left.right.equalTo(contentView)
//            $0.height.equalTo(60)
//        }
//        
//        profileLabel.snp.makeConstraints {
//            $0.left.equalTo(topBar).offset(16)
//            $0.centerY.equalTo(topBar)
//        }
//        
//        settingsButton.snp.makeConstraints {
//            $0.right.equalTo(topBar).offset(-16)
//            $0.centerY.equalTo(topBar)
//            $0.width.height.equalTo(24)
//        }
//        
//        profileImageView.snp.makeConstraints {
//            $0.top.equalTo(topBar.snp.bottom).offset(20)
//            $0.centerX.equalTo(contentView)
//            $0.width.height.equalTo(100)
//        }
//        
//        levelBadgeView.snp.makeConstraints {
//            $0.top.equalTo(profileImageView.snp.bottom).offset(-20)
//            $0.centerX.equalTo(contentView)
//            $0.height.equalTo(24)
//            $0.width.equalTo(60)
//        }
//        
//        levelStackView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(4)
//        }
//        
//        levelBadgeLabel.snp.makeConstraints {
//            $0.height.equalToSuperview()
//        }
//        
//        spacerView.snp.makeConstraints {
//            $0.width.equalTo(4)
//        }
//        
//        nicknameLabel.snp.makeConstraints {
//            $0.top.equalTo(levelBadgeView.snp.bottom).offset(10)
//            $0.centerX.equalTo(contentView)
//        }
//        
//        profileInfoView.snp.makeConstraints {
//            $0.top.equalTo(nicknameLabel.snp.bottom).offset(30)
//            $0.left.equalTo(contentView).offset(16)
//            $0.right.equalTo(contentView).offset(-16)
//            $0.height.equalTo(100)
//        }
//        
//        profileTableView.snp.makeConstraints {
//            $0.top.equalTo(profileInfoView.snp.bottom).offset(32)
//            $0.left.equalTo(contentView).offset(16)
//            $0.right.equalTo(contentView).offset(-16)
//            $0.height.equalTo(200)
//        }
//        
//        logoutButton.snp.makeConstraints {
//            $0.centerX.equalTo(contentView)
//            $0.top.equalTo(profileTableView.snp.bottom).offset(240)
//            $0.bottom.equalTo(contentView).offset(-20)
//        }
//    }
//    
//    private func updateContentSize() {
//        let contentHeight = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        contentView.snp.remakeConstraints {
//            $0.edges.equalTo(scrollView)
//            $0.width.equalTo(scrollView)
//            $0.height.equalTo(contentHeight)
//        }
//    }
//    
//    @objc private func settingsButtonTapped(_ sender: UIButton) {
//        let editProfileVC = EditProfileViewController()
//        editProfileVC.userProfile = viewModel.userProfile
//        editProfileVC.onProfileUpdate = { [weak self] updatedProfile in
//            self?.viewModel.userProfile = updatedProfile
////            self?.updateUIWithFetchedData()
//        }
//        navigationController?.pushViewController(editProfileVC, animated: true)
//    }
//    
//    @objc private func logoutButtonTapped(_ sender: UIButton) {
//        let keychain = KeychainSwift()
//        keychain.clear()
//        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//            let loginVC = LoginViewController()
//            let navController = UINavigationController(rootViewController: loginVC)
//            sceneDelegate.window?.rootViewController = navController
//            sceneDelegate.window?.makeKeyAndVisible()
//        }
//    }
//}

import UIKit
import SnapKit
import Then
import Combine
import KeychainSwift

class ProfileViewController: UIViewController {
    
    let spacerView = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let topBar = UIView()
    
    let profileLabel = UILabel().then {
        $0.text = "프로필"
        $0.font = Suite.bold.of(size: 28)
    }
    
    let settingsButton = UIButton().then {
        $0.setImage(.setting, for: .normal)
        $0.tintColor = .appBlack
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let levelBadgeView = UIImageView().then {
        $0.image = .levelbar
    }
    
    let levelBadgeLabel = UILabel().then {
        $0.text = "Lv.0"
        $0.font = Suite.regular.of(size: 10)
        $0.textColor = .appBlack
        $0.textAlignment = .right
    }
    
    let levelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 4
    }
    
    var nicknameLabel = UILabel().then {
        $0.text = "아무개"
        $0.font = Suite.bold.of(size: 24)
    }
    
    let profileInfoView = ProfileInfoView()
    let profileTableView = ProfileTableView()
    
    let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.appDarkGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
        
        updateContentSize()
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        
        viewModel.fetchUserProfile()
    }
    
    private func bindViewModel() {
        viewModel.$userProfile
            .receive(on: RunLoop.main)
            .sink { [weak self] userProfile in
                guard let self = self else { return }
                self.updateUI(with: userProfile)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with userProfile: UserProfile?) {
        nicknameLabel.text = userProfile?.nickname
        profileInfoView.heightLabel.text = userProfile?.height
        profileInfoView.weightLabel.text = userProfile?.weight
        profileInfoView.genderLabel.text = userProfile?.gender
        // 프로필 이미지 업데이트 (필요 시)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(topBar)
        topBar.addSubview(profileLabel)
        topBar.addSubview(settingsButton)
        
        [profileImageView, levelBadgeView, nicknameLabel, profileInfoView, profileTableView, logoutButton].forEach {
            contentView.addSubview($0)
        }
        
        levelStackView.addArrangedSubview(levelBadgeLabel)
        levelBadgeView.addSubview(levelStackView)
        levelStackView.addArrangedSubview(spacerView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        topBar.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(0)
            $0.left.right.equalTo(contentView)
            $0.height.equalTo(60)
        }
        profileLabel.snp.makeConstraints {
            $0.left.equalTo(topBar).offset(16)
            $0.centerY.equalTo(topBar)
        }
        
        settingsButton.snp.makeConstraints {
            $0.right.equalTo(topBar).offset(-16)
            $0.centerY.equalTo(topBar)
            $0.width.height.equalTo(24)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).offset(20)
            $0.centerX.equalTo(contentView)
            $0.width.height.equalTo(100)
        }
        
        levelBadgeView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(-20)
            $0.centerX.equalTo(contentView)
            $0.height.equalTo(24)
            $0.width.equalTo(60)
        }
        
        levelStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        levelBadgeLabel.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        spacerView.snp.makeConstraints {
            $0.width.equalTo(4)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(levelBadgeView.snp.bottom).offset(10)
            $0.centerX.equalTo(contentView)
        }
        
        profileInfoView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(30)
            $0.left.equalTo(contentView).offset(16)
            $0.right.equalTo(contentView).offset(-16)
            $0.height.equalTo(100)
        }
        
        profileTableView.snp.makeConstraints {
            $0.top.equalTo(profileInfoView.snp.bottom).offset(32)
            $0.left.equalTo(contentView).offset(16)
            $0.right.equalTo(contentView).offset(-16)
            $0.height.equalTo(200)
        }
        
        logoutButton.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(profileTableView.snp.bottom).offset(240)
            $0.bottom.equalTo(contentView).offset(-20)
        }
    }
    
    private func updateContentSize() {
        let contentHeight = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        contentView.snp.remakeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(contentHeight)
        }
    }
    
    @objc private func settingsButtonTapped(_ sender: UIButton) {
        let editProfileVC = EditProfileViewController()
        editProfileVC.userProfile = viewModel.userProfile
        editProfileVC.onProfileUpdate = { [weak self] updatedProfile in
            self?.viewModel.userProfile = updatedProfile
        }
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @objc private func logoutButtonTapped(_ sender: UIButton) {
        let keychain = KeychainSwift()
        keychain.clear()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
