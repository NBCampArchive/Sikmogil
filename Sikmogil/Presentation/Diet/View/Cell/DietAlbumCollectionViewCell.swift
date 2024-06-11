//
//  DietAlbumCollectionViewCell.swift
//  Sikmogil
//
//  Created by 희라 on 6/5/24.
//  [Cell] **설명** 식사 앨범 컬렉션뷰 셀

import UIKit

class DietAlbumCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DietAlbumCollectionViewCell"
    
    // MARK: - UI components
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
