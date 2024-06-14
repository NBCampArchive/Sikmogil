//
//  ProfileViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/3/24.
//

import UIKit
import SnapKit
import Then
import KeychainSwift

class ProfileViewController: UIViewController {
    
    let spacerView = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let topBar = UIView()
    
    var userProfile = UserProfileDummy.shared
    
    // MARK: - 사용자 인터페이스 요소를 정의
    let profileLabel = UILabel().then {
        $0.text = "프로필"
        $0.font = Suite.bold.of(size: 28)
    }
    
    let settingsButton = UIButton().then {
        $0.setImage(.setting, for: .normal)
        $0.tintColor = .appBlack
    }
    
    let profileImageView = UIImageView().then {
        $0.image = .profile
        $0.isUserInteractionEnabled = false // 이미지 수정을 막기 위해 false로 설정
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
    
    let nickname = UILabel().then {
        $0.text = "Cats Green"
        $0.font = Suite.bold.of(size: 24)
    }
    
    let profileInfoView = ProfileInfoView()
    let profileTableView = ProfileTableView()
    
    let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.appDarkGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    // MARK: - 뷰 컨트롤러의 생명주기 메서드를 정의
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
        
        // 동적으로 콘텐츠 높이 설정
        updateContentSize()
        
        // 노티피케이션 옵저버 설정
        NotificationCenter.default.addObserver(self, selector: #selector(profileDidChange(_:)), name: .profileDidChange, object: nil)
        
        // 프로필 이미지 뷰를 둥근 원형으로 설정
        profileImageView.layer.cornerRadius = 50 // 프로필 이미지 뷰의 너비와 높이가 100이므로 반으로 나눈 값
        profileImageView.layer.masksToBounds = true
        
        updateProfileInfo()
    }
    
    // MARK: - 사용자 인터페이스를 설정
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(topBar)
        topBar.addSubview(profileLabel)
        topBar.addSubview(settingsButton)
        
        [profileImageView, levelBadgeView, nickname, profileInfoView, profileTableView, logoutButton].forEach {
            contentView.addSubview($0)
        }
        
        levelStackView.addArrangedSubview(levelBadgeLabel)
        levelBadgeView.addSubview(levelStackView)
        levelStackView.addArrangedSubview(spacerView)
        
        setupConstraints()
    }
    
    // MARK: - AutoLayout 제약조건 설정
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
        }
        
        settingsButton.snp.makeConstraints {
            $0.right.equalTo(topBar).offset(-16)
            $0.width.height.equalTo(24)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(25)
            $0.width.height.equalTo(100)
        }
        
        levelBadgeView.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(10)
            $0.centerX.equalTo(profileImageView.snp.right).offset(-50)
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
        
        nickname.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(16)
            $0.right.equalTo(contentView).offset(-16)
        }
        
        profileInfoView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(30)
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
    
    // 콘텐츠 높이를 동적으로 업데이트
    private func updateContentSize() {
        let contentHeight = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        contentView.snp.remakeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(contentHeight)
        }
    }
    
    private func updateProfileInfo() {
        nickname.text = userProfile.nickname
        profileInfoView.updateInfo(height: userProfile.height, weight: userProfile.weight, gender: userProfile.gender)
    }
}

// MARK: - 프로필 변경
extension ProfileViewController {
    @objc private func profileDidChange(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let nickname = userInfo["nickname"] as? String {
                self.nickname.text = nickname
                userProfile.nickname = nickname
            }
            if let height = userInfo["height"] as? String {
                userProfile.height = height
            }
            if let weight = userInfo["weight"] as? String {
                userProfile.weight = weight
            }
            if let gender = userInfo["gender"] as? String {
                userProfile.gender = gender
            }
            if let profileImage = userInfo["profileImage"] as? UIImage {
                profileImageView.image = profileImage
                profileImageView.layer.cornerRadius = profileImageView.frame.width / 2 // 둥근 원형으로 설정
                profileImageView.layer.masksToBounds = true
            }
            updateProfileInfo()
        }
    }
}

// MARK: - 설정버튼 동작 처리
extension ProfileViewController {
    @objc private func settingsButtonTapped(_ sender: UIButton) {
        let editProfileAction = UIAction(title: "프로필 수정", image: nil) { _ in
            self.showEditProfile()
        }
        let notificationSettingsAction = UIAction(title: "알림 설정", image: nil) { _ in
            self.showNotificationSettings()
        }
        
        let goalSettingsAction = UIAction(title: "목표 설정", image: nil) { _ in
            self.showGoalSettings()
        }
        let menu = UIMenu(title: "", children: [editProfileAction, notificationSettingsAction, goalSettingsAction])
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
    
    private func showEditProfile() {
        let editProfileVC = EditProfileViewController()
        editProfileVC.userProfile = userProfile
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func showNotificationSettings() {
        let notificationSettingsVC = NotificationSettingsViewController()
        navigationController?.pushViewController(notificationSettingsVC, animated: true)
    }
    
    private func showGoalSettings() {
        let goalSettingsVC = GoalSettingsViewController()
        navigationController?.pushViewController(goalSettingsVC, animated: true)
    }
}
// MARK: - 로그아웃 버튼 액션 정의
extension ProfileViewController {
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
