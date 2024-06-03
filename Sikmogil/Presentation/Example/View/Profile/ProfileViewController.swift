//
//  ProfileViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/3/24.
//

import UIKit
import SnapKit
import Then

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let scrollView = UIScrollView()
    let contentView = UIView()

    // Top bar elements
    let topBar = UIView()
    let profileLabel = UILabel().then {
        $0.text = "프로필"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
    }
    let settingsButton = UIButton().then {
        $0.setImage(UIImage(systemName: "gearshape"), for: .normal)
    }

    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "defaultProfileImage") // 임의의 프로필 이미지
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 50 // 원형 이미지
        $0.isUserInteractionEnabled = true
    }
    let levelBadgeLabel = UILabel().then {
        $0.text = "Lv.10"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.backgroundColor = UIColor(red: 0.0, green: 0.7, blue: 0.7, alpha: 1.0)
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    let nameLabel = UILabel().then {
        $0.text = "Cats Green"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    let infoView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowRadius = 4
    }
    let weightLabel = UILabel().then {
        $0.text = "0.0kg"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    let heightLabel = UILabel().then {
        $0.text = "000cm"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    let genderLabel = UILabel().then {
        $0.text = "남자"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    let tableView = UITableView()
    let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.red, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProfileImageTap()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Add top bar elements
        contentView.addSubview(topBar)
        topBar.addSubview(profileLabel)
        topBar.addSubview(settingsButton)
        
        [profileImageView, levelBadgeLabel, nameLabel, infoView, tableView, logoutButton].forEach {
            contentView.addSubview($0)
        }

        [weightLabel, heightLabel, genderLabel].forEach {
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

        levelBadgeLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView).offset(5)
            $0.centerX.equalTo(profileImageView.snp.right).offset(-10)
            $0.height.equalTo(24)
            $0.width.equalTo(50)
        }

        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(16)
            $0.right.equalTo(contentView).offset(-16)
        }

        infoView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(16)
            $0.right.equalTo(contentView).offset(-16)
            $0.height.equalTo(80)
        }

        weightLabel.snp.makeConstraints {
            $0.centerY.equalTo(infoView)
            $0.left.equalTo(infoView).offset(16)
        }

        heightLabel.snp.makeConstraints {
            $0.centerY.equalTo(infoView)
            $0.centerX.equalTo(infoView)
        }

        genderLabel.snp.makeConstraints {
            $0.centerY.equalTo(infoView)
            $0.right.equalTo(infoView).offset(-16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(16)
            $0.right.equalTo(contentView).offset(-16)
            $0.height.equalTo(200) // 임의의 높이, 실제 데이터에 따라 조정 필요
        }

        logoutButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(20)
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
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // 임의의 데이터 개수
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "메달 확인"
        case 1:
            cell.textLabel?.text = "작성한 게시글"
        case 2:
            cell.textLabel?.text = "공감한 게시글"
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 각 항목에 대한 동작 추가
    }
}
