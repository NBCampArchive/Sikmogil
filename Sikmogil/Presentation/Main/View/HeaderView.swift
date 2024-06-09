//
//  HeaderView.swift
//  Sikmogil
//
//  Created by 문기웅 on 6/9/24.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderView"
    
    let dot = UIView().then {
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .appYellow
    }
    
    let titleLabel = UILabel().then {
        $0.font = Suite.bold.of(size: 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(dot, titleLabel)
        
        dot.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(10)
            $0.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(dot.snp.centerY)
            $0.leading.equalTo(dot.snp.trailing).offset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
