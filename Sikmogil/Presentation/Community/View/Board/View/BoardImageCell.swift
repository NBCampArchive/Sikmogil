//
//  File.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/21/24.
//

import UIKit
import SnapKit
import Kingfisher

class BoardImageCell: UICollectionViewCell {
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
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
        contentView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with imageUrl: String) {
        imageView.kf.setImage(with: URL(string: imageUrl))
    }
}
