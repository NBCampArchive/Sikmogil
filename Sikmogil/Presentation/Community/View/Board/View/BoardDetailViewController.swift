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
import FloatingPanel

class BoardDetailViewController: UIViewController {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = BoardDetailViewModel()
    
    private var commentPanel: FloatingPanelController!
    private var previousPanelState: FloatingPanelState = .hidden
    
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
        $0.backgroundColor = .appBlack
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = Suite.bold.of(size: 16)
        $0.textColor = .appBlack
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDeepDarkGray
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = .appDeepDarkGray
    }
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 300)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BoardImageCell.self, forCellWithReuseIdentifier: "BoardImageCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appBlack
    }
    
    private lazy var likeButton = UIButton(configuration: .plain()).then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")?.withTintColor(.appBlack, renderingMode: .alwaysOriginal)
        config.imagePlacement = .leading
        config.imagePadding = 8
        
        // 텍스트 스타일 설정
        config.baseForegroundColor = .appBlack
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.foregroundColor = .appBlack
            return outgoing
        }
        
        // 버튼 배경 스타일 설정
        config.background.backgroundColor = .clear
        
        $0.configuration = config
        
        // 추가적인 버튼 상태별 스타일 설정
        $0.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.foregroundColor = .appBlack
                return outgoing
            }
            button.configuration = config
        }
    }
    
    private lazy var commentButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "ellipsis.message")
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.baseForegroundColor = .appBlack
        $0.configuration = config
    }
    
    private let commentListButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "ellipsis.message.fill")
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.buttonSize = .large
        config.cornerStyle = .capsule
        config.background.backgroundColor = .appBlack
        config.baseForegroundColor = .white
        $0.configuration = config
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        setupViews()
        setupConstraints()
        setupBindings()
        setupActions()
        setupFloatingPanel()
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, settingButton, profileImageView, nicknameLabel, dateLabel, likeButton, commentButton, divider, imageCollectionView, contentLabel, commentListButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            //            $0.height.equalTo(800)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(settingButton.snp.leading).offset(-4)
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
            $0.trailing.equalTo(commentButton.snp.leading).offset(-4)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(300)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        commentListButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
        }
    }
    
    private func setupBindings() {
        viewModel.$boardDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                self?.updateUI(with: detail)
            }
            .store(in: &cancellables)
        
        viewModel.$localLikeCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.updateLikeButton(count: count, isLiked: self?.viewModel.isLikedLocally ?? false)
            }
            .store(in: &cancellables)
        
        viewModel.$isLikedLocally
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLiked in
                self?.updateLikeButton(count: self?.viewModel.localLikeCount ?? 0, isLiked: isLiked)
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        settingButton.isUserInteractionEnabled = true
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        commentListButton.addTarget(self, action: #selector(commentListButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UI Update
    private func updateUI(with detail: BoardDetailData?) {
        guard let detail = detail else { return }
        
        titleLabel.text = detail.title
        nicknameLabel.text = detail.nickname
        dateLabel.text = DateHelper.shared.formatServerDateYMD(from: detail.date)
        
        updateLikeButton(count: detail.likeCount, isLiked: detail.isLike)
        updateCommentButton(count: detail.commentCount)
        
        contentLabel.text = detail.content
        imageCollectionView.reloadData()
        
        // 프로필 이미지 로딩 로직 (예: Kingfisher 사용)
        // profileImageView.kf.setImage(with: URL(string: detail.profileImageUrl))
    }
    
    private func updateLikeButton(count: Int, isLiked: Bool) {
        var config = likeButton.configuration
        
        // 이미지 설정 및 색상 변경
        let heartImage = UIImage(systemName: isLiked ? "heart.fill" : "heart")
        config?.image = heartImage?.withTintColor(isLiked ? .red : .appBlack, renderingMode: .alwaysOriginal)
        
        // 텍스트 설정
        config?.title = "\(count)"
        
        // 텍스트 색상 설정 (항상 .appBlack으로 유지)
        config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.foregroundColor = .appBlack
            return outgoing
        }
        
        likeButton.configuration = config
        
        // 버튼 상태 업데이트를 강제로 트리거
        likeButton.setNeedsUpdateConfiguration()
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
    
    private func setupFloatingPanel() {
        commentPanel = FloatingPanelController()
        
        let contentVC = CommentListViewController()
        commentPanel.set(contentViewController: contentVC)
        
        commentPanel.layout = CustomFloatingPanelLayout()
        commentPanel.isRemovalInteractionEnabled = true
        commentPanel.changePanelStyle()
        commentPanel.delegate = self
    }
    
    @objc private func commentListButtonTapped() {
        commentPanel.addPanel(toParent: self)
        commentPanel.move(to: .half, animated: true)
    }
    
}

extension BoardDetailViewController: UICollectionViewDelegate {
    
}

extension BoardDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.boardDetail?.imageUrl.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardImageCell", for: indexPath) as? BoardImageCell,
              let imageUrl = viewModel.boardDetail?.imageUrl[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: imageUrl)
        return cell
    }
}

extension BoardDetailViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ vc: FloatingPanelController) {
        if vc.state == .full {
            tabBarController?.tabBar.isHidden = true
            vc.backdropView.dismissalTapGestureRecognizer.isEnabled = false
        } else if vc.state == .half  {
            tabBarController?.tabBar.isHidden = true
            vc.backdropView.dismissalTapGestureRecognizer.isEnabled = false
            
            if previousPanelState == .full {
                view.endEditing(true)
            }
        } else {
            vc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        }
        previousPanelState = vc.state
    }
    
    func floatingPanelDidRemove(_ vc: FloatingPanelController) {
        tabBarController?.tabBar.isHidden = false
        vc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
    }
}

// MARK: - Keyboard Handling
extension BoardDetailViewController {
    // 키보드가 나타날 때 호출되는 메서드
    @objc override func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if userInfo[UIResponder.keyboardFrameEndUserInfoKey] is CGRect {
            // FloatingPanel 높이 수정
            commentPanel.move(to: .full, animated: true)
        }
    }
    
    // 키보드가 사라질 때 호출되는 메서드
    @objc override func keyboardWillHide(notification: NSNotification) {
        commentPanel.move(to: .half, animated: true)
    }
}
