//
//  File.swift
//  Sikmogil
//
//  Created by 희라 on 6/4/24.
//  [View] **설명** 물마시기 추가 바텀시트 페이지

import UIKit
import SnapKit
import Then

class WaterBottomSheetViewController: UIViewController {
    
    // MARK: - UI components
    let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.text = "마신 물을 기록해보세요!"
        $0.textColor = .appBlack
        $0.font = Suite.medium.of(size: 16)
        $0.textAlignment = .center
    }
    let waterRecordTextField = UITextField().then {
        $0.text = "000 ml"
        $0.textColor = .appDarkGray
        $0.font = Suite.bold.of(size: 48)
        $0.textAlignment = .center
    }
    let doneButton = UIButton().then{
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .appBlack
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubviews(contentView)
        contentView.addSubviews(titleLabel,waterRecordTextField,doneButton)
    }

    private func setupConstraints() {
        contentView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(26)
            $0.centerX.equalToSuperview()
        }
        waterRecordTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(55)
            $0.centerX.equalToSuperview()
        }
        doneButton.snp.makeConstraints{
            $0.top.equalTo(waterRecordTextField.snp.bottom).offset(66)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(361)
            $0.height.equalTo(60)
        }
    }
}
