//
//  AddDietTableViewCell.swift
//  Sikmogil
//
//  Created by 희라 on 6/5/24.
//  [Cell] **설명** 식사추가 페이지 테이블 뷰 셀

import UIKit
import SnapKit
import Then

class AddDietMenuTableViewCell: UITableViewCell {
    
    static let identifier = "AddDietMenuTableViewCell"
    
    // MARK: - UI components
    let loundView = UIView().then{
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 15
    }
    let contentArea = UIView().then{
        $0.backgroundColor = .appLightGray
    }
    let cellTitleLabel = UILabel().then {
        $0.text = "식품명"
        $0.textColor = .appBlack
        $0.font = Suite.semiBold.of(size: 18)
        $0.textAlignment = .left
    }
    let cellInfoLabel = UILabel().then {
        $0.text = "제공량"
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 12)
        $0.textAlignment = .left
    }
    let plusButton = UIButton().then {
        $0.setImage(UIImage(named: "addRingDuotone"), for: .normal)
        $0.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    let cellKcalLabel = UILabel().then {
        $0.text = "칼로리"
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 12)
        $0.textAlignment = .left
    }
    
    var foodItem: FoodItem?
    var addMealAction: ((FoodItem) -> Void)?
    
    // MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellTitleLabel.text = nil
        cellInfoLabel.text = nil
        cellKcalLabel.text = nil
        plusButton.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        contentView.addSubview(loundView)
        loundView.addSubview(contentArea)
        contentArea.addSubviews(cellTitleLabel,cellInfoLabel,plusButton,cellKcalLabel)
    }
    
    private func setupConstraints() {
        loundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().inset(4)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        contentArea.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
        cellTitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        cellInfoLabel.snp.makeConstraints{
            $0.bottom.equalTo(contentArea.snp.bottom)
            $0.leading.equalToSuperview()
        }
        plusButton.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.trailing.equalTo(contentArea.snp.trailing)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        cellKcalLabel.snp.makeConstraints{
            $0.bottom.equalTo(contentArea.snp.bottom)
            $0.trailing.equalTo(contentArea.snp.trailing)
        }
    }
    
    // MARK: - Action
    @objc private func plusButtonTapped() {
        if let foodItem = foodItem {
            addMealAction?(foodItem)
            print(foodItem.foodNmKr)
        }
    }
}
