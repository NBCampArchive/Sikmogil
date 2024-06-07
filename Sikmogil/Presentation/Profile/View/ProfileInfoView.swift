//
//  ProfileInfoView.swift
//  Sikmogil
//
//  Created by Developer_P on 6/7/24.
//

import UIKit
import SnapKit
import Then

class ProfileInfoView: UIView { // 키 | 몸무게 | 성별
    
    // MARK: - 클래스의 속성(프로퍼티)들을 정의
    let weightStackView = createVerticalStackView()
    let heightStackView = createVerticalStackView()
    let genderStackView = createVerticalStackView()
    
    let separator1 = createSeparator()
    let separator2 = createSeparator()
    
    let weightTitleLabel = createTitleLabel(text: "몸무게")
    let weightLabel = createDetailLabel(text: "0.0kg")
    let heightTitleLabel = createTitleLabel(text: "키")
    let heightLabel = createDetailLabel(text: "000cm")
    let genderTitleLabel = createTitleLabel(text: "성별")
    let genderLabel = createDetailLabel(text: "남자")
    
    // MARK: - 초기화 메서드를 정의
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 사용자 인터페이스(UI)를 설정하는 메서드를 정의
    private func setupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 4
        
        weightStackView.addArrangedSubview(weightTitleLabel)
        weightStackView.addArrangedSubview(weightLabel)
        
        heightStackView.addArrangedSubview(heightTitleLabel)
        heightStackView.addArrangedSubview(heightLabel)
        
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
        
        weightTitleLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        heightTitleLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        genderTitleLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        weightLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        heightLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        genderLabel.snp.makeConstraints {
            $0.height.equalTo(30)
        }
    }
}

// MARK: - 헬퍼 함수들을 정의
private func createVerticalStackView() -> UIStackView {
    return UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
    }
}

private func createSeparator() -> UIView {
    return UIView().then {
        $0.backgroundColor = .appDarkGray
    }
}

private func createTitleLabel(text: String) -> UILabel {
    return UILabel().then {
        $0.text = text
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appBlack
    }
}

private func createDetailLabel(text: String) -> UILabel {
    return UILabel().then {
        $0.text = text
        $0.font = Suite.bold.of(size: 16)
    }
}
