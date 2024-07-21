//
//  CommentTableViewCell.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/21/24.
//

import UIKit
import SnapKit
import Then

class CommentTableViewCell: UITableViewCell {
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = Suite.bold.of(size: 14)
        $0.textColor = .appBlack
    }
    
    private let contentLabel = UILabel().then {
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appBlack
        $0.numberOfLines = 0
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .appDarkGray
    }
    
    private let settingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .appBlack
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubviews(profileImageView, nicknameLabel, contentLabel, dateLabel, settingButton)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(16)
            $0.width.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        settingButton.snp.makeConstraints {
            $0.centerY.equalTo(nicknameLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nicknameLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nicknameLabel)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(with comment: CommentInfo) {
        nicknameLabel.text = comment.writerNickname
        contentLabel.text = comment.content
        dateLabel.text = comment.createdAt
        
        if let imageUrl = comment.writerProfileImage {
            profileImageView.kf.setImage(with: URL(string: imageUrl))
        } else {
            profileImageView.image = UIImage(named: "defaultProfileImage")
        }
    }
}
