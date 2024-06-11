//
//  MainViewController.swift
//  Sikmogil
//
//  Created by 문기웅 on 6/3/24.
//

import UIKit
import DGCharts
import FloatingPanel
import Lottie

class MainViewController: UIViewController {
    
    var floatingPanelController: FloatingPanelController!
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
    
    private let graph = BarChartView().then {
        $0.backgroundColor = .appLightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        setupFloatingPanel()
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
            $0.height.equalTo(950)
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
            $0.top.equalTo(percentView.snp.bottom).offset(16)
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
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(18)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-18)
            $0.height.equalTo(48)
        }
        
        graphLabel.snp.makeConstraints {
            $0.top.equalTo(recordButton.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        graph.snp.makeConstraints {
            $0.top.equalTo(graphLabel.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(300)
        }
    }
    
    @objc func tapCalendarButton() {
        let nextView = CalendarViewController()
        
        navigationController?.pushViewController(nextView, animated: true)
    }
    
    @objc func tapRecordButton() {
        floatingPanelController.show(animated: true, completion: nil)
        dimmingView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 1.0
        }
    }
}

extension MainViewController: WeightRecordFloatingViewControllerDelegate {
    func didTapDoneButton() {
        dismissFloatingPanel()
    }
}

extension MainViewController: FloatingPanelControllerDelegate {
    
    func setupFloatingPanel() {
        floatingPanelController = FloatingPanelController()
        
        let contentVC = WeightRecordFloatingViewController()
        floatingPanelController.set(contentViewController: contentVC)
        contentVC.delegate = self
        
        floatingPanelController.surfaceView.appearance.cornerRadius = 20
        floatingPanelController.delegate = self
        
        dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = UIColor.appBlack.withAlphaComponent(0.5)
        dimmingView.isHidden = true
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFloatingPanel)))
        
        view.addSubview(dimmingView)
        
        floatingPanelController.addPanel(toParent: self)
        floatingPanelController.hide(animated: false, completion: nil)
    }
    
    @objc func dismissFloatingPanel() {
        floatingPanelController.hide(animated: true) {
            self.dimmingView.isHidden = true
            self.dimmingView.alpha = 0.0
        }
    }
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.state != .hidden {
            tabBarController?.tabBar.isHidden = true
        }
        
        let loc = fpc.surfaceLocation
        let minY = fpc.surfaceLocation(for: .half).y
        let maxY = fpc.surfaceLocation(for: .tip).y
        
        if loc.y > maxY {
            fpc.move(to: .hidden, animated: true)
            self.dimmingView.isHidden = true
            tabBarController?.tabBar.isHidden = false
        }
        
        if loc.y < minY {
            fpc.surfaceLocation = CGPoint(x: loc.x, y: minY)
        }
    }
}
