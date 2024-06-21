//
//  DietAPITest.swift
//  Sikmogil
//
//  Created by t2023-m0114 on 6/14/24.
//  DietAPITest용 파일입니다

import UIKit
import SnapKit
import Then

class DietAPITestViewController: UIViewController {
    
//    let testLabel = UILabel().then {
//        $0.text = "APITest"
//        $0.font = Suite.bold.of(size: 30)
//        $0.textColor = .appBlack
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .appPurple
//        view.addSubview(testLabel)
//        
//        testLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//        
//        
//        //addExerciseListData() //한끼 식사 추가
//        //getDietListByDate() //식사 출력
//        //deleteDietList() //식사 삭제
//
//        
////        updateDietLog() // 식단 추가
////        getDietLogDate() // 식단 출력
//        
//        
//    }
//    
//    
//    
//    //[식사] 추가하기
//    private func addDietList() {
//        
//        let date = "2024.06.14"
//        
//        // 예시로 사용할 다이어트 리스트 데이터
//        let dietList = DietList(
//            dietListId: 1,
//            calorie: 150,
//            foodName: "오이또",
//            mealTime: "breakfast"
//        )
//        
//        DietAPIManager.shared.addDietList(date: date, dietList: dietList) { result in
//            switch result {
//            case .success():
//                print("식단 업데이트 성공")
//            case .failure(let error):
//                print("식단 업데이트 실패: \(error)")
//            }
//        }
//    }
//    
//    //[식사] 리스트 출력
//    private func getDietListByDate() {
//        
//        let date = "2024.06.14"
//        
//        DietAPIManager.shared.getDietListByDate(date: date) {
//            result in
//                switch result {
//                case .success(let data):
//                    print("식단 출력 성공: \(data)")
//                case .failure(let error):
//                    print("식단 출력 실패: \(error)")
//                }
//        }
//    }
//    
//    
//    //[식사] 리스트 삭제
//    private func deleteDietList() {
//        
//        let date = "2024.06.14"
//        
//        DietAPIManager.shared.deleteDietList(date: date, dietListId: 2) {
//            result in
//                switch result {
//                case .success:
//                    print("식단 삭제 성공")
//                case .failure(let error):
//                    print("식단 삭제 실패: \(error)")
//                }
//        }
//    }
//    
//    
//    
//    //특정날짜 식단 데이터 업데이트
//    private func updateDietLog() {
//        
//        let date = "2024.06.14"
//        let water = 500
//        let totalCalorieEaten = 1200
//        
//        DietAPIManager.shared.updateDietLog(date: date, water: water, totalCalorieEaten: totalCalorieEaten) { result in
//            switch result {
//            case .success():
//                print("식단 업데이트 성공")
//            case .failure(let error):
//                print("식단 업데이트 실패: \(error)")
//            }
//        }
//    }
//    
//    //특정 날짜 식단 데이터 출력
//    private func getDietLogDate(){
//        
//        let date = "2024.06.14"
//        
//        DietAPIManager.shared.getDietLogDate(date: date) {
//            result in
//            switch result {
//            case .success(let data):
//                print("식단 출력 성공: \(data)")
//            case .failure(let error):
//                print("식단 출력 실패: \(error)")
//            }
//        }
//    }


        // MARK: - Properties (완)
        private var startTime: Date?
        private var timer: Timer?
        private var isTimerRunning: Bool {
            get { return UserDefaults.standard.bool(forKey: "isTimerRunning") }
            set { UserDefaults.standard.set(newValue, forKey: "isTimerRunning") }
        }

        private let fastingTimerCircularProgressBar = UIProgressView(progressViewStyle: .default)
        private let fastingTimerInfoLabel = UILabel()
        private let startStopButton = UIButton(type: .system)

        // MARK: - View Life Cycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupViews()
            setupConstraints()
            updateButtonTitle()

            // Ensure the timer is stopped initially
            stopTimer()
        }

        // MARK: - Setup Views
        private func setupViews() {
            view.backgroundColor = .white
            
            fastingTimerCircularProgressBar.progress = 0.0
            view.addSubview(fastingTimerCircularProgressBar)
            
            fastingTimerInfoLabel.text = "경과 시간: 0시간 0분 0초"
            view.addSubview(fastingTimerInfoLabel)
            
            startStopButton.setTitle("시작", for: .normal)
            startStopButton.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
            view.addSubview(startStopButton)
        }

        private func setupConstraints() {
            fastingTimerCircularProgressBar.translatesAutoresizingMaskIntoConstraints = false
            fastingTimerInfoLabel.translatesAutoresizingMaskIntoConstraints = false
            startStopButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                fastingTimerCircularProgressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                fastingTimerCircularProgressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                fastingTimerCircularProgressBar.widthAnchor.constraint(equalToConstant: 200),
                
                fastingTimerInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                fastingTimerInfoLabel.topAnchor.constraint(equalTo: fastingTimerCircularProgressBar.bottomAnchor, constant: 20),
                
                startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                startStopButton.topAnchor.constraint(equalTo: fastingTimerInfoLabel.bottomAnchor, constant: 20)
            ])
        }

        private func updateButtonTitle() {
            let title = isTimerRunning ? "정지" : "시작"
            startStopButton.setTitle(title, for: .normal)
        }

        // MARK: - Timer Management
        @objc private func startStopButtonTapped() {
            if isTimerRunning {
                stopTimer()
            } else {
                startTimer()
            }
            updateButtonTitle()
        }

        private func startTimer() {
            startTime = Date()
            UserDefaults.standard.set(startTime, forKey: "startTime")
            print("타이머 시작 시간: \(startTime!)") // 디버깅용 print문

            isTimerRunning = true

            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }

        private func stopTimer() {
            timer?.invalidate()
            timer = nil
            isTimerRunning = false

            if let startTime = startTime {
                let elapsedTime = Date().timeIntervalSince(startTime)
                print("타이머 정지 시간: \(Date())") // 디버깅용 print문
                print("경과 시간: \(elapsedTime)초") // 디버깅용 print문
            }
            
            UserDefaults.standard.removeObject(forKey: "startTime")
            updateTimer() // To reset the label and progress bar
        }

        @objc private func updateTimer() {
            guard let startTime = startTime else {
                fastingTimerInfoLabel.text = "경과 시간: 0시간 0분 0초"
                fastingTimerCircularProgressBar.progress = 0.0
                return
            }
            let elapsedTime = Date().timeIntervalSince(startTime)
            
            let hours = Int(elapsedTime) / 3600
            let minutes = (Int(elapsedTime) % 3600) / 60
            let seconds = Int(elapsedTime) % 60
            
            fastingTimerInfoLabel.text = String(format: "경과 시간: %d시간 %d분 %d초", hours, minutes, seconds)
            
            // Update progress bar for each hour
            let maxTime: TimeInterval = 60 * 60 // 1 hour in seconds
            let progress = Float((elapsedTime.truncatingRemainder(dividingBy: maxTime)) / maxTime)
            fastingTimerCircularProgressBar.progress = Float(progress)
        }
    }
