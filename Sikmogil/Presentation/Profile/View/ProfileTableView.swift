//
//  ProfileDetailsView.swift
//  Sikmogil
//
//  Created by Developer_P on 6/7/24.
//

import UIKit
import SnapKit
import Then

class ProfileDetailsView: UIView {

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(weightStackView)
        addSubview(heightStackView)
        addSubview(genderStackView)
        addSubview(separator1)
        addSubview(separator2)

        weightStackView.addArrangedSubview(weightTitleLabel)
        weightStackView.addArrangedSubview(weightLabel)

        heightStackView.addArrangedSubview(heightTitleLabel)
        heightStackView.addArrangedSubview(heightLabel)

        genderStackView.addArrangedSubview(genderTitleLabel)
        genderStackView.addArrangedSubview(genderLabel)

        weightStackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(heightStackView)
        }

        heightStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(genderStackView)
        }

        genderStackView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(weightStackView)
        }

        separator1.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(weightStackView.snp.right).offset(8)
            $0.right.equalTo(heightStackView.snp.left).offset(-8)
            $0.width.equalTo(1)
            $0.height.equalTo(30)
        }

        separator2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
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

    private static func createVerticalStackView() -> UIStackView {
        return UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .center
        }
    }

    private static func createSeparator() -> UIView {
        return UIView().then {
            $0.backgroundColor = .lightGray
        }
    }

    private static func createTitleLabel(text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.font = Suite.regular.of(size: 14)
            $0.textColor = .darkGray
        }
    }

    private static func createDetailLabel(text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.font = Suite.bold.of(size: 16)
        }
    }
}
