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
    
    private let scrollView = UIScrollView().then {
        $0.isSkeletonable = true
    }
    
    private let contentView = UIView().then {
        $0.isSkeletonable = true
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "게시글 제목"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 24)
    }
    
    private let settingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .appBlack
    }
    
    private let detailHeaderView = BoardDetailHeaderView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appGreen
        navigationController?.navigationBar.isHidden = false
        setupViews()
        setupConstraints()
        detailHeaderView.configure(with: "nickname", date: "2024.07.18", likeCount: 10, commentCount: 5, profileImage: UIImage(named: "profile"))
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, settingButton, detailHeaderView)
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
        
        detailHeaderView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
}
