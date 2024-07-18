//
//  BoardDetailHeaderView.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/18/24.
//

import UIKit
import SnapKit
import Then

class BoardDetailHeaderView: UIView {
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = Suite.semiBold.of(size: 16)
        $0.textColor = .appBlack
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Suite.medium.of(size: 14)
        $0.textColor = .appDeepDarkGray
    }
    
    private lazy var likeButton = UIButton(configuration: .plain()).then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart.fill")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseForegroundColor = .appBlack
        $0.configuration = config
        $0.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.image = button.isSelected ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            config?.baseForegroundColor = button.isSelected ? .red : .appBlack
            button.configuration = config
        }
    }
    
    private lazy var commentButton = UIButton(configuration: .plain()).then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "ellipsis.message")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseForegroundColor = .appDeepDarkGray
        $0.configuration = config
    }
    
    private var isLiked = false
    private var likeCount = 0
    private var commentCount = 0
    var onLikeChanged: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews(profileImageView, nicknameLabel, dateLabel, likeButton, commentButton)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.left.equalTo(nicknameLabel)
        }
        
        likeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(commentButton.snp.left).offset(-16)
        }
        
        commentButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
    }
    
    private func setupActions() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func likeButtonTapped() {
        print("likeButtonTapped")
        isLiked.toggle()
        likeButton.isSelected = isLiked
        
        if isLiked {
            likeCount += 1
        } else {
            likeCount = max(0, likeCount - 1)
        }
        
        updateLikeButton()
        onLikeChanged?(likeCount)
    }
    
    private func updateLikeButton() {
        likeButton.configuration?.title = "\(likeCount)"
    }
    
    private func updateCommentButton() {
        commentButton.configuration?.title = "\(commentCount)"
    }
    
    func configure(with nickname: String, date: String, likeCount: Int, commentCount: Int, profileImage: UIImage?) {
        nicknameLabel.text = nickname
        dateLabel.text = date
        self.likeCount = likeCount
        self.commentCount = commentCount
        profileImageView.image = profileImage
        
        isLiked = false
        likeButton.isSelected = false
        updateLikeButton()
        updateCommentButton()
    }
}
