//
//  StepsViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/5/24.
//

import UIKit
import HealthKit
import SnapKit
import Then

class StepsViewController: UIViewController {

    // MARK: - Components
    let healthStore = HKHealthStore()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let stepsIconImage = UIImageView().then {
        $0.image = UIImage.stepsIcon
    }

    private let stepsLabel = UILabel().then {
        $0.text = "오늘 걸음 수"
        $0.font = Suite.medium.of(size: 20)
        $0.textColor = .appBlack
    }

    private let stepsValueLabel = UILabel().then {
        $0.text = "0"
        $0.font = Suite.bold.of(size: 50)
        $0.textColor = .appBlack
    }

    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
    }

    private let goalLabel = UILabel().then {
        $0.text = "오늘의 만보 걷기"
        $0.font = Suite.semiBold.of(size: 18)
        $0.textColor = .appBlack
    }

    private let goalValueLabel = UILabel().then {
        $0.text = "0% 달성"
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .appBlack
    }

    private let goalValueView = UIView().then {
        $0.layer.borderColor = UIColor.appBlack.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }

    private let goalProgressView = UIView().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 10
    }

    private let goalProgressValueView = UIView().then {
        $0.backgroundColor = .appGreen
        $0.layer.cornerRadius = 10
    }

    private let subCardView = UIView().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 16
    }

    private let kcalLabel = UILabel().then {
        $0.text = "소모량 30kcal"
        $0.font = Suite.semiBold.of(size: 20)
        $0.textColor = .appBlack
    }
    
    // MARK: - Properties
    private var currentProgressPercentage: CGFloat = 0.0
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        updateStepsData()
    }
    
    // MARK: - Steps Data
    private func updateStepsData() {
        // 걸음 수 데이터 가져오기
        fetchStepCount { (steps) in
            let formattedSteps = steps.formattedWithCommas()
            self.stepsValueLabel.text = formattedSteps
            
            // 목표 달성률 업데이트
            self.updateGoalProgress(steps: steps)
            
            // 현재 소모 칼로리 계산 (1걸음당 0.04kcal)
            let kcalPerStep: Double = 0.04
            let totalKcal = steps * kcalPerStep
            let formattedKcal = String(format: "소모량 %.0fkcal", totalKcal) // 소수점 없이 표시
            
            // 메인 스레드에서 UI 업데이트
            DispatchQueue.main.async {
                self.kcalLabel.text = formattedKcal
            }
        }
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .appLightGreen
        view.addSubviews(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(stepsLabel, stepsValueLabel, stepsIconImage,cardView)
        cardView.addSubviews(goalLabel, goalValueView, goalProgressView, subCardView)
        goalValueView.addSubview(goalValueLabel)
        goalProgressView.addSubview(goalProgressValueView)
        subCardView.addSubview(kcalLabel)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        stepsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
        
        stepsValueLabel.snp.makeConstraints {
            $0.top.equalTo(stepsLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        stepsIconImage.snp.makeConstraints {
            $0.width.equalTo(190)
            $0.height.equalTo(220)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stepsValueLabel.snp.bottom).offset(24)
        }
        
        cardView.snp.makeConstraints {
            $0.top.equalTo(stepsIconImage.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(160)
        }
        
        goalLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        goalValueView.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(24)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(goalLabel)
        }
        
        goalValueLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        goalProgressView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(subCardView.snp.top).inset(-10)
            $0.height.equalTo(20)
        }
        
        goalProgressValueView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        subCardView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(38)
        }
        
        kcalLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(cardView.snp.bottom).offset(30)
        }
    }
}

// MARK: - HealthKit
extension StepsViewController {
    // HealthKit 권한 요청
    private func requestHealthKitAuthorization(completion: @escaping (Bool) -> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let dataTypesToRead: Set<HKObjectType> = [stepCountType]
        
        healthStore.requestAuthorization(toShare: nil, read: dataTypesToRead) { (success, error) in
            if success {
                print("HealthKit authorization granted")
                completion(true)
            } else {
                print("HealthKit authorization denied")
                if let error = error {
                    print(error.localizedDescription)
                }
                completion(false)
            }
        }
    }
    
    // 걸음 수 데이터 가져오기
    private func fetchStepCount(completion: @escaping (Double) -> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Date()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var totalSteps: Double = 0
            
            if let result = result, let sum = result.sumQuantity() {
                totalSteps = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(totalSteps)
            }
        }
        healthStore.execute(query)
    }
}

// MARK: - Goal
extension StepsViewController {
    // 목표 달성률 계산 및 업데이트
    private func updateGoalProgress(steps: Double) {
        let dailyGoalSteps: Double = 10000
        
        // 걸음 수 달성률 계산
        let percentage = min((steps / dailyGoalSteps) * 100, 100) // 100%를 초과하지 않도록 제한
        
        // %로 표시할 문자열 생성
        let formattedPercentage = String(format: "%.0f%% 달성", percentage) // 소수점 없이 표시
        
        // 현재 진행률 업데이트
        currentProgressPercentage = CGFloat(percentage / 100)
        
        // 메인 스레드에서 UI 업데이트 (달성률, 프로그레스 바)
        DispatchQueue.main.async {
            self.goalValueLabel.text = formattedPercentage
            self.updateProgress(self.currentProgressPercentage)
        }
    }
    
    // 프로그레스 바 업데이트
    private func updateProgress(_ percentage: CGFloat) {
        
        let maxWidth = goalProgressView.frame.width
        let progressWidth = min(maxWidth * percentage, maxWidth)// 달성률에 따른 너비 계산
        
        goalProgressValueView.snp.makeConstraints {
            $0.width.equalTo(progressWidth)
        }
    }
}
