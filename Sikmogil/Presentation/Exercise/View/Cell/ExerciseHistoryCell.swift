//
//  ExerciseHistoryCell.swift
//  Sikmogil
//
//  Created by 정유진 on 6/3/24.
//

import UIKit
import SnapKit
import Then

// MARK: - ExerciseHistoryCell
class ExerciseHistoryCell: UITableViewCell {

    static let identifier = "ExerciseHistoryCell"
    
    // MARK: - Components
    private let cardView = UIView().then {
        $0.layer.cornerRadius = 16
    }

    private let exerciseImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let exerciseLabel = UILabel().then {
        $0.font = Suite.semiBold.of(size: 16)
    }

    private let caloriesLabel = UILabel().then {
        $0.font = Suite.bold.of(size: 16)
    }

    private let addButton = UIButton(type: .system).then {
        if let plusImage = UIImage(systemName: "plus") {
            $0.setImage(plusImage, for: .normal)
        }
        $0.tintColor = .appBlack
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(with image: UIImage, exercise: String, calories: String) {
        exerciseImageView.image = image
        exerciseLabel.text = exercise
        caloriesLabel.text = calories
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubviews(exerciseImageView, exerciseLabel, caloriesLabel, addButton)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        cardView.backgroundColor = .appLightGray
    }
    
    private func setupConstraints() {
        cardView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        exerciseImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        exerciseLabel.snp.makeConstraints {
            $0.leading.equalTo(exerciseImageView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        caloriesLabel.snp.makeConstraints {
            $0.trailing.equalTo(addButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
}
