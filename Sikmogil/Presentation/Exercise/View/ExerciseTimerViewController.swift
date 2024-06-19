//
//  ExerciseTimerViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/4/24.
//

import UIKit
import SnapKit
import Then

class ExerciseTimerViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel = ExerciseSelectionViewModel()
    var initialTime: TimeInterval
    var selectedTime: TimeInterval // 선택한 시간을 저장할 변수: 30분(30 * 60 = 1800)
    
    private var isPaused: Bool = true
    private var timer: DispatchSourceTimer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var startTime: Date?
    
    init(selectedTime: TimeInterval, initialTime: TimeInterval) {
        self.selectedTime = selectedTime
        self.initialTime = initialTime
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Components
    private let timeLabel = UILabel().then {
        $0.text = "00 : 00"
        $0.font = Suite.semiBold.of(size: 60)
    }

    private let stopPauseButton = UIButton().then {
        $0.setImage(.pause, for: .normal)
    }

    private let statusLabel = UILabel().then {
        $0.text = "START"
        $0.font = Suite.semiBold.of(size: 24)
        $0.textColor = .appGreen
    }

    private let recordButton = UIButton(type: .system).then {
        $0.setTitle("기록하기", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.backgroundColor = .appBlack
        $0.tintColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private let progressBar = UIView().then {
        $0.backgroundColor = UIColor(red: 216/255, green: 240/255, blue: 227/255, alpha: 1.0)
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
        updateTimeLabel()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(progressBar, timeLabel, stopPauseButton, statusLabel, recordButton)
    }
    
    private func setupConstraints() {
        progressBar.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            $0.centerX.equalToSuperview()
        }
        
        stopPauseButton.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(34)
            $0.width.height.equalTo(80)
            $0.centerX.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(stopPauseButton.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        recordButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Setup Timer
    private func setupButtons() {
        stopPauseButton.addTarget(self, action: #selector(stopPauseButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
    }
    
    @objc private func stopPauseButtonTapped() {
        isPaused.toggle()
        
        if isPaused {
            stopPauseButton.setImage(.pause, for: .normal)
            statusLabel.text = "PAUSE"
            timer?.cancel() // 타이머 중지
        } else {
            stopPauseButton.setImage(.stop, for: .normal)
            statusLabel.text = "STOP"
            startTimer() // 타이머 시작
        }
    }
    
    // 선택한 시간을 사용하여 라벨 초기 텍스트 업데이트
    private func updateTimeLabel() {
        let minutes = Int(selectedTime) / 60
        let seconds = Int(selectedTime) % 60
        
        let minutesString = String(format: "%02d", minutes)
        let secondsString = String(format: "%02d", seconds)
        
        timeLabel.text = "\(minutesString) : \(secondsString)"
    }
    
    private func startTimer() {
        startTime = Date()
        timer?.cancel() // 이전에 실행중인 타이머가 있으면 중지시킴
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer?.schedule(deadline: .now(), repeating: 1.0)
        timer?.setEventHandler(handler: { [weak self] in
            guard let self = self else { return }
            self.selectedTime -= 1
            if self.selectedTime < 0 {
                self.timer?.cancel() // 타이머가 종료되면 중지
                DispatchQueue.main.async {
                    self.handleTimerEnd()
                }
            } else {
                DispatchQueue.main.async {
                    self.updateTimeLabel() // 라벨 텍스트 업데이트
                    self.updateProgressBar()
                }
            }
        })
        timer?.resume()
        beginBackgroundTask()
    }
    
    private func handleTimerEnd() {
        // 타이머 종료 시 알림 처리
        NotificationHelper.shared.timerNotification()
        
        // 버튼 상태와 라벨 업데이트
        isPaused = true
        stopPauseButton.setImage(UIImage.pause, for: .normal)
        statusLabel.text = "START"
        endBackgroundTask()
    }
    
    private func updateProgressBar() {
        let totalWidth = view.frame.width
        let remainingTime = CGFloat(selectedTime)
        let progressWidth = totalWidth * remainingTime / CGFloat(initialTime)
        
        progressBar.snp.updateConstraints {
            $0.width.equalTo(progressWidth)
        }
    }
    
    // MARK: - Background Task Handling
    private func beginBackgroundTask() {
        if backgroundTask == .invalid {
            backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "ExerciseTimer") { [weak self] in
                self?.endBackgroundTask()
            }
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    @objc private func recordButtonTapped() {
        let exerciseResultVC = ExerciseResultViewController()
        exerciseResultVC.viewModel = self.viewModel
        navigationController?.pushViewController(exerciseResultVC, animated: true)
    }
}
