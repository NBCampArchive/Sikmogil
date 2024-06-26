//
//  ExerciseAlbumCell.swift
//  Sikmogil
//
//  Created by 정유진 on 6/26/24.
//

import UIKit
import SnapKit
import Then

class ExerciseAlbumCell: UICollectionViewCell {
    static let identifier = "ExerciseAlbumCell"
    
    // MARK: - UI components
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let dataLabel = UILabel().then {
        $0.text = "날짜"
        $0.textColor = .white
        $0.font = Suite.bold.of(size: 12)
        $0.textAlignment = .left
    }
    
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
        contentView.addSubviews(imageView,dataLabel)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dataLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(imageView.snp.bottom).inset(4)
        }
    }
}
