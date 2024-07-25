//
//  ExerciseSelectionViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/4/24.
//

import UIKit
import Combine
import SnapKit
import Then

class ExerciseSelectionViewController: UIViewController {
   
    // MARK: - Properties
    private var viewModel = ExerciseSelectionViewModel()
    private var cancellables = Set<AnyCancellable>()
    
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
        $0.textColor = .appBlack
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
        $0.textColor = .appDeepDarkGray
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
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
        setupMenus()
        bindViewModel()
        
        navigationController?.navigationBar.isHidden = false
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
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
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
    
    // MARK: -  Bind ViewModel
    private func bindViewModel() {
        viewModel.$expectedCalories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] calories in
                self?.updateExpectedCaloriesLabel(calories: calories)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedExercise
            .combineLatest(viewModel.$selectedTime, viewModel.$selectedIntensity)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exercise, time, intensity in
                self?.updateButtonsState()
            }
            .store(in: &cancellables)
    }

    private func updateExpectedCaloriesLabel(calories: Int) {
        let fullText = "예상 소모 칼로리는 \(calories)kcal예요"
        let changeText = "\(calories)kcal"
        let color = UIColor.appGreen
        expectedLabel.setAttributedText(fullText: fullText, changeText: changeText, color: color, font: Suite.semiBold.of(size: 20))
    }
    
    // MARK: -  Setup Binding
    func handleExerciseSelection(exercise: String) {
        exerciseSelectionLabel.text = exercise
        viewModel.selectedExercise = exercise
    }
    
    private func setupMenus() {
        let times = ["15분", "30분", "60분", "90분"]
        let timeActions = times.map { time in
            UIAction(title: time) { [weak self] _ in
                self?.timeSelectionLabel.text = time
                self?.timeSelectionLabel.textColor = .appBlack
                self?.viewModel.selectedTime = time
            }
        }
        
        let timeMenu = UIMenu(title: "", children: timeActions)

        timeSelectionButton.menu = timeMenu
        timeSelectionButton.showsMenuAsPrimaryAction = true
    }
    
    // MARK: - Button Actions
    private func updateButtonsState() {
        let isEnabled = viewModel.selectedExercise != nil && viewModel.selectedTime != nil && viewModel.selectedIntensity != nil
        recordButton.isEnabled = isEnabled
        measurementButton.isEnabled = isEnabled
        recordButton.alpha = isEnabled ? 1.0 : 0.5
        measurementButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
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
            viewModel.selectedIntensity = 0
        case moderateButton:
            viewModel.selectedIntensity = 1
        case intenseButton:
            viewModel.selectedIntensity = 2
        default:
            break
        }
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
        
        if sender == recordButton {
            navigateResultVC()
        }
        
        if sender == measurementButton {
            navigateToTimerVC()
        }
    }
    
    private func navigateToTimerVC() {
        guard let time = viewModel.selectedTime else { return }
        // 시간 문자열을 초 단위로 변환 ("30분" -> 1800초)
        let timeInMinutes = Int(time.dropLast(1)) ?? 0
        let timeInSeconds = TimeInterval(timeInMinutes * 60)
        
        let exerciseTimerVC = ExerciseTimerViewController(selectedTime: timeInSeconds, initialTime: timeInSeconds)
        exerciseTimerVC.viewModel = self.viewModel
        navigationController?.pushViewController(exerciseTimerVC, animated: true)
    }
    
    private func navigateResultVC() {
        let exerciseResultVC = ExerciseResultViewController()
        exerciseResultVC.viewModel = self.viewModel
        navigationController?.pushViewController(exerciseResultVC, animated: true)
    }
}
