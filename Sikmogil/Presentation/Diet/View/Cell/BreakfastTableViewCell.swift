//
//  BreakfastTableViewCell.swift
//  Sikmogil
//
//  Created by 희라 on 6/19/24.
//

import UIKit
import SnapKit
import Then

class BreakfastTableViewCell: UITableViewCell {
    
    static let identifier = "BreakfastTableViewCell"
    
    // MARK: - UI components
    let nameLabel = UILabel().then {
        $0.text = "식품명"
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 14)
        $0.textAlignment = .left
    }
    let kcalLabel = UILabel().then {
        $0.text = "칼로리"
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 14)
        $0.textAlignment = .left
    }
    
    // MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        contentView.addSubviews(nameLabel,kcalLabel)
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(28)
            $0.trailing.equalTo(kcalLabel.snp.leading).offset(8)
        }
        kcalLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(28)
        }
    }
}
