//
//  ReminderSettingsViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/6/24.
//

import UIKit
import SnapKit
import Then

class ReminderSettingsViewController: UIViewController {
    
    // MARK: - 속성정의
    private let titleLabel = UILabel().then {
        $0.text = "리마인드 알림 시간 설정"
        $0.font = Suite.bold.of(size: 24)
        $0.textColor = .appBlack
    }
    
    // MARK: - 생명주기정의
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        
        // MARK: - 레이아웃
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}
