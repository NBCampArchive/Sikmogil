//
//  ExerciseViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/3/24.
//

import UIKit
import SnapKit

class ExerciseViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 22
        return stackView
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 활동을 기록해보세요!"
        label.font =  Suite.semiBold.of(size: 16)
        label.textColor = .customDarkGray
        return label
    }()
    
    let exerciseMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("운동", for: .normal)
        button.titleLabel?.font = Suite.bold.of(size: 28)
        button.tintColor = .customBlack
        return button
    }()
    
    let stepsMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("걸음 수", for: .normal)
        button.titleLabel?.font = Suite.bold.of(size: 28)
        button.tintColor = .customDarkGray
        return button
    }()
    
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .customLightGray
        return view
    }()
    
    private let historyLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 기록"
        label.font = Suite.bold.of(size: 28)
        label.textColor = .customBlack
        return label
    }()
    
    private let albumButton: UIButton = {
        let button = UIButton()
        button.setTitle("앨범", for: .normal)
        button.titleLabel?.font = Suite.semiBold.of(size: 16)
        button.tintColor = .white
        button.backgroundColor = .customBlack
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let startExerciseButton: UIButton = {
        let button = UIButton()
        button.setTitle("운동하기", for: .normal)
        button.titleLabel?.font = Suite.bold.of(size: 20)
        button.tintColor = .white
        button.backgroundColor = .customBlack
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubviews(scrollView, startExerciseButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(headerStackView, descriptionLabel, progressView, historyLabel, albumButton)
        headerStackView.addArrangedSubviews(exerciseMenuButton, stepsMenuButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(startExerciseButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(2000) // 스크롤뷰의 임시 높이
        }
        
        headerStackView.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(16)
            $0.top.equalToSuperview().inset(-30)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
        }
        
        progressView.snp.makeConstraints {
            $0.width.height.equalTo(300)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
        }
        
        historyLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(16)
            $0.top.equalTo(progressView.snp.bottom).offset(10)
        }
        
        albumButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView).inset(16)
            $0.width.equalTo(90)
            $0.height.equalTo(30)
            $0.centerY.equalTo(historyLabel)
        }
        
        startExerciseButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(26)
            $0.height.equalTo(60)
        }
    }
}

#Preview{
    ExerciseViewController()
}
