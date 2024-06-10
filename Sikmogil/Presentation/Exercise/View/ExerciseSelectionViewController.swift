//
//  ExerciseSelectionViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/4/24.
//

import UIKit
import SnapKit

class ExerciseSelectionViewController: UIViewController {
   
    // MARK: - Components
    private let exerciseLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 종목"
        label.font = Suite.semiBold.of(size: 20)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 시간"
        label.font = Suite.semiBold.of(size: 20)
        return label
    }()
    
    private let intensityLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 강도"
        label.font = Suite.semiBold.of(size: 20)
        return label
    }()
    
    private let lightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가볍게", for: .normal)
        button.titleLabel?.font =  Suite.medium.of(size: 14)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.tintColor = .appBlack
        button.layer.borderColor = UIColor.appDarkGray.cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let moderateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("적당히", for: .normal)
        button.titleLabel?.font =  Suite.medium.of(size: 14)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.tintColor = .appBlack
        button.layer.borderColor = UIColor.appDarkGray.cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let intenseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("격하게", for: .normal)
        button.titleLabel?.font =  Suite.medium.of(size: 14)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.tintColor = .appBlack
        button.layer.borderColor = UIColor.appDarkGray.cgColor
        button.layer.cornerRadius = 16
        return button
    }()

    private let intensityStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let expectedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appDarkGray
        label.font = Suite.semiBold.of(size: 20)
        let fullText = "예상 소모 칼로리는 0kcal예요"
        let font = Suite.semiBold.of(size: 20)
        let changeText = "0kcal"
        let color = UIColor.appGreen
        label.setAttributedText(fullText: fullText, changeText: changeText, color: color, font: font)
        return label
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("기록하기", for: .normal)
        button.titleLabel?.font = Suite.bold.of(size: 18)
        button.backgroundColor = .appBlack
        button.tintColor = .white
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let measurementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("측정하기", for: .normal)
        button.titleLabel?.font = Suite.bold.of(size: 18)
        button.backgroundColor = .clear
        button.tintColor = .appBlack
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.appBlack.cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let buttonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
    }
    
    // MARK: - Setup View
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubviews(exerciseLabel, timeLabel, intensityLabel, exerciseLabel, intensityStackView, expectedLabel, buttonStackView)
        intensityStackView.addArrangedSubviews(lightButton, moderateButton, intenseButton)
        buttonStackView.addArrangedSubviews(recordButton, measurementButton)
    }
    
    private func setupConstraints() {
        exerciseLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(exerciseLabel.snp.bottom).offset(66)
            $0.leading.equalToSuperview().inset(32)
        }
        
        intensityLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(66)
            $0.leading.equalToSuperview().inset(32)
        }
        
        intensityStackView.snp.makeConstraints {
            $0.centerY.equalTo(intensityLabel)
            $0.trailing.equalToSuperview().inset(40)
        }
        
        lightButton.snp.makeConstraints {
            $0.width.equalTo(62)
            $0.height.equalTo(32)
        }
        
        expectedLabel.snp.makeConstraints {
            $0.top.equalTo(intensityLabel.snp.bottom).inset(-88)
            $0.centerX.equalToSuperview()
        }
       
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
    }
    
    // MARK: - Setup Buttons
    private func setupButtons() {
        lightButton.addTarget(self, action: #selector(intensityButtonTapped(_:)), for: .touchUpInside)
        moderateButton.addTarget(self, action: #selector(intensityButtonTapped(_:)), for: .touchUpInside)
        intenseButton.addTarget(self, action: #selector(intensityButtonTapped(_:)), for: .touchUpInside)
       
        recordButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
        measurementButton.addTarget(self, action: #selector(startButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func intensityButtonTapped(_ sender: UIButton) {
        print("\(sender.currentTitle ?? "") Button tapped")
        [lightButton, moderateButton, intenseButton].forEach {
            $0.backgroundColor = .clear
            $0.tintColor = .appBlack
            $0.layer.borderColor = UIColor.appDarkGray.cgColor
        }
        
        sender.backgroundColor = .appBlack
        sender.tintColor = .white
        sender.layer.borderColor = UIColor.clear.cgColor
    }
    
    @objc private func startButtonTapped(_ sender: UIButton) {
        print("\(sender.currentTitle ?? "") Button tapped")
        [recordButton, measurementButton].forEach {
            $0.backgroundColor = .clear
            $0.tintColor = .appBlack
            $0.layer.borderColor = UIColor.appDarkGray.cgColor
            $0.layer.borderWidth = 2
        }
        
        sender.backgroundColor = .appBlack
        sender.tintColor = .white
        sender.layer.borderColor = UIColor.clear.cgColor
        
        if sender == measurementButton {
            navigateToMeasurementScreen()
        }
    }
    
    private func navigateToMeasurementScreen() {
        let exerciseTimerVC = ExerciseTimerViewController()
        navigationController?.pushViewController(exerciseTimerVC, animated: true)
    }
}
