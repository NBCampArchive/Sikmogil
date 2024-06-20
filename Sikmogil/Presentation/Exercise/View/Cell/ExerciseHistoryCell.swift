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
    
    private let exerciseIconMapping: [String: String] = [
        "런닝": "runningIcon",
        "수영": "swimmingIcon",
        "자전거": "bicycleIcon",
        "등산": "hikingIcon",
        "걷기": "walkingIcon",
        "요가": "yogaIcon",
        "줄넘기": "jumpingIcon",
        "필라테스": "pilatesIcon",
        "웨이트 트레이닝": "weightIcon",
        "복합 유산소 운동": "aerobicsIcon",
        "고강도 인터벌 트레이닝": "HIITIcon",
        "근력 강화 운동": "strengthIcon",
        "기타": "exerciseIcon"
    ]
    
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(exercise: ExerciseListModel) {
        if let iconName = exerciseIconMapping[exercise.performedWorkout],
           let image = UIImage(named: iconName) {
            exerciseImageView.image = image
        } else {
            exerciseImageView.image = UIImage.exerciseIcon
        }
        exerciseLabel.text = exercise.performedWorkout
        caloriesLabel.text = "\(exercise.calorieBurned) kcal"
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubviews(exerciseImageView, exerciseLabel, caloriesLabel)
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
        
        caloriesLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
    }
}
