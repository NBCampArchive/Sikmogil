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
  
    var viewModel = ExerciseSelectionViewModel()
    
    // MARK: - Components
    private var isPaused: Bool = true
    var selectedTime: TimeInterval = 30 // 선택한 시간을 저장할 변수: 30분(30 * 60 = 1800)
    private var timer: Timer?

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

    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
        updateTimeLabel()
        
        // NotificationCenter에 구독
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectedTime(_:)), name: Notification.Name("SelectedTimeNotification"), object: nil)
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(timeLabel, stopPauseButton, statusLabel, recordButton)
    }
    
    private func setupConstraints() {
        
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
    
    // MARK: - Setup Buttons
    private func setupButtons() {
        stopPauseButton.addTarget(self, action: #selector(stopPauseButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
    }
    
    @objc private func stopPauseButtonTapped() {
        isPaused.toggle()
        
        if isPaused {
            stopPauseButton.setImage(.pause, for: .normal)
            statusLabel.text = "PAUSE"
            timer?.invalidate() // 타이머 중지
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
    
    // 선택한 시간을 처리
    @objc private func handleSelectedTime(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let selectedTime = userInfo["selectedTime"] as? TimeInterval else {
            return
        }
        self.selectedTime = selectedTime
        // 타이머 시작
        startTimer()
    }
    
    // 타이머 시작
    private func startTimer() {
        timer?.invalidate() // 이전에 실행중인 타이머가 있으면 중지시킴
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    // 타이머 라벨 업데이트
    @objc private func updateTimerLabel() {
        guard selectedTime > 0 else {
            timer?.invalidate() // 타이머가 종료되면 중지
            handleTimerEnd()
            return
        }
        
        selectedTime -= 1
        updateTimeLabel() // 라벨 텍스트 업데이트
    }
    
    private func handleTimerEnd() {
        // 타이머 종료 시 처리
        let alertController = UIAlertController(title: "타이머 종료", message: "설정된 시간이 종료되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
        // 버튼 상태와 라벨 업데이트
        isPaused = true
        stopPauseButton.setImage(.pause, for: .normal)
        statusLabel.text = "START"
    }
    
    @objc private func recordButtonTapped() {
        let exerciseResultVC = ExerciseResultViewController()
        exerciseResultVC.viewModel = self.viewModel
        navigationController?.pushViewController(exerciseResultVC, animated: true)
    }
}
