//
//  DietAlbumCollectionViewCell.swift
//  Sikmogil
//
//  Created by 희라 on 6/5/24.
//

import UIKit

class DietAlbumCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DietAlbumCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // 셀의 뷰 구성 요소를 추가
    }
    
    private func setupConstraints() {
        // 셀의 레이아웃 설정
    }
}
