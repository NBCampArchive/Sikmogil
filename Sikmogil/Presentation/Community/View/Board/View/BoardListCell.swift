//
//  BoardListCell.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/1/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class BoardListCell: UITableViewCell {
    
    // MARK: - UI Elements
    let backgroundCardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderColor = UIColor.appDeepDarkGray.cgColor
        $0.layer.borderWidth = 1
    }
    let titleLabel = UILabel().then {
        $0.font = Suite.semiBold.of(size: 16)
        $0.numberOfLines = 2
    }
    
    let contentLabel = UILabel().then {
        $0.font = Suite.medium.of(size: 14)
        $0.numberOfLines = 2
        $0.textColor = .gray
    }
    
    let nicknameLabel = UILabel().then {
        $0.font = Suite.light.of(size: 12)
        $0.textColor = .gray
    }
    
    let dateLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
    }
    
    let likeButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart.fill")
        config.imagePadding = 5
        config.baseForegroundColor = .gray
        config.titleAlignment = .center
        $0.configuration = config
    }

    let commentButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "ellipsis.message.fill")
        config.imagePadding = 5
        config.baseForegroundColor = .gray
        config.titleAlignment = .center
        $0.configuration = config
    }
    
    let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(backgroundCardView)
        backgroundCardView.addSubviews(titleLabel, contentLabel, nicknameLabel, likeButton, commentButton, thumbnailImageView)
        
        setupConstraints()
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        backgroundCardView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-8)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.top)
            $0.leading.equalToSuperview().inset(11)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        commentButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.top)
            $0.leading.equalTo(likeButton.snp.trailing).offset(4)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(80)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    // MARK: - Configure Cell
    func configure(with board: BoardContent) {
        titleLabel.text = board.title
        contentLabel.text = board.content
        nicknameLabel.text = "\(board.nickname) • \(DateHelper.shared.formatServerDateYMD(from: board.date) ?? "")"
        
        // Update likeButton configuration
        if var likeButtonConfig = likeButton.configuration {
            let likeAttributedTitle = AttributedString("\(board.likeCount)", attributes: AttributeContainer([
                .font: Suite.regular.of(size: 12),
                .foregroundColor: UIColor.appDeepDarkGray
            ]))
            likeButtonConfig.attributedTitle = likeAttributedTitle
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
            likeButtonConfig.image = UIImage(systemName: "heart.fill", withConfiguration: symbolConfig)
            likeButtonConfig.imagePadding = 5
            likeButton.configuration = likeButtonConfig
        }
        
        // Update commentButton configuration
        if var commentButtonConfig = commentButton.configuration {
            let commentAttributedTitle = AttributedString("\(board.commentCount)", attributes: AttributeContainer([
                .font: Suite.regular.of(size: 12),
                .foregroundColor: UIColor.appDeepDarkGray
            ]))
            commentButtonConfig.attributedTitle = commentAttributedTitle
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
            commentButtonConfig.image = UIImage(systemName: "ellipsis.message.fill", withConfiguration: symbolConfig)
            commentButtonConfig.imagePadding = 5
            commentButton.configuration = commentButtonConfig
        }
        
        if let imageUrl = board.imageUrl.first {
            thumbnailImageView.isHidden = false
            thumbnailImageView.kf.setImage(with: URL(string: imageUrl))
            
            // 이미지가 있는 경우
            nicknameLabel.snp.remakeConstraints {
                $0.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
                $0.trailing.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(16)
            }
        } else {
            thumbnailImageView.isHidden = true
            
            // 이미지가 없는 경우
            nicknameLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(88)
                $0.trailing.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(16)
            }
        }
    }
}

