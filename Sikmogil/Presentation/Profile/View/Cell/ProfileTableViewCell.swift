//
//  ProfileTableViewCell.swift
//  Sikmogil
//
//  Created by Developer_P on 6/3/24.
//  [프로필] ✨ 각각의 테이블 셀 아이콘 ✨

import UIKit
import SnapKit
import Then

class ProfileTableViewCell: UITableViewCell {

    // MARK: - 속성
    let iconImageView = UIImageView()
    let titleLabel = UILabel().then {
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appBlack
    }
    let arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .appBlack
    }
    let separator = UIView().then {
        $0.backgroundColor = .appDarkGray
    }

    // MARK: - 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 제약조건
    private func setupConstraints() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(separator)

        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(iconImageView.snp.right).offset(16)
        }

        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(12.5)
            $0.height.equalTo(18)
        }

        separator.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - 셀 아이콘 설정
    func configure(with title: String, iconName: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(named: iconName)
    }
}
