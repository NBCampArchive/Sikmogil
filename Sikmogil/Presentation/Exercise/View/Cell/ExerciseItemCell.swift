//
//  ExerciseItemCell.swift
//  Sikmogil
//
//  Created by 정유진 on 7/16/24.
//

import UIKit
import SnapKit
import Then

class ExerciseItemCell: UITableViewCell {

    static let identifier = "ExerciseItemCell"
    
    // MARK: - Components
    private let cardView = UIView().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 16
    }

    let exerciseLabel = UILabel().then {
        $0.font = Suite.semiBold.of(size: 18)
    }

    let plusButton = UIButton().then {
        $0.setImage(UIImage(named: "addRingDuotone"), for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubviews(exerciseLabel, plusButton)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
  
    private func setupConstraints() {
        cardView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        exerciseLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
    }

    // MARK: - Action
    func configure() {
        
    }
    
    @objc private func plusButtonTapped() {
      print("plusButtonTapped")
    }
}
