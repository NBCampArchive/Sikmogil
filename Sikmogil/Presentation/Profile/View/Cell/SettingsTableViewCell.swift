//
//  AlarmTableViewCell.swift
//  Sikmogil
//
//  Created by 박준영 on 6/6/24.
//  [프로필] ⚡️ 알림 셀 customSwitch 상세영역 ⚡️

import UIKit
import SnapKit
import Then

class SettingsTableViewCell: UITableViewCell {
    
    // MARK: - 속성
    static let identifier = "AlarmTableViewCell"
    
    let containerView = UIView().then {
        $0.layer.masksToBounds = true
    }
    
    let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let label = UILabel().then {
        $0.font = Suite.regular.of(size: 16)
    }
    
    let customSwitch = UISwitch().then {
        $0.onTintColor = .appGreen
    }
    
    let separatorLine = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let accessoryButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .appBlack
    }
    
    var showsAccessoryButton: Bool = true {
        didSet {
            accessoryButton.isHidden = !showsAccessoryButton
        }
    }
    
    var switchValueChanged: ((Bool) -> Void)?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(customSwitch)
        containerView.addSubview(accessoryButton)
        contentView.addSubview(separatorLine)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        customSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(accessoryButton.snp.leading).offset(16)
        }
        
        accessoryButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        separatorLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(stackView.snp.leading)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(1)
        }
        
        customSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    @objc private func switchChanged() {
        switchValueChanged?(customSwitch.isOn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
