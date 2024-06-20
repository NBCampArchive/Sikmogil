//
//  MainViewController.swift
//  Sikmogil
//
//  Created by 문기웅 on 6/3/24.
//

import UIKit
import SnapKit
import Then
import DGCharts
import FloatingPanel
import Lottie
import Combine

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    var recodingWeightPanel: FloatingPanelController!
    var dimmingView: UIView!
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    private let scrollSubView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let goalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let goalLabel = UILabel().then {
        $0.text = "목표"
        $0.font = Suite.bold.of(size: 28)
    }
    
    private lazy var calendarButton = UIButton().then {
        $0.setImage(.calendar, for: .normal)
    }
    
    private let weightLabel = UILabel().then {
        $0.text = "목표까지 남은기간 N일!"
        $0.font = Suite.semiBold.of(size: 16)
        $0.textColor = .appDarkGray
    }
    
    private let progressLabel = UILabel().then {
        $0.text = "시작일 ~ 목표일"
        $0.font = Suite.semiBold.of(size: 16)
        $0.textColor = .appDarkGray
    }
    
    private let dateProgressView = UIProgressView().then {
        $0.progress = 0.7
        $0.trackTintColor = .appLightGray
        $0.progressTintColor = .appYellow
        $0.progressViewStyle = .bar
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.subviews[1].clipsToBounds = true
        $0.subviews[1].layer.cornerRadius = 20
    }
    
    private let percentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 4
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor(red: 1, green: 0.749, blue: 0, alpha: 1.0).cgColor
    }
    
    private let percentLabel = UILabel().then {
        $0.text = "100%"
        $0.font = Suite.semiBold.of(size: 12)
    }
    
    private let weightLogLabel = UILabel().then {
        $0.text = "체중 기록"
        $0.font = Suite.bold.of(size: 28)
    }
    
    private let weightNowLabel = UILabel().then {
        $0.text = "현재 체중 N Kg"
        $0.font = Suite.bold.of(size: 16)
        $0.textColor = .appDarkGray
    }
    
    private let weightToGoalLabel = UILabel().then {
        $0.text = "목표까지 N Kg"
        $0.font = Suite.bold.of(size: 22)
        $0.textColor = .appDarkGray
    }
    
    private let animationView: LottieAnimationView = .init(name: "The_Scale").then {
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.play()
    }
    
    private let recordButton = UIButton().then {
        $0.setTitle("기록하기", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.tintColor = .white
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
    
    private let graphLabel = UILabel().then {
        $0.text = "진행 그래프"
        $0.font = Suite.bold.of(size: 28)
    }
    
    private let graph = LineChartView().then {
        $0.backgroundColor = .clear
        $0.xAxis.drawGridLinesEnabled = false
        $0.leftAxis.drawGridLinesEnabled = false
        $0.rightAxis.drawGridLinesEnabled = false
        $0.xAxis.drawAxisLineEnabled = false
        $0.leftAxis.drawAxisLineEnabled = false
        $0.rightAxis.drawAxisLineEnabled = false
        //        $0.xAxis.drawLabelsEnabled = false
        $0.leftAxis.drawLabelsEnabled = false
        $0.rightAxis.drawLabelsEnabled = false
        $0.legend.enabled = false
        $0.extraLeftOffset = 16
        $0.extraRightOffset = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        viewModel.loadWeightData()
        bindViewModel()
        
        setupViews()
        setupConstraints()
        setupFloatingPanel()
        
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
        
        calendarButton.addTarget(self, action: #selector(tapCalendarButton), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(tapRecordButton), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollSubView)
        
        scrollSubView.addSubviews(goalStackView,
                                  calendarButton,
                                  dateProgressView,
                                  weightLogLabel,
                                  weightNowLabel,
                                  weightToGoalLabel,
                                  animationView,
                                  recordButton,
                                  graphLabel,
                                  graph)
        
        dateProgressView.subviews[1].addSubview(percentView)
        
        goalStackView.addArrangedSubviews(goalLabel, weightLabel, progressLabel)
        goalStackView.setCustomSpacing(16, after: weightLabel)
        
        percentView.addSubview(percentLabel)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollSubView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(graph.snp.bottom).offset(32)
        }
        
        goalStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        calendarButton.snp.makeConstraints {
            $0.centerY.equalTo(goalLabel.snp.centerY)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        dateProgressView.snp.makeConstraints {
            $0.top.equalTo(goalStackView.snp.bottom).offset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(40)
        }
        
        percentView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(40)
            $0.centerY.equalTo(dateProgressView.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        percentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        weightLogLabel.snp.makeConstraints {
            $0.top.equalTo(percentView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        weightNowLabel.snp.makeConstraints {
            $0.top.equalTo(weightLogLabel.snp.bottom).offset(16)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        weightToGoalLabel.snp.makeConstraints {
            $0.top.equalTo(weightNowLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        animationView.snp.makeConstraints {
            $0.top.equalTo(weightToGoalLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }
        
        recordButton.snp.makeConstraints {
            $0.top.equalTo(animationView.snp.bottom).offset(8)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(48)
        }
        
        graphLabel.snp.makeConstraints {
            $0.top.equalTo(recordButton.snp.bottom).offset(32)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        graph.snp.makeConstraints {
            $0.top.equalTo(graphLabel.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(300)
        }
    }
    
    private func bindViewModel() {
        viewModel.$targetModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] targetModel in
                self?.updateUI(with: targetModel)
            }
            .store(in: &cancellables)
        
        viewModel.$progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                self?.dateProgressView.progress = progress
                self?.percentLabel.text = String(format: "%.0f%%", progress * 100)
            }
            .store(in: &cancellables)
        
        viewModel.$remainingDays
            .receive(on: DispatchQueue.main)
            .sink { [weak self] remainingDays in
                self?.weightLabel.text = "목표까지 남은기간 \(remainingDays)일!"
            }
            .store(in: &cancellables)
        
        viewModel.$chartDateEntries
            .receive(on: DispatchQueue.main)
            .combineLatest(viewModel.$chartDates)
            .sink { [weak self] entries, dates in
                self?.updateGraph(with: entries, dates: dates)
            }
            .store(in: &cancellables)
        
        viewModel.$weight
            .receive(on: DispatchQueue.main)
            .print("업데이트 성공적 호출")
            .sink { [weak self] weight in
                self?.viewModel.loadWeightData()
            }
            .store(in: &cancellables)
        
    }
    
    private func updateUI(with targetModel: TargetModel?) {
        guard let targetModel = targetModel else { return }
        weightNowLabel.text = "현재 체중 \(targetModel.weekWeights.first?.weight ?? 0) Kg"
        weightToGoalLabel.text = "목표까지 \((Double(targetModel.targetWeight) ?? 0.0) - Double(targetModel.weekWeights.first?.weight ?? 0.0)) Kg"
        progressLabel.text = "\(targetModel.createDate) ~ \(targetModel.targetDate)"
    }
    
    private func updateGraph(with chartDateEntries: [ChartDataEntry], dates: [String]) {
        let dataSet = LineChartDataSet(entries: chartDateEntries)
        dataSet.mode = .horizontalBezier
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 5
        dataSet.circleHoleColor = UIColor.appGreen
        dataSet.circleColors = [UIColor.appGreen]
        dataSet.colors = [UIColor.appDarkGray]
        dataSet.valueFont = Suite.semiBold.of(size: 12)
        dataSet.fillColor = .appGreen.withAlphaComponent(0.3)
                dataSet.drawFilledEnabled = true
        dataSet.valueFormatter = IntegerValueFormatter()
        
        graph.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        graph.xAxis.labelPosition = .bottom
        graph.xAxis.granularity = 1
        graph.xAxis.labelTextColor = .black
        graph.xAxis.labelFont = Suite.semiBold.of(size: 10)
        
        let data = LineChartData(dataSet: dataSet)
        graph.data = data
    }
    
    @objc func tapCalendarButton() {
        let nextView = CalendarViewController()
        
        navigationController?.pushViewController(nextView, animated: true)
    }
    
    @objc func tapRecordButton() {
        self.present(recodingWeightPanel, animated: true)
    }
    
    // 키보드가 나타날 때 호출되는 메서드
    @objc override func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if userInfo[UIResponder.keyboardFrameEndUserInfoKey] is CGRect {
            // FloatingPanel 높이 수정
            recodingWeightPanel.move(to: .full, animated: true)
        }
    }
    
    // 키보드가 사라질 때 호출되는 메서드
    @objc override func keyboardWillHide(notification: NSNotification) {
        recodingWeightPanel.move(to: .half, animated: true)
    }
}

extension MainViewController: FloatingPanelControllerDelegate {
    
    func setupFloatingPanel() {
        recodingWeightPanel = FloatingPanelController()
        
        let contentVC = WeightRecordFloatingViewController()
        contentVC.viewModel = viewModel
        recodingWeightPanel.set(contentViewController: contentVC)
        
        recodingWeightPanel.layout = CustomFloatingPanelLayout()
        recodingWeightPanel.isRemovalInteractionEnabled = true
        recodingWeightPanel.changePanelStyle()
        recodingWeightPanel.delegate = self
    }
    
}

class IntegerValueFormatter: ValueFormatter {
    func stringForValue(_ value: Double, entry: DGCharts.ChartDataEntry, dataSetIndex: Int, viewPortHandler: DGCharts.ViewPortHandler?) -> String {
        return String(format: "%.0fKg", value)
    }
}
