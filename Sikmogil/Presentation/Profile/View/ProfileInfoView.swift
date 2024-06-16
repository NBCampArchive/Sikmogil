//
//  ProfileInfoView.swift
//  Sikmogil
//
//  Created by Developer_P on 6/7/24.
//

//
//  ProfileInfoView.swift
//  Sikmogil
//
//  Created by Developer_P on 6/7/24.
//

import UIKit
import SnapKit
import Then

class ProfileInfoView: UIView {
    
    // MARK: - 클래스의 속성(프로퍼티)들을 정의
    private let weightStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let heightStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let genderStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    private let weightTitleLabel = UILabel().then {
        $0.text = "몸무게"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appBlack
    }
    
    private let weightUnitLabel = UILabel().then {
        $0.text = "kg"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appBlack
    }
    
    var weightLabel = UILabel().then {
        $0.text = "0.0"
        $0.font = Suite.bold.of(size: 16)
    }
    
    private let heightTitleLabel = UILabel().then {
        $0.text = "키"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appBlack
    }
    
    private let heightUnitLabel = UILabel().then {
        $0.text = "cm"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appBlack
    }
    
    var heightLabel = UILabel().then {
        $0.text = "000"
        $0.font = Suite.bold.of(size: 16)
    }
    
    private let genderTitleLabel = UILabel().then {
        $0.text = "성별"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appBlack
    }
    
    var genderLabel = UILabel().then {
        $0.text = "남자"
        $0.font = Suite.bold.of(size: 16)
    }
    
    private let separator1 = UIView().then {
        $0.backgroundColor = .appDarkGray
    }
    
    private let separator2 = UIView().then {
        $0.backgroundColor = .appDarkGray
    }
    
    // MARK: - 초기화 메서드를 정의
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 사용자 인터페이스(UI)를 설정하는 메서드를 정의
    private func setupViews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 4
        
        let weightStack = UIStackView(arrangedSubviews: [weightLabel, weightUnitLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        
        let heightStack = UIStackView(arrangedSubviews: [heightLabel, heightUnitLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        
        weightStackView.addArrangedSubview(weightTitleLabel)
        weightStackView.addArrangedSubview(weightStack)
        
        heightStackView.addArrangedSubview(heightTitleLabel)
        heightStackView.addArrangedSubview(heightStack)
        
        genderStackView.addArrangedSubview(genderTitleLabel)
        genderStackView.addArrangedSubview(genderLabel)
        
        self.addSubview(weightStackView)
        self.addSubview(heightStackView)
        self.addSubview(genderStackView)
        self.addSubview(separator1)
        self.addSubview(separator2)
    }
    
    // MARK: - 제약조건을 설정하는 메서드를 정의
    private func setupConstraints() {
        weightStackView.snp.makeConstraints {
            $0.left.equalTo(self).offset(16)
            $0.centerY.equalTo(self)
            $0.width.equalTo(heightStackView)
        }
        
        heightStackView.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.centerY.equalTo(self)
            $0.width.equalTo(genderStackView)
        }
        
        genderStackView.snp.makeConstraints {
            $0.right.equalTo(self).offset(-16)
            $0.centerY.equalTo(self)
            $0.width.equalTo(weightStackView)
        }
        
        separator1.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.left.equalTo(weightStackView.snp.right).offset(8)
            $0.right.equalTo(heightStackView.snp.left).offset(-8)
            $0.width.equalTo(1)
            $0.height.equalTo(30)
        }
        
        separator2.snp.makeConstraints {
            $0.centerY.equalTo(self)
            $0.left.equalTo(heightStackView.snp.right).offset(8)
            $0.right.equalTo(genderStackView.snp.left).offset(-8)
            $0.width.equalTo(1)
            $0.height.equalTo(30)
        }
        
        [weightTitleLabel, weightLabel, weightUnitLabel, heightTitleLabel, heightLabel, heightUnitLabel, genderTitleLabel, genderLabel].forEach { label in
            label.snp.makeConstraints {
                $0.height.equalTo(30)
            }
        }
    }
}
