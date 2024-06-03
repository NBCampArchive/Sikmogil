//
//  ExerciseHistoryCell.swift
//  Sikmogil
//
//  Created by 정유진 on 6/3/24.
//

import UIKit
import SnapKit

// MARK: - ExerciseHistoryCell
class ExerciseHistoryCell: UITableViewCell {

    static let identifier = "ExerciseHistoryCell"
    
    private let exerciseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let exerciseLabel: UILabel = {
        let label = UILabel()
        label.font = Suite.semiBold.of(size: 16)
        return label
    }()
    
    private let caloriesLabel: UILabel = {
        let label = UILabel()
        label.font = Suite.bold.of(size: 16)
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        if let plusImage = UIImage(systemName: "plus") {
            button.setImage(plusImage, for: .normal)
        }
        button.tintColor = .customBlack
        return button
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage, exercise: String, calories: String) {
        exerciseImageView.image = image
        exerciseLabel.text = exercise
        caloriesLabel.text = calories
    }
    
    private func configureUI() {
        contentView.addSubviews(exerciseImageView, exerciseLabel, caloriesLabel, addButton)
        contentView.backgroundColor = .customLightGray
    }
    
    private func setupConstraints() {
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
