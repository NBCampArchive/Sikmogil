//
//  ExerciseResultViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/4/24.
//

import UIKit
import SnapKit
import Then

class ExerciseResultViewController: UIViewController {

    // MARK: - Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let cardView = UIView().then {
        $0.backgroundColor = .appLightGray
    }

    private let checkImage = UIImageView().then {
        $0.image = .check
        $0.contentMode = .scaleAspectFit
    }

    private let completionLabel = UILabel().then {
        $0.text = "운동을 끝마쳤습니다!"
        $0.font = Suite.semiBold.of(size: 20)
        $0.textColor = .appBlack
    }

    private let cardStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }

    private let progressView = UIView().then {
        $0.backgroundColor = .clear
    }

    private let circularProgressBar = CircularProgressBar().then {
        $0.backgroundColor = .clear
        $0.progressColor = .appGreen
        $0.trackColor = .appLightGray
    }

    private let progressLabel = UILabel().then {
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 20)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        let fullText = "예상 소모 칼로리는\n0kcal 예요"
        let font = Suite.semiBold.of(size: 20)
        let changeText = "0kcal"
        let color = UIColor.appGreen
        $0.setAttributedText(fullText: fullText, changeText: changeText, color: color, font: font)
    }

    private let resultView = UIView()

    private let runningImage = UIImageView().then {
        $0.image = .running
        $0.contentMode = .scaleAspectFit
    }

    private let periodLable = UILabel().then {
        $0.text = "0:00 am - 0:00 am"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appDarkGray
    }

    private let verticalLine = UIView().then {
        $0.backgroundColor = .appDarkGray
    }

    private let timeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    private let kcalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    private let timeLabel = UILabel().then {
        $0.text = "Time"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appDarkGray
    }

    private let kcalLabel = UILabel().then {
        $0.text = "kcal"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appDarkGray
    }

    private let timeValueLabel = UILabel().then {
        $0.text = "0h.00min"
        $0.font = Suite.medium.of(size: 18)
        $0.textColor = .appBlack
    }

    private let kcalValueLabel = UILabel().then {
        $0.text = "0Kcal"
        $0.font = Suite.medium.of(size: 18)
        $0.textColor = .appBlack
    }

    private let addButton = UIButton().then {
        $0.setTitle("추가하기", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 20)
        $0.tintColor = .white
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        circularProgressBar.progress = 0.6
        
        view.addSubviews(scrollView, addButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(cardView, progressView, resultView)
        cardStackView.addArrangedSubviews(checkImage, completionLabel)
        cardView.addSubview(cardStackView)
        progressView.addSubviews(circularProgressBar, progressLabel)
        resultView.addSubviews(runningImage, verticalLine, timeStackView, kcalStackView)
        timeStackView.addArrangedSubviews(timeLabel, timeValueLabel)
        kcalStackView.addArrangedSubviews(kcalLabel, kcalValueLabel)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        cardView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.top.equalToSuperview().inset(16)
            $0.height.equalTo(64)
        }
        
        cardStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        checkImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        progressView.snp.makeConstraints {
            $0.width.height.equalTo(300)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cardView.snp.bottom).offset(50)
        }
        
        circularProgressBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        progressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        resultView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.top.equalTo(progressView.snp.bottom).offset(40)
        }
        
        runningImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(32)
        }
        
//        periodLable.snp.makeConstraints {
//            $0.centerY.equalTo(runningImage)
//            $0.leading.equalTo(runningImage.snp.trailing).offset(4)
//        }
        
        verticalLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(76)
            $0.centerX.equalTo(runningImage)
            $0.top.equalTo(runningImage.snp.bottom).offset(20)
            $0.bottom.equalTo(resultView).inset(20)
        }
        
        timeStackView.snp.makeConstraints {
            $0.leading.equalTo(verticalLine).offset(20)
            $0.centerY.equalTo(verticalLine)
        }

        kcalStackView.snp.makeConstraints {
            $0.trailing.equalTo(resultView).inset(16)
            $0.centerY.equalTo(verticalLine)
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(resultView.snp.bottom).offset(100)
        }
        
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).inset(26)
            $0.height.equalTo(60)
        }
    }
}
