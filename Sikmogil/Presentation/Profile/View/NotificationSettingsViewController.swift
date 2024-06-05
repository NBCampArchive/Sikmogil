//
//  NotificationSettingsViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/5/24.
//

import UIKit
import SnapKit
import Then

class NotificationSettingsViewController: UIViewController {

    // UI Elements
    private let titleLabel = UILabel().then {
        $0.text = "알림 설정"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "알림/소리를 설정해보세요."
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    private let reminderButton = UIButton().then {
        $0.setTitle("리마인드 알림 시간 설정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.contentHorizontalAlignment = .left
    }
    
    private let notificationSwitch = UISwitch().then {
        $0.isOn = true
    }
    
    private let notificationLabel = UILabel().then {
        $0.text = "Notification"
        $0.font = UIFont.systemFont(ofSize: 16)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(reminderButton)
        view.addSubview(notificationLabel)
        view.addSubview(notificationSwitch)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
        reminderButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        notificationLabel.snp.makeConstraints {
            $0.top.equalTo(reminderButton.snp.bottom).offset(32)
            $0.leading.equalTo(reminderButton)
        }
        
        notificationSwitch.snp.makeConstraints {
            $0.centerY.equalTo(notificationLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
