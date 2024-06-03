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
        $0.layer.cornerRadius = 10
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
    let weightTitleLabel = UILabel().then {
        $0.text = "몸무게"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .darkGray
    }
    let weightLabel = UILabel().then {
        $0.text = "0.0kg"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    let heightTitleLabel = UILabel().then {
        $0.text = "키"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .darkGray
    }
    let heightLabel = UILabel().then {
        $0.text = "000cm"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    let genderTitleLabel = UILabel().then {
        $0.text = "성별"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .darkGray
    }
    let genderLabel = UILabel().then {
        $0.text = "남자"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    let separator1 = UIView().then {
        $0.backgroundColor = UIColor(named: "appDarkGray")
    }
    let separator2 = UIView().then {
        $0.backgroundColor = UIColor(named: "appDarkGray")
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
            $0.bottom.equalTo(profileImageView.snp.bottom).offset(-5)
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
        
        weightTitleLabel.snp.makeConstraints {
            $0.top.equalTo(infoView).offset(16)
            $0.left.equalTo(infoView).offset(43)
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(weightTitleLabel.snp.bottom).offset(4)
            $0.left.equalTo(infoView).offset(35)
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
            $0.right.equalTo(infoView).offset(-43)
        }
        
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(4)
            $0.right.equalTo(infoView).offset(-35)
            $0.bottom.equalTo(infoView).offset(-16)
        }
        
        separator1.snp.makeConstraints { make in
            make.centerX.equalTo(infoView.snp.left).offset(119.33)
            make.top.equalTo(infoView).offset(16)
            make.bottom.equalTo(infoView).offset(-16)
            make.width.equalTo(1)
        }
        
        separator2.snp.makeConstraints { make in
            make.centerX.equalTo(infoView.snp.left).offset(119.33 * 2)
            make.top.equalTo(infoView).offset(16)
            make.bottom.equalTo(infoView).offset(-16)
            make.width.equalTo(1)
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
}
