//
//  ExerciseTimerViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/4/24.
//

import UIKit

class ExerciseTimerViewController: UIViewController {
    
    // TODO: 프로그레스 바
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00 : 00"
        label.font = Suite.semiBold.of(size: 60)
        return label
    }()
    
    
    // TODO: 버튼 상태 변화 -> 이미지 변경, Timer
    private let stopPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(.pause, for: .normal)
        return button
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "START"
        label.font = Suite.semiBold.of(size: 24)
        label.textColor = .customGreen
        return label
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("기록하기", for: .normal)
        button.titleLabel?.font = Suite.bold.of(size: 18)
        button.backgroundColor = .customBlack
        button.tintColor = .white
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButton()
    }
    
    // MARK: - Setup View
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(timeLabel, stopPauseButton, statusLabel, recordButton)
    }
    
    private func setupConstraints() {
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(240)
            $0.centerX.equalToSuperview()
        }
        
        stopPauseButton.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(34)
            $0.centerX.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(stopPauseButton.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        recordButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Setup Button
    private func setupButton() {
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
    }
    
    @objc private func recordButtonTapped() {
        let exerciseResultVC = ExerciseResultViewController()
        navigationController?.pushViewController(exerciseResultVC, animated: true)
    }
}
