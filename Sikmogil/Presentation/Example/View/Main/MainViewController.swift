//
//  MainViewController.swift
//  Sikmogil
//
//  Created by 문기웅 on 6/3/24.
//

import UIKit
import DGCharts

class MainViewController: UIViewController {
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    private let scrollSubView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let goalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let goalLabel = UILabel().then {
        $0.text = "목표"
        $0.font = Suite.bold.of(size: 28)
    }
    
    private let calendarButton = UIButton().then {
        $0.setImage(.calendar, for: .normal)
    }
    
    private let weightLabel = UILabel().then {
        $0.text = "목표까지 남은기간 N일!"
        $0.font = Suite.semiBold.of(size: 16)
        $0.textColor = .appDarkGray
    }
    
    private let progressLabel = UILabel().then {
        $0.text = "시작일 ~ 목표일"
        $0.font = Suite.semiBold.of(size: 16)
        $0.textColor = .appDarkGray
    }
    
    private let dateProgressView = UIProgressView().then {
        $0.progress = 0.5
        $0.trackTintColor = .appLightGray
        $0.progressTintColor = .appYellow
        $0.progressViewStyle = .bar
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    private let percentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 6
        $0.layer.cornerRadius = 25
        $0.layer.borderColor = UIColor.appYellow.cgColor
    }
    
    private let percentLabel = UILabel().then {
        $0.text = "50%"
        $0.font = Suite.semiBold.of(size: 16)
    }
    
    private let weightLogLabel = UILabel().then {
        $0.text = "체중 기록"
        $0.font = Suite.bold.of(size: 28)
    }
    
    private let weightNowLabel = UILabel().then {
        $0.text = "현재 체중 N Kg"
        $0.font = Suite.bold.of(size: 16)
        $0.textColor = .appDarkGray
    }
    
    private let weightToGoalLabel = UILabel().then {
        $0.text = "목표까지 N Kg"
        $0.font = Suite.bold.of(size: 22)
        $0.textColor = .appDarkGray
    }
    
    private let scaleImage = UIImageView().then {
        $0.backgroundColor = .appLightGray
    }
    
    private let recordButton = UIButton().then {
        $0.setTitle("기록하기", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.tintColor = .white
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
    
    private let graphLabel = UILabel().then {
        $0.text = "진행 그래프"
        $0.font = Suite.bold.of(size: 28)
    }
    
    private let graph = BarChartView().then {
        $0.backgroundColor = .appLightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
    }
    
    
    private func setupViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollSubView)
        
        scrollSubView.addSubviews(goalStackView,
                                  calendarButton,
                                  dateProgressView,
                                  percentView,
                                  weightLogLabel,
                                  weightNowLabel,
                                  weightToGoalLabel,
                                  scaleImage,
                                  recordButton,
                                  graphLabel,
                                  graph)
        
        goalStackView.addArrangedSubviews(goalLabel, weightLabel, progressLabel)
        goalStackView.setCustomSpacing(16, after: weightLabel)
        
        percentView.addSubview(percentLabel)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollSubView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(950)
        }
        
        goalStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        calendarButton.snp.makeConstraints {
            $0.centerY.equalTo(goalLabel.snp.centerY)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        dateProgressView.snp.makeConstraints {
            $0.top.equalTo(goalStackView.snp.bottom).offset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(16)
        }
        
        percentView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(50)
            $0.centerY.equalTo(dateProgressView.snp.centerY)
            // 퍼센트에따라 위치변경 필요
            $0.centerX.equalTo(dateProgressView.frame.size.width * CGFloat(dateProgressView.progress))
        }
        
        percentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        weightLogLabel.snp.makeConstraints {
            $0.top.equalTo(percentView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        weightNowLabel.snp.makeConstraints {
            $0.top.equalTo(weightLogLabel.snp.bottom).offset(16)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        weightToGoalLabel.snp.makeConstraints {
            $0.top.equalTo(weightNowLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        scaleImage.snp.makeConstraints {
            $0.top.equalTo(weightToGoalLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }
        
        recordButton.snp.makeConstraints {
            $0.top.equalTo(scaleImage.snp.bottom).offset(8)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-18)
            $0.height.equalTo(48)
        }
        
        graphLabel.snp.makeConstraints {
            $0.top.equalTo(recordButton.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        graph.snp.makeConstraints {
            $0.top.equalTo(graphLabel.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(300)
        }
    }
    
}
