//
//  ExerciseResultViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/4/24.
//

import UIKit
import Combine
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

    private let circularProgressBar = AnimationProgressBar().then {
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

    private let exerciseImage = UIImageView().then {
        $0.image = .running
        $0.contentMode = .scaleAspectFit
    }

    private let exerciseLabel = UILabel().then {
        $0.text = "운동 이름"
        $0.font = Suite.medium.of(size: 18)
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
    
    // MARK: - Properties
    var viewModel = ExerciseSelectionViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setTabBar(hidden: true, animated: true)
        startProgressBarAnimation()
    }
    
    private func startProgressBarAnimation() {
        circularProgressBar.animateProgress(to: 1.0, duration: 3.0)
    }
    
    // MARK: - Setup Binding
    private func bindViewModel() {
        viewModel.$expectedCalories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] calories in
                self?.updateProgressLabel(calories: calories)
                self?.kcalValueLabel.text = "\(calories)kcal"
            }
            .store(in: &cancellables)
        
        viewModel.$selectedTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.timeValueLabel.text = time
            }
            .store(in: &cancellables)
        
        viewModel.$selectedExercise
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exercise in
                self?.exerciseLabel.text = exercise
                self?.updateExerciseImage(exercise: exercise ?? "기타")
            }
            .store(in: &cancellables)
    }
    
    private func updateProgressLabel(calories: Int) {
        let fullText = "예상 소모 칼로리는\n\(calories)kcal 예요"
        let changeText = "\(calories)kcal"
        let font = Suite.semiBold.of(size: 20)
        let color = UIColor.appGreen
        progressLabel.setAttributedText(fullText: fullText, changeText: changeText, color: color, font: font)
    }
    
    private func updateExerciseImage(exercise: String) {
        let iconName = viewModel.iconName(for: exercise)
        exerciseImage.image = UIImage(named: iconName)
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(scrollView, addButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(cardView, progressView, resultView)
        cardStackView.addArrangedSubviews(checkImage, completionLabel)
        cardView.addSubview(cardStackView)
        progressView.addSubviews(circularProgressBar, progressLabel)
        resultView.addSubviews(exerciseImage, exerciseLabel, verticalLine, timeStackView, kcalStackView)
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
        
        exerciseImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(32)
        }
        
        exerciseLabel.snp.makeConstraints {
            $0.centerY.equalTo(exerciseImage)
            $0.leading.equalTo(exerciseImage.snp.trailing).offset(8)
        }
        
        verticalLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(76)
            $0.centerX.equalTo(exerciseImage)
            $0.top.equalTo(exerciseImage.snp.bottom).offset(20)
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
    
    // MARK: - Setup Buttons
    private func setupButtons() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        
        let exerciseData = viewModel.saveExerciseData()
        let day = DateHelper.shared.formatDateToYearMonthDay(Date())
        
        ExerciseAPIManager.shared.addExerciseListData(exerciseDay: day, exerciseList: exerciseData) { result in
            switch result {
            case .success:
                print("운동 리스트 추가 성공")
                self.showAlert(message: "운동 리스트 추가 성공") {
                    // 네비게이션의 최상단 페이지로 이동
                    self.navigationController?.popToRootViewController(animated: true)
                    self.setTabBar(hidden: false, animated: true)
                }
                
            case .failure(let error):
                print("운동 리스트 추가 실패", error)
            }
        }
    }
    
    private func showAlert(message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
