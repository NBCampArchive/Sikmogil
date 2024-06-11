//
//  AlarmTableViewCell.swift
//  Sikmogil
//
//  Created by Developer_P on 6/6/24.
//

import UIKit
import SnapKit
import Then

class AlarmTableViewCell: UITableViewCell {
    
    // MARK: - 속성정의
    static let identifier = "AlarmTableViewCell"
    
    let containerView = UIView().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    let label = UILabel().then {
        $0.font = Suite.regular.of(size: 16)
    }
    
    let customSwitch = UISwitch().then {
        $0.onTintColor = .appSkyBlue
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
    
    // MARK: - 초기화 메서드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        containerView.addSubview(label)
        containerView.addSubview(customSwitch)
        containerView.addSubview(accessoryButton)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        label.snp.makeConstraints {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
