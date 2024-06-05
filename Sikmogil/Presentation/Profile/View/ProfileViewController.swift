//
//  ProfileViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/3/24.
//

import UIKit
import SnapKit
import Then

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let topBar = UIView()
    
    let profileLabel = UILabel().then {
        $0.text = "프로필"
        $0.font = Suite.bold.of(size: 28)
    }
    
    // 설정버튼
    let settingsButton = UIButton().then {
        $0.setImage(UIImage(systemName: "gearshape"), for: .normal)
        $0.tintColor = .black
    }
    
    // 프로필 이미지
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "profile")
    }
    
    // 레벨배경 이미지
    let levelBadgeView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(named: "appGreen")?.cgColor
        $0.layer.borderWidth = 1.0
    }
    
    // 레벨별 이미지
    let levelIconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "crown.fill")
        $0.tintColor = UIColor(named: "appGreen")
    }
    
    let levelBadgeLabel = UILabel().then {
        $0.text = "Lv.0"
        $0.font = Suite.regular.of(size: 10)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    let levelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 4
    }
    
    let nameLabel = UILabel().then {
        $0.text = "Cats Green"
        $0.font = Suite.bold.of(size: 24)
    }
    
    let infoView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowRadius = 4
    }
    
    // 스택뷰로 나눔
    let weightStackView = UIStackView().then {
        $0.axis = .vertical // 세로방향으로 설정
        $0.alignment = .center
    }
    
    let heightStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    let genderStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    // 구분선 뷰 생성
    let separator1 = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let separator2 = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let weightTitleLabel = UILabel().then {
        $0.text = "몸무게"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .darkGray
    }
    let weightLabel = UILabel().then {
        $0.text = "0.0kg"
        $0.font = Suite.bold.of(size: 16)
    }
    let heightTitleLabel = UILabel().then {
        $0.text = "키"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .darkGray
    }
    let heightLabel = UILabel().then {
        $0.text = "000cm"
        $0.font = Suite.bold.of(size: 16)
    }
    let genderTitleLabel = UILabel().then {
        $0.text = "성별"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .darkGray
    }
    let genderLabel = UILabel().then {
        $0.text = "남자"
        $0.font = Suite.bold.of(size: 16)
    }
    
    let tableView = UITableView().then {
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        $0.separatorStyle = .none
        $0.rowHeight = 60 // 각 셀 높이
    }
    let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(UIColor(named: "appDarkGray"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProfileImageTap()
        setupTableView()
        settingsButton.addTarget(self, action: Selector(#settingsButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add top bar elements
        contentView.addSubview(topBar)
        topBar.addSubview(profileLabel)
        topBar.addSubview(settingsButton)
        
        [profileImageView, levelBadgeView, nameLabel, infoView, tableView, logoutButton].forEach {
            contentView.addSubview($0)
        }
        
        levelStackView.addArrangedSubview(levelIconImageView)
        levelStackView.addArrangedSubview(levelBadgeLabel)
        levelBadgeView.addSubview(levelStackView)
        
        weightStackView.addArrangedSubview(weightTitleLabel)
        weightStackView.addArrangedSubview(weightLabel)
        
        heightStackView.addArrangedSubview(heightTitleLabel)
        heightStackView.addArrangedSubview(heightLabel)
        
        genderStackView.addArrangedSubview(genderTitleLabel)
        genderStackView.addArrangedSubview(genderLabel)
        
        infoView.addSubview(weightStackView)
        infoView.addSubview(heightStackView)
        infoView.addSubview(genderStackView)
        infoView.addSubview(separator1)
        infoView.addSubview(separator2)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(800) // 임의 스크롤 콘텐츠 뷰 설정
        }
        
        // 상단영역
        topBar.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.left.right.equalTo(contentView)
            $0.height.equalTo(44)
        }
        
        profileLabel.snp.makeConstraints {
            $0.centerY.equalTo(topBar)
            $0.left.equalTo(topBar).offset(16)
        }
        
        settingsButton.snp.makeConstraints {
            $0.centerY.equalTo(topBar)
            $0.right.equalTo(topBar).offset(-16)
            $0.width.height.equalTo(24)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(16)
            $0.width.height.equalTo(100)
        }
        
        levelBadgeView.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(10)
            $0.centerX.equalTo(profileImageView.snp.right).offset(-50)
            $0.height.equalTo(23) // 높이를 더 주어 레이아웃 조정
            $0.width.equalTo(60)
        }
        
        levelStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        
        levelIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(12)
            //            $0.left.equalTo(levelStackView).offset(2)
        }
        
        levelBadgeLabel.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(16)
            $0.right.equalTo(contentView).offset(-16)
        }
        
        // MARK: - 키, 몸무게, 성별 레이아웃 영역
        infoView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(30)
            $0.left.equalTo(contentView).offset(16)
            $0.right.equalTo(contentView).offset(-16)
            $0.height.equalTo(100)
        }
        
        // 키, 몸무게, 성별 스택뷰 영역
        weightStackView.snp.makeConstraints { // 몸무게
            $0.left.equalTo(infoView).offset(16)
            $0.centerY.equalTo(infoView)
            $0.width.equalTo(heightStackView)
        }
        
        heightStackView.snp.makeConstraints { // 키
            $0.centerX.equalTo(infoView)
            $0.centerY.equalTo(infoView)
            $0.width.equalTo(genderStackView)
        }
        
        genderStackView.snp.makeConstraints { // 성별
            $0.right.equalTo(infoView).offset(-16)
            $0.centerY.equalTo(infoView)
            $0.width.equalTo(weightStackView)
        }
        
        // 구분선 뷰 제약조건 추가
        separator1.snp.makeConstraints {
            $0.centerY.equalTo(infoView)
            $0.left.equalTo(weightStackView.snp.right).offset(8)
            $0.right.equalTo(heightStackView.snp.left).offset(-8)
            $0.width.equalTo(1)
            $0.height.equalTo(30)
        }
        
        separator2.snp.makeConstraints {
            $0.centerY.equalTo(infoView)
            $0.left.equalTo(heightStackView.snp.right).offset(8)
            $0.right.equalTo(genderStackView.snp.left).offset(-8)
            $0.width.equalTo(1)
            $0.height.equalTo(30)
        }
        
        weightTitleLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        heightTitleLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        genderTitleLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        weightLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        heightLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        genderLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        // MARK: - 테이블 레이아웃 영역
        tableView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(52)
            $0.left.equalTo(contentView).offset(16)
            $0.right.equalTo(contentView).offset(-16)
            $0.height.equalTo(200) // 임의의 높이
        }
        
        logoutButton.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.bottom.equalTo(contentView).offset(-20)
        }
    }
    
    private func setupProfileImageTap() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func profileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // 데이터 개수
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        let titles = ["메달 확인", "작성한 게시글", "공감한 게시글"]
        let icons = ["cup", "pencilline", "heart"]
        cell.configure(with: titles[indexPath.row], iconName: icons[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 각 항목에 대한 동작 추가
    }
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
}
