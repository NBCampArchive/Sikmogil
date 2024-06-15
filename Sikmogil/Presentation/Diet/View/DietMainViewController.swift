//
//  DietMainViewController.swift
//  Sikmogil
//
//  Created by 희라 on 6/3/24.
//  [View] **설명** 식단 탭 메인페이지

import UIKit
import SnapKit
import Combine
import FloatingPanel

class DietMainViewController: UIViewController {
    
    var waterViewModel: WaterViewModel = WaterViewModel.shared
    var addMealViewModel: AddMealViewModel = AddMealViewModel.shared
    var dietViewModel = DietViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI components
    let scrollView = UIScrollView()
    let contentView = UIView()
    // 🍳 Diet
    let dietTitleView = UIView().then {
        $0.backgroundColor = .white
    }
    let dietTitleLabel = UILabel().then {
        $0.text = "식단"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 28)
        $0.textAlignment = .left
    }
    let dietTitleSubLabel = UILabel().then {
        $0.text = "오늘 하루 먹은 음식을 기록해보세요!"
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 14)
        $0.textAlignment = .left
    }
    let dietAddTabButton = UIButton().then {
        $0.setImage(UIImage(named: "plusIcon"), for: .normal)
    }
    let dietCircularProgressBar = CustomCircularProgressBar().then {
        $0.backgroundColor = .clear
        $0.progressColor = .appYellow
        $0.trackColor = .appLightGray
        $0.progress = 0.2
    }
    let dietProgressBarIcon = UIImageView().then {
        $0.image = UIImage(named: "dietIconFill")
    }
    let dietKcalLabel = UILabel().then {
        $0.text = "kcalkcalkcal"
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 16)
        $0.textAlignment = .center
    }
    let dietInfoLabel = UILabel().then {
        $0.text = "아직 더 먹을 수 있어요!"
        $0.textColor = .appDarkGray
        $0.font = Suite.regular.of(size: 12)
        $0.textAlignment = .center
    }
    // 💦 Water
    let waterTitleView = UIView().then {
        $0.backgroundColor = .clear
    }
    let waterTitleLabel = UILabel().then {
        $0.text = "물마시기"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 28)
        $0.textAlignment = .left
    }
    let waterTitleSubLabel = UILabel().then {
        $0.text = "오늘 하루 마신 물을 기록해보세요!"
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 14)
        $0.textAlignment = .left
    }
    let waterAddTabButton = UIButton().then {
        $0.setImage(UIImage(named: "plusIcon"), for: .normal)
    }
    let waterCircularProgressBar = WaveProgressView().then {
        $0.layer.cornerRadius = 150
        $0.layer.masksToBounds = true
        $0.backgroundColor = .customLightGray
        $0.progress = 0.1
    }
    let waterLiterLabel = UILabel().then {
        $0.text = "000ml / 2L"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 26)
        $0.textAlignment = .center
    }
    // 🤤 FastingTimer
    let fastingTimerTitleView = UIView().then {
        $0.backgroundColor = .clear
    }
    let fastingTimerTitleLabel = UILabel().then {
        $0.text = "공복 타이머"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 28)
        $0.textAlignment = .left
    }
    let fastingTimerTitleSubLabel = UILabel().then {
        $0.text = "전날 저녁시간부터 공복시간을 측정해요!"
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 14)
        $0.textAlignment = .left
    }
    let fastingTimerCircularProgressBar = CircularProgressBar().then {
        $0.backgroundColor = .clear
        $0.progressColor = .appPurple
        $0.trackColor = .appLightGray
        $0.progress = 0.0
    }
    let fastingTimerProgressBarIcon = UIImageView().then {
        $0.image = UIImage(named: "fastingTimerIconFill")
    }
    let fastingTimerInfoLabel = UILabel().then {
        $0.text = "N시간 단식중!"
        $0.textColor = .appDarkGray
        $0.font = Suite.bold.of(size: 22)
        $0.textAlignment = .center
    }
    let FastingButton = UIButton().then{
        $0.setTitle("공복 시작", for: .normal)
        $0.setTitle("공복 종료", for: .selected)
        $0.backgroundColor = .appLightGray
        $0.setTitleColor(.appBlack, for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 16)
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(fastingButtonButtonTapped), for: .touchUpInside)
    }
    
    // Timer properties
    var timer: Timer?
    var isTimerRunning = false
    var startTime: Date?
    var elapsedTime: TimeInterval = 0
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        //뷰진입시 서버에 있는 값으로 ui업데이트해주기
        dietViewModel.getDietLogDate(for: DateHelper.shared.formatDateToYearMonthDay(Date())) {
            result in
            switch result {
            case .success(_):
                // waterIntake 값을 이용해 WaterViewModel 업데이트
                let waterIntake = self.dietViewModel.dietLog!.waterIntake
                self.waterViewModel.setWaterAmount(waterIntake)
                
            case .failure(let error):
                print("식단 출력 실패")
            }
        }
        
        view.backgroundColor = .white
        
        subscribeToViewModel()
        
        dietAddTabButton.addTarget(self, action: #selector(showDietBottomSheet), for: .touchUpInside)
        waterAddTabButton.addTarget(self, action: #selector(showWaterBottomSheet), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(dietTitleView,waterTitleView,fastingTimerTitleView)
        // 🍳 Diet
        dietTitleView.addSubviews(dietTitleLabel,dietTitleSubLabel,dietAddTabButton,dietCircularProgressBar,dietProgressBarIcon,dietKcalLabel,dietInfoLabel)
        // 💦 Water
        waterTitleView.addSubviews(waterTitleLabel,waterTitleSubLabel,waterAddTabButton,waterCircularProgressBar,waterLiterLabel)
        // 🤤 FastingTimer
        fastingTimerTitleView.addSubviews(fastingTimerTitleLabel,fastingTimerTitleSubLabel,fastingTimerCircularProgressBar,fastingTimerProgressBarIcon, fastingTimerInfoLabel, FastingButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(fastingTimerTitleView.snp.bottom)
        }
        // 🍳 Diet
        dietTitleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(384)
        }
        dietTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
        }
        dietTitleSubLabel.snp.makeConstraints {
            $0.top.equalTo(dietTitleLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
        }
        dietAddTabButton.snp.makeConstraints{
            $0.top.equalTo(dietTitleView)
            $0.trailing.equalToSuperview()
        }
        dietCircularProgressBar.snp.makeConstraints {
            $0.top.equalTo(dietTitleSubLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        dietProgressBarIcon.snp.makeConstraints {
            $0.centerX.equalTo(dietCircularProgressBar)
            $0.centerY.equalTo(dietCircularProgressBar).offset(-40)
        }
        dietKcalLabel.snp.makeConstraints{
            $0.centerX.equalTo(dietCircularProgressBar)
            $0.top.equalTo(dietProgressBarIcon.snp.bottom).offset(16)
        }
        dietInfoLabel.snp.makeConstraints{
            $0.centerX.equalTo(dietCircularProgressBar)
            $0.top.equalTo(dietKcalLabel.snp.bottom).offset(8)
        }
        // 💦 Water
        waterTitleView.snp.makeConstraints{
            $0.top.equalTo(dietTitleView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(384)
        }
        waterTitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
        }
        waterTitleSubLabel.snp.makeConstraints {
            $0.top.equalTo(waterTitleLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
        }
        waterAddTabButton.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        waterCircularProgressBar.snp.makeConstraints{
            $0.top.equalTo(waterTitleSubLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        waterLiterLabel.snp.makeConstraints{
            $0.centerX.equalTo(waterCircularProgressBar)
            $0.centerY.equalTo(waterCircularProgressBar)
        }
        // 🤤 FastingTimer
        fastingTimerTitleView.snp.makeConstraints{
            $0.top.equalTo(waterTitleView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(480)
        }
        fastingTimerTitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
        }
        fastingTimerTitleSubLabel.snp.makeConstraints{
            $0.top.equalTo(fastingTimerTitleLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview()
        }
        fastingTimerCircularProgressBar.snp.makeConstraints{
            $0.top.equalTo(fastingTimerTitleSubLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        fastingTimerProgressBarIcon.snp.makeConstraints {
            $0.centerX.equalTo(fastingTimerCircularProgressBar)
            $0.centerY.equalTo(fastingTimerCircularProgressBar).offset(-30)
        }
        fastingTimerInfoLabel.snp.makeConstraints{
            $0.centerX.equalTo(fastingTimerCircularProgressBar)
            $0.top.equalTo(fastingTimerProgressBarIcon.snp.bottom).offset(16)
        }
        FastingButton.snp.makeConstraints {
            $0.top.equalTo(fastingTimerCircularProgressBar.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(60)
        }
    }
    
    // MARK: - Actions
    @objc func showDietBottomSheet() {
        let floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        
        floatingPanelController.changePanelStyle()
        
        // ContentViewController 설정
        let contentVC = DietBottomSheetViewController()
        floatingPanelController.set(contentViewController: contentVC)
        
        floatingPanelController.addPanel(toParent: self)
    }
    
    @objc private func showWaterBottomSheet() {
        let floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        
        floatingPanelController.changePanelStyle()
        
        let contentVC = WaterBottomSheetViewController()
        floatingPanelController.set(contentViewController: contentVC)
        
        floatingPanelController.addPanel(toParent: self)
        
        // 플로팅 패널의 초기 높이 설정
        let initialHeight = self.view.bounds.height - 320 // 플로팅 패널의 초기 높이
        floatingPanelController.surfaceLocation = CGPoint(x: self.view.bounds.midX, y: initialHeight)
    }
    
    @objc func fastingButtonButtonTapped() {
        FastingButton.isSelected.toggle()
        
        if FastingButton.isSelected {
            // Start timer
            startTime = Date()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
            isTimerRunning = true
        } else {
            // Stop timer
            timer?.invalidate()
            timer = nil
            isTimerRunning = false
        }
    }
    
    @objc func updateTimer() {
        guard let startTime = startTime else { return }
        elapsedTime = Date().timeIntervalSince(startTime)
        
        // Update circular progress bar
        let maxTime: TimeInterval = 24 * 60 * 60 // 24 hours in seconds
        let progress = Float(elapsedTime / maxTime)
        fastingTimerCircularProgressBar.progress = CGFloat(progress)
        
        // Update elapsed time label
        let hours = Int(elapsedTime / 3600)
        let minutes = Int((elapsedTime.truncatingRemainder(dividingBy: 3600)) / 60)
        fastingTimerInfoLabel.text = String(format: "경과 시간: %d시간 %d분", hours, minutes)
    }
    
    // MARK: - ViewModel
    private func subscribeToViewModel() {
        //물마시기 LabelText구독
        waterViewModel.waterLiterLabelTextPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.waterLiterLabel.text = value
            }
            .store(in: &cancellables)
        //물마시기 Progress구독
        waterViewModel.waterProgressPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                self?.waterCircularProgressBar.progress = Double(progress)
            }
            .store(in: &cancellables)
        
        //AddMealViewModel의 totalKcalPublisher를 구독하여 dietKcalLabel을 업데이트
        addMealViewModel.totalKcalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                print("총 칼로리 업데이트됨:", value)
                self?.dietKcalLabel.text = "\(value) / 2000Kcal"
                let progress = Double(value) / 2000.0
                self?.dietCircularProgressBar.progress = Double(progress)
            }
            .store(in: &cancellables)
    }
}
