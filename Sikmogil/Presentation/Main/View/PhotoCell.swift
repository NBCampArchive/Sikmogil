//
//  PhotoCell.swift
//  Sikmogil
//
//  Created by 문기웅 on 6/9/24.
//

import UIKit
import SnapKit
import Then
import SkeletonView

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
    }
    
    let noImageLabel = UILabel().then {
        $0.text = "추가된 사진이 없습니다."
        $0.font = Suite.bold.of(size: 16)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupSkeleton()
        noImageLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        noImageLabel.isHidden = true
    }
    
    private func setupSkeleton() {
        imageView.isSkeletonable = true
        noImageLabel.isSkeletonable = true
        contentView.isSkeletonable = true
    }
    
    func showSkeleton() {
        contentView.showAnimatedGradientSkeleton()
    }
    
    func hideSkeleton() {
        contentView.hideSkeleton()
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(noImageLabel)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        noImageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
