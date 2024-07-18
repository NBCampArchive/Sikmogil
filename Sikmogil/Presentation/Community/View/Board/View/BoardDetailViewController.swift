//
//  BoardDetailViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/18/24.
//

import UIKit
import SnapKit
import Then
import Combine
import Kingfisher
import SkeletonView

class BoardDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = BoardDetailViewModel()
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "게시글 제목"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 24)
    }
    
    private let settingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .appBlack
    }
    
    // 헤더뷰 요소들
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = Suite.bold.of(size: 16)
        $0.textColor = .appBlack
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    private lazy var likeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseForegroundColor = .appBlack
        $0.configuration = config
    }
    
    private lazy var commentButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "ellipsis.message")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseForegroundColor = .appDeepDarkGray
        $0.configuration = config
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appGreen
        navigationController?.navigationBar.isHidden = false
        setupViews()
        setupConstraints()
        setupBindings()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, settingButton, profileImageView, nicknameLabel, dateLabel, likeButton, commentButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        settingButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nicknameLabel)
        }
        
        commentButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        likeButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalTo(commentButton.snp.leading).offset(-16)
        }
    }
    
    private func setupBindings() {
        viewModel.$boardDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                self?.updateUI(with: detail)
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        settingButton.isUserInteractionEnabled = true
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UI Update
    private func updateUI(with detail: BoardDetail?) {
        guard let detail = detail else { return }
        
        titleLabel.text = detail.title
        nicknameLabel.text = detail.author
        dateLabel.text = detail.date
        updateLikeButton(count: detail.likeCount, isLiked: detail.isLiked)
        updateCommentButton(count: detail.commentCount)
        
        // 프로필 이미지 로딩 로직 (예: Kingfisher 사용)
        // profileImageView.kf.setImage(with: URL(string: detail.profileImageUrl))
    }
    
    private func updateLikeButton(count: Int, isLiked: Bool) {
        var config = likeButton.configuration
        config?.image = UIImage(systemName: isLiked ? "heart.fill" : "heart")
        config?.title = "\(count)"
        config?.baseForegroundColor = isLiked ? .red : .appBlack
        likeButton.configuration = config
    }
    
    private func updateCommentButton(count: Int) {
        var config = commentButton.configuration
        config?.title = "\(count)"
        commentButton.configuration = config
    }
    
    // MARK: - Actions
    @objc private func likeButtonTapped() {
        print("좋아요 버튼 탭됨")
        viewModel.toggleLike()
    }
    
    @objc private func commentButtonTapped() {
        print("댓글 버튼 탭됨")
        // 여기에 댓글 화면으로 이동하는 로직을 추가할 수 있습니다.
    }
    
    @objc private func settingButtonTapped() {
        print("설정 버튼 탭됨")
        // 여기에 게시글 설정 화면으로 이동하는 로직을 추가할 수 있습니다.
    }
}
