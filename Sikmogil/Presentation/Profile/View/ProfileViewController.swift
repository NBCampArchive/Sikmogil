//
//  ProfileViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/3/24.
//  [프로필] 🙍🏻 프로필 🙍🏻

import UIKit
import SnapKit
import Then
import Combine
import KeychainSwift

class ProfileViewController: UIViewController {
    
    var viewModel = ProfileViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
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
        $0.image = UIImage(named: "profile")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserProfile()
        setupBindings()
    }

    func setupBindings() {
        let nicknamePublisher = viewModel.$nickname
        let heightPublisher = viewModel.$height
        let weightPublisher = viewModel.$weight
        let picturePublisher = viewModel.$picture

        // 뷰모델의 프로퍼티와 뷰를 바인딩하여 데이터를 뿌려주는 부분
        Publishers.CombineLatest4(nicknamePublisher, heightPublisher, weightPublisher, picturePublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nickname, height, weight, picture in
                self?.nicknameLabel.text = nickname
                self?.profileInfoView.heightLabel.text = height
                self?.profileInfoView.weightLabel.text = weight
                if !picture.isEmpty {
                    self?.loadImage(from: picture)  // 비동기 이미지 로드
                } else {
                    self?.profileImageView.image = UIImage(named: "profile")
                }
            }
            .store(in: &cancellables)
    }

    // URL로부터 이미지를 로드하여 profileImageView에 뿌려주는 부분
    private func loadImage(from urlString: String) {
        guard !urlString.isEmpty, let url = URL(string: urlString) else {
            print("URL 문자열이 비어 있습니다.")
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(named: "profile")
            }
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                print("이미지 로드 실패: \(error?.localizedDescription ?? "오류 설명 없음")")
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(named: "profile")
                }
                return
            }
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data)
            }
        }.resume()
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
    
    // 각 셀을 인덱스 기반 클로저 배열 할당
    func didSelectCell(at index: Int) {
        if index < cellActions.count {
            cellActions[index]()
        }
    }
    
    private lazy var cellActions: [() -> Void] = [
        { [weak self] in
            print("메달확인 페이지로 이동")
//            let medalViewController = MedalViewController()
//            self?.navigationController?.pushViewController(medalViewController, animated: true)
        },
        { [weak self] in
            print("게시글 목록페이지로 이동")
//            let postViewController = PostViewController()
//            self?.navigationController?.pushViewController(postViewController, animated: true)
        },
        { [weak self] in
            print("공감한 게시글 목록페이지 로 이동")
//            let likedPostViewController = LikedPostViewController()
//            self?.navigationController?.pushViewController(likedPostViewController, animated: true)
        }
    ]
    
    @objc private func settingsButtonTapped(_ sender: UIButton) {
        let editProfileAction = UIAction(title: "프로필 수정", image: nil) { [weak self] _ in
            guard let self = self else { return }
            let editProfileVC = EditProfileViewController()
            editProfileVC.viewModel = self.viewModel
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        }
        
        let notificationSettingsAction = UIAction(title: "알림 설정", image: nil) { [weak self] _ in
            guard let self = self else { return }
            let notificationSettingsVC = NotificationSettingsViewController()
            notificationSettingsVC.viewModel = self.viewModel
            self.navigationController?.pushViewController(notificationSettingsVC, animated: true)
        }
        
        let goalSettingsAction = UIAction(title: "목표 설정", image: nil) { [weak self] _ in
            guard let self = self else { return }
            let goalSettingsVC = GoalSettingsViewController()
            goalSettingsVC.viewModel = OnboardingViewModel()
            self.navigationController?.pushViewController(goalSettingsVC, animated: true)
        }
        
        let menu = UIMenu(title: "", children: [editProfileAction, notificationSettingsAction, goalSettingsAction])
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
    
    @objc private func logoutButtonTapped(_ sender: UIButton) {
        let keychain = KeychainSwift()
        keychain.clear()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController:loginVC)
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
