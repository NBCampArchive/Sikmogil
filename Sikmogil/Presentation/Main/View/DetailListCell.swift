//
//  DetailListCell.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/15/24.
//

import UIKit
import SnapKit
import Then

class DetailListCell: UICollectionViewCell {
    static let reuseIdentifier = "DetailListCell"
    let titleLabel = UILabel().then {
        $0.font = Suite.medium.of(size: 12)
    }
    let subtitleLabel = UILabel().then {
        $0.font = Suite.light.of(size: 12)
        $0.textColor = .appDarkGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
}
