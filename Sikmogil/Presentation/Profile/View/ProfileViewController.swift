//
//  ProfileViewController.swift
//  Sikmogil
//
//  Created by 박준영 on 6/3/24.
//  [프로필] 🙍🏻 프로필 🙍🏻

import UIKit
import SnapKit
import Then
import Combine
import Kingfisher

class ProfileViewController: UIViewController {
    
    var viewModel = ProfileViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    let spacerView = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let topBar = UIView()
    
    let profileLabel = UILabel().then {
        $0.text = "프로필"
        $0.font = Suite.bold.of(size: 24)
    }
    
    let settingsButton = UIButton().then {
        $0.setImage(.setting, for: .normal)
        $0.tintColor = .appBlack
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "AppIcon")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
//    let levelBadgeView = UIImageView().then {
//        $0.image = .levelbar
//    }
    
//    let levelBadgeLabel = UILabel().then {
//        $0.text = "Lv.0"
//        $0.font = Suite.regular.of(size: 10)
//        $0.textColor = .appBlack
//        $0.textAlignment = .right
//    }
    
//    let levelStackView = UIStackView().then {
//        $0.axis = .horizontal
//        $0.alignment = .center
//        $0.spacing = 4
//    }
    
    var nicknameLabel = UILabel().then {
        $0.text = "(알 수 없음)"
        $0.font = Suite.bold.of(size: 24)
    }
    
    let profileInfoView = ProfileInfoView()
//    let profileTableView = ProfileTableView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
        loadImage(from: viewModel.picture)
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
//        logoutButton.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
        
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
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Binding
    func setupBindings() {
        let nicknamePublisher = viewModel.$nickname
        let heightPublisher = viewModel.$height
        let weightPublisher = viewModel.$weight
        let picturePublisher = viewModel.$picture
        let genderPublisher = viewModel.$gender
            
        // CombineLatest4와 추가적인 CombineLatest를 사용하여 다섯 개 이상의 퍼블리셔 결합
        Publishers.CombineLatest(Publishers.CombineLatest4(nicknamePublisher, heightPublisher, weightPublisher, picturePublisher), genderPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] combinedValues, gender in
                let (nickname, height, weight, picture) = combinedValues
                self?.nicknameLabel.text = nickname
                self?.profileInfoView.heightLabel.text = height
                self?.profileInfoView.weightLabel.text = weight
                if !picture.isEmpty {
                    self?.loadImage(from: picture)
                } else {
                    self?.profileImageView.image = UIImage(named: "defaultProfile")
                }
                self?.profileInfoView.genderLabel.text = gender
            }
            .store(in: &cancellables)
    }

    // URL로부터 이미지를 로드하여 profileImageView에 뿌려주는 부분
    private func loadImage(from urlString: String?) {
        guard let urlString = urlString else {
            return
        }
        profileImageView.kf.setImage(with: URL(string: urlString))
    }
    
    // MARK: - setupViews
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(topBar)
        topBar.addSubview(profileLabel)
        topBar.addSubview(settingsButton)
        
        [profileImageView, /*levelBadgeView,*/ nicknameLabel, profileInfoView/* profileTableView,*/].forEach {
            contentView.addSubview($0)
        }
        
//        levelStackView.addArrangedSubview(levelBadgeLabel)
//        levelBadgeView.addSubview(levelStackView)
//        levelStackView.addArrangedSubview(spacerView)
        
        setupConstraints()
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        topBar.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(32)
            $0.left.right.equalTo(contentView)
            $0.height.equalTo(60)
        }
        
        profileLabel.snp.makeConstraints {
            $0.left.equalTo(topBar).offset(16)
            $0.top.equalToSuperview()
        }
        
        settingsButton.snp.makeConstraints {
            $0.right.equalTo(topBar).offset(-16)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(28)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).offset(20)
            $0.centerX.equalTo(contentView)
            $0.width.height.equalTo(100)
        }
        
        spacerView.snp.makeConstraints {
            $0.width.equalTo(4)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.centerX.equalTo(contentView)
        }
        
        profileInfoView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(30)
            $0.left.equalTo(contentView).offset(16)
            $0.right.equalTo(contentView).offset(-16)
            $0.height.equalTo(100)
            $0.bottom.equalToSuperview().offset(-30)
        }
        
//        profileTableView.snp.makeConstraints {
//            $0.top.equalTo(profileInfoView.snp.bottom).offset(32)
//            $0.left.equalTo(contentView).offset(16)
//            $0.right.equalTo(contentView).offset(-16)
//            $0.height.equalTo(200)
//        }
    }
    
    // MARK: - didSelectCell
    // 각 셀을 인덱스 기반 클로저 배열 할당
    func didSelectCell(at index: Int) {
        if index < cellActions.count {
            cellActions[index]()
        }
    }

    private lazy var cellActions: [() -> Void] = [
        { [weak self] in
//            self?.showMedalView()
        },
        { [weak self] in
//            self?.showPostListView()
        },
        { [weak self] in
//            self?.showLikedPostListView()
        }
    ]
    
    // 메달 확인 뷰로 이동하는 메서드
    private func showMedalView() {
        print("메달확인 페이지로 이동")
//        let medalViewController = MedalViewController()
//        self.navigationController?.pushViewController(medalViewController, animated: true)
    }

    // 작성한 게시글 뷰로 이동하는 메서드
    private func showPostListView() {
        print("게시글 목록페이지로 이동")
//        let postViewController = PostViewController()
//        self.navigationController?.pushViewController(postViewController, animated: true)
    }

    // 공감한 게시글 뷰로 이동하는 메서드
    private func showLikedPostListView() {
        print("공감한 게시글 목록페이지로 이동")
//        let likedPostViewController = LikedPostViewController()
//        self.navigationController?.pushViewController(likedPostViewController, animated: true)
    }
    
    // MARK: - Settings
    @objc private func settingsButtonTapped(_ sender: UIButton) {
        let settingsVC = SettingsViewController()
        settingsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
}
