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
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        return CGSize(width: max(size.width, 100), height: size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 25
        
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
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8).priority(.low)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
}
