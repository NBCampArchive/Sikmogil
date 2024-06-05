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
    
    // 몸무게, 키, 성별 각각의 스택뷰
//    let weightview = UIStackView() // 몸무게
//    let heightView = UIStackView() // 키
//    let genderView = UIStackView() // 성별
    
    // 최상단영역
    let topBar = UIView()
    let profileLabel = UILabel().then {
        $0.text = "프로필"
        $0.font = Suite.bold.of(size: 24)
    }
    
    // 톱니바퀴
    let settingsButton = UIButton().then {
        $0.setImage(UIImage(systemName: "gearshape"), for: .normal)
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "defaultProfileImage") // 임의의 프로필 이미지
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 50
        $0.isUserInteractionEnabled = true
    }
    
    // 레벨 배경
    let levelBadgeView = UIImageView().then {
        $0.image = UIImage(named: "levelbar")
    }

    let levelIconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "crown.fill")
        $0.tintColor = UIColor(named: "appGreen")
        $0.snp.makeConstraints {
            $0.width.height.equalTo(12)
        }
    }
    
    let levelBadgeLabel = UILabel().then {
        $0.text = "Lv.10"
        $0.font = Suite.regular.of(size: 10)
        $0.textColor = .black
        $0.textAlignment = .center
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
        $0.spacing = 8 // 라벨 간 간격 설정
    }
    
    let heightStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    let genderStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
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
    let separator1 = UIView().then {
        $0.backgroundColor = UIColor(named: "appDarkGray")
    }
    let separator2 = UIView().then {
        $0.backgroundColor = UIColor(named: "appDarkGray")
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
        
        [weightTitleLabel, weightLabel, heightTitleLabel, heightLabel, genderTitleLabel, genderLabel, separator1, separator2].forEach {
            infoView.addSubview($0)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(scrollView).priority(.low)
            $0.height.equalTo(800) // 임의 스크롤 콘텐츠 뷰 설정
        }
        
        // Top bar constraints
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
        
        levelBadgeLabel.snp.makeConstraints {
            $0.height.equalToSuperview()
//            $0.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(16)
            $0.right.equalTo(contentView).offset(-16)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(30)
            $0.left.equalTo(contentView).offset(16)
            $0.right.equalTo(contentView).offset(-16)
            $0.height.equalTo(80)
        }
        
//        weightStackView.snp.makeConstraints {
//            $0.width.equalTo(200) // 원하는 너비 설정
//            $0.height.greaterThanOrEqualTo(40) // 최소 높이 설정
//            $0.center.equalToSuperview()
//        }
        
        weightTitleLabel.snp.makeConstraints {
            $0.top.equalTo(infoView).offset(16)
            $0.left.equalTo(infoView).offset(43)
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(weightTitleLabel.snp.bottom).offset(4)
            $0.left.equalTo(infoView).offset(40)
            $0.bottom.equalTo(infoView).offset(-16)
        }
        
        heightTitleLabel.snp.makeConstraints {
            $0.top.equalTo(infoView).offset(16)
            $0.centerX.equalTo(infoView)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(heightTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(infoView)
            $0.bottom.equalTo(infoView).offset(-16)
        }
        
        genderTitleLabel.snp.makeConstraints {
            $0.top.equalTo(infoView).offset(16)
            $0.right.equalTo(infoView).offset(-50)
        }
        
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(4)
            $0.right.equalTo(infoView).offset(-48)
            $0.bottom.equalTo(infoView).offset(-16)
        }
        
        // 선
        separator1.snp.makeConstraints {
            $0.centerX.equalTo(infoView.snp.left).offset(119.33)
            $0.top.equalTo(infoView).offset(26)
            $0.bottom.equalTo(infoView).offset(-26)
            $0.width.equalTo(1)
        }
        
        // 선
        separator2.snp.makeConstraints {
            $0.centerX.equalTo(infoView.snp.left).offset(119.33 * 2)
            $0.top.equalTo(infoView).offset(26)
            $0.bottom.equalTo(infoView).offset(-26)
            $0.width.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(52)
            $0.left.equalTo(contentView).offset(16)
            $0.right.equalTo(contentView).offset(-16)
            $0.height.equalTo(200) // 임의의 높이
        }
        
        logoutButton.snp.makeConstraints {
//            $0.top.equalTo(contentView).offset(20)
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
}
