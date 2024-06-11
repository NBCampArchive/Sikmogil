//
//  StepsViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/5/24.
//

import UIKit
import HealthKit

class StepsViewController: UIViewController {

    // MARK: - Components
    let healthStore = HKHealthStore()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .appLightGray
        view.layer.cornerRadius = 100
        return view
    }()
    
    private let stepsImage: UIImageView = {
         let imageView  = UIImageView()
         imageView.image = .steps
         imageView.contentMode = .scaleAspectFit
         return imageView
     }()
    
    private let stepsLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 걸음 수"
        label.font = Suite.medium.of(size: 18)
        label.textColor = .appBlack
        return label
    }()
    
    private let stepsValueLabel: UILabel = {
        let label = UILabel()
        label.text = "15,000"
        label.font = Suite.bold.of(size: 50)
        label.textColor = .appBlack
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 만보 걷기"
        label.font = Suite.semiBold.of(size: 18)
        label.textColor = .appBlack
        return label
    }()
    
    private let goalValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0% 달성"
        label.font = Suite.regular.of(size: 12)
        label.textColor = .appBlack
        return label
    }()
    
    private let goalValueView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.appBlack.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        return view
    }()

    private let goalProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .appLightGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let goalProgressValueView: UIView = {
        let view = UIView()
        view.backgroundColor = .appGreen
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let subCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .appLightGray
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let kcalLabel: UILabel = {
        let label = UILabel()
        label.text = "소모량 30kcal"
        label.font = Suite.semiBold.of(size: 20)
        label.textColor = .appBlack
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        // HealthKit 권한 요청
        requestHealthKitAuthorization()
        
        // 걸음 수 데이터 가져오기
        fetchStepCount { (steps) in
            print("Total steps: \(steps)")}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProgress(0.8)
    }
    
    // MARK: - Setup View
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(circleView, stepsLabel, stepsValueLabel, cardView)
        circleView.addSubview(stepsImage)
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
        
        circleView.snp.makeConstraints {
            $0.width.height.equalTo(200)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(44)
        }
        
        stepsImage.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        stepsLabel.snp.makeConstraints {
            $0.top.equalTo(circleView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        stepsValueLabel.snp.makeConstraints {
            $0.top.equalTo(stepsLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        cardView.snp.makeConstraints {
            $0.top.equalTo(stepsValueLabel.snp.bottom).offset(64)
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
    
    // MARK: - 프로그레스 바 업데이트
    private func updateProgress(_ percentage: CGFloat) {
        
        let maxWidth = goalProgressView.frame.width
        
        let progressWidth = maxWidth * percentage // 달성률에 따른 너비 계산
        
        goalProgressValueView.snp.makeConstraints {
            $0.width.equalTo(progressWidth)
        }
    }
    
    // MARK: - HealthKit
    // HealthKit 권한 요청
    func requestHealthKitAuthorization() {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let dataTypesToRead: Set<HKObjectType> = [stepCountType]
        
        healthStore.requestAuthorization(toShare: nil, read: dataTypesToRead) { (success, error) in
            if success {
                print("HealthKit authorization granted")
            } else {
                print("HealthKit authorization denied")
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // 걸음 수 데이터 가져오기
    func fetchStepCount(completion: @escaping (Double) -> Void) {
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
