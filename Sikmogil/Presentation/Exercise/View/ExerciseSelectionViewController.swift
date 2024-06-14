//
//  ExerciseSelectionViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/4/24.
//

import UIKit
import SnapKit
import Then

class ExerciseSelectionViewController: UIViewController {
   
    // MARK: - Components
    private let exerciseLabel = UILabel().then {
        $0.text = "운동 종목"
        $0.font = Suite.semiBold.of(size: 20)
    }

    private let timeLabel = UILabel().then {
        $0.text = "운동 시간"
        $0.font = Suite.semiBold.of(size: 20)
    }

    private let intensityLabel = UILabel().then {
        $0.text = "운동 강도"
        $0.font = Suite.semiBold.of(size: 20)
    }

    private let exerciseSelectionButton = UIButton(type: .system).then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 16
    }

    private let exerciseSelectionLabel = UILabel().then {
        $0.font = Suite.medium.of(size: 16)
        $0.text = "-종목을 선택해 주세요-"
        $0.textColor = .appDarkGray
    }

    private let timeSelectionButton = UIButton(type: .system).then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 16
    }

    private let timeSelectionLabel = UILabel().then {
        $0.font = Suite.medium.of(size: 16)
        $0.text = "-시간을 선택해 주세요-"
        $0.textColor = .appDarkGray
    }

    private let lightButton = UIButton(type: .system).then {
        $0.setTitle("가볍게", for: .normal)
        $0.titleLabel?.font = Suite.medium.of(size: 14)
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.tintColor = .appDarkGray
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.layer.cornerRadius = 16
    }

    private let moderateButton = UIButton(type: .system).then {
        $0.setTitle("적당히", for: .normal)
        $0.titleLabel?.font = Suite.medium.of(size: 14)
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.tintColor = .appDarkGray
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.layer.cornerRadius = 16
    }

    private let intenseButton = UIButton(type: .system).then {
        $0.setTitle("격하게", for: .normal)
        $0.titleLabel?.font = Suite.medium.of(size: 14)
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.tintColor = .appDarkGray
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.layer.cornerRadius = 16
    }

    private let intensityStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }

    private let expectedLabel = UILabel().then {
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 20)
        $0.text = "예상 소모 칼로리는 0kcal예요"
        $0.textColor = .appDarkGray
    }

    private let recordButton = UIButton(type: .system).then {
        $0.setTitle("기록하기", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.backgroundColor = .appBlack
        $0.tintColor = .white
        $0.layer.cornerRadius = 16
    }

    private let measurementButton = UIButton(type: .system).then {
        $0.setTitle("측정하기", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.backgroundColor = .clear
        $0.tintColor = .appBlack
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.appBlack.cgColor
        $0.layer.cornerRadius = 16
    }

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    // MARK: - State
    private var selectedExercise: String?
    private var selectedTime: String?
    private var selectedIntensity: Int?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
        setupMenus()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(exerciseLabel, exerciseSelectionButton, timeLabel, timeSelectionButton, intensityLabel, exerciseLabel, intensityStackView, expectedLabel, buttonStackView)
        exerciseSelectionButton.addSubview(exerciseSelectionLabel)
        timeSelectionButton.addSubview(timeSelectionLabel)
        intensityStackView.addArrangedSubviews(lightButton, moderateButton, intenseButton)
        buttonStackView.addArrangedSubviews(recordButton, measurementButton)
    }
    
    private func setupConstraints() {
        exerciseLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        exerciseSelectionButton.snp.makeConstraints {
            $0.centerY.equalTo(exerciseLabel)
            $0.centerX.equalTo(intensityStackView)
            $0.height.equalTo(42)
            $0.width.equalTo(intensityStackView)
        }
        
        exerciseSelectionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(exerciseLabel.snp.bottom).offset(66)
            $0.leading.equalToSuperview().inset(32)
        }
        
        timeSelectionButton.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel)
            $0.centerX.equalTo(intensityStackView)
            $0.height.equalTo(42)
            $0.width.equalTo(intensityStackView)
        }
        
        timeSelectionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
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
    
    private func setupMenus() {
        let exercises = ["런닝", "수영", "자전거", "기타"]
        let times = ["15분", "30분", "60분", "90분"]
        
        let exerciseActions = exercises.map { exercise in
            UIAction(title: exercise) { [weak self] _ in
                self?.exerciseSelectionLabel.text = exercise
                self?.exerciseSelectionLabel.textColor = .appBlack
                self?.exerciseSelected(exercise)
            }
        }
        
        let exerciseMenu = UIMenu(title: "", children: exerciseActions)
        
        let timeActions = times.map { time in
            UIAction(title: time) { [weak self] _ in
                self?.timeSelectionLabel.text = time
                self?.timeSelectionLabel.textColor = .appBlack
                self?.timeSelected(time)
            }
        }
        
        let timeMenu = UIMenu(title: "", children: timeActions)
        
        exerciseSelectionButton.menu = exerciseMenu
        exerciseSelectionButton.showsMenuAsPrimaryAction = true
        
        timeSelectionButton.menu = timeMenu
        timeSelectionButton.showsMenuAsPrimaryAction = true
    }
    
    // MARK: - 선택된 항목 저장 및 라벨 업데이트
    private func exerciseSelected(_ exercise: String) {
        selectedExercise = exercise
        updateExpectedCaloriesLabel()
    }
    
    private func timeSelected(_ time: String) {
        selectedTime = time
        updateExpectedCaloriesLabel()
    }
    
    private func updateExpectedCaloriesLabel() {
        guard let exercise = selectedExercise, let time = selectedTime, let intensity = selectedIntensity else {
            expectedLabel.text = "예상 소모 칼로리는 0kcal예요"
            return
        }
        
        let calories = calculateCalories(exercise: exercise, time: time, intensity: intensity)
        let fullText = "예상 소모 칼로리는 \(calories)kcal예요"
        let changeText = "\(calories)kcal"
        let color = UIColor.appGreen
        expectedLabel.setAttributedText(fullText: fullText, changeText: changeText, color: color, font: Suite.semiBold.of(size: 20))
    }
    
    private func calculateCalories(exercise: String, time: String, intensity: Int) -> Int {
        // 각 운동 종목에 대한 예시 분당 칼로리 소모량
        let caloriesPerMinute: [String: Int] = [
            "런닝": 10,
            "수영": 8,
            "자전거": 7,
            "기타": 5
        ]
        
        // 시간 문자열을 분 단위로 변환
        let timeInMinutes = Int(time.dropLast(1)) ?? 0
        
        // 강도에 따른 보정값 (예: 0: 가볍게, 1: 적당히, 2: 격하게)
        let intensityMultiplier: [Int: Double] = [
            0: 0.75,
            1: 1.0,
            2: 1.25
        ]
        
        // 칼로리 계산 로직
        let baseCalories = caloriesPerMinute[exercise] ?? 0
        let multiplier = intensityMultiplier[intensity] ?? 1.0
        let totalCalories = Double(baseCalories) * Double(timeInMinutes) * multiplier
        
        return Int(totalCalories)
    }
}

// MARK: - Button Actions
extension ExerciseSelectionViewController {
    
    @objc private func intensityButtonTapped(_ sender: UIButton) {
        [lightButton, moderateButton, intenseButton].forEach {
            $0.backgroundColor = .clear
            $0.tintColor = .appDarkGray
            $0.layer.borderColor = UIColor.appDarkGray.cgColor
        }
        
        sender.backgroundColor = .appBlack
        sender.tintColor = .white
        sender.layer.borderColor = UIColor.clear.cgColor
        
        switch sender {
        case lightButton:
            selectedIntensity = 0
        case moderateButton:
            selectedIntensity = 1
        case intenseButton:
            selectedIntensity = 2
        default:
            break
        }
        
        updateExpectedCaloriesLabel()
    }
    
    @objc private func startButtonTapped(_ sender: UIButton) {
        print("\(sender.currentTitle ?? "") Button tapped")
        [recordButton, measurementButton].forEach {
            $0.backgroundColor = .clear
            $0.tintColor = .appDarkGray
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
