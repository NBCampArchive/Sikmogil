//
//  CalendarViewController.swift
//  Sikmogil
//
//  Created by 문기웅 on 6/4/24.
//

import UIKit
import FSCalendar
import FloatingPanel


class CalendarViewController: UIViewController {
    
    var secondFloatingPanelController: FloatingPanelController!
    var secondDimmingView: UIView!
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    private let scrollSubView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let calendar = FSCalendar().then {
        $0.appearance.headerDateFormat = "YYYY년 MM월"
        $0.appearance.headerTitleFont = Suite.bold.of(size: 22)
        $0.appearance.headerMinimumDissolvedAlpha = 0.0
        $0.appearance.headerTitleOffset = .init(x: -110, y: 0)
        $0.locale = Locale(identifier: "ko_KR")
        $0.appearance.headerTitleColor = .black
        $0.appearance.weekdayTextColor = .appDarkGray
        $0.appearance.weekdayFont = Suite.bold.of(size: 14)
    }
    
    private let diaryView = UIView().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 16
    }
    
    private let dayLabel = UILabel().then {
        $0.text = "6.5 금요일"
        $0.font = Suite.bold.of(size: 22)
    }
    
    private let mentLabel = UILabel().then {
        $0.text = "한 줄 일기 내용"
        $0.font = Suite.bold.of(size: 18)
    }
    
    private let diaryLabel = UILabel().then {
        $0.text = "동해물과 백두산이 마르고닳도록"
        $0.font = Suite.regular.of(size: 16)
    }
    
    private let detailButton = UIButton().then {
        $0.setTitle("자세한 내용을 확인해보세요!", for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 16)
        $0.backgroundColor = .clear
        $0.setTitleColor(.appDarkGray, for: .normal)
    }
    
    private let writeButton = UIButton().then {
        $0.setImage(.addDiary, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        setupFloatingPanel()
        
        detailButton.addTarget(self, action: #selector(tapDetailButton), for: .touchUpInside)
        writeButton.addTarget(self, action: #selector(tapWriteButton), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubviews(scrollView)
        
        scrollView.addSubview(scrollSubView)
        
        scrollSubView.addSubviews(calendar, diaryView, writeButton)
        
        diaryView.addSubviews(dayLabel, mentLabel, diaryLabel, detailButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollSubView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(750)
        }
        
        calendar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(450)
        }
        
        diaryView.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(8)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(200)
        }
        
        dayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        mentLabel.snp.makeConstraints {
            $0.top.equalTo(dayLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        diaryLabel.snp.makeConstraints {
            $0.top.equalTo(mentLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        detailButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        writeButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    @objc func tapDetailButton() {
        let nextView = DayViewController()
        
        self.present(nextView, animated: true)
    }
    
    @objc func tapWriteButton() {
        secondFloatingPanelController.show(animated: true, completion: nil)
        secondDimmingView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.secondDimmingView.alpha = 1.0
        }
    }
}

extension CalendarViewController: DiaryRecordFloatingViewControllerDelegate {
    func didTapDoneButton() {
        dismissFloatingPanel()
    }
}

extension CalendarViewController: FloatingPanelControllerDelegate {
    
    func setupFloatingPanel() {
        secondFloatingPanelController = FloatingPanelController()
        
        let contentVC = DiaryRecordFloatingViewController()
        contentVC.delegate = self
        secondFloatingPanelController.set(contentViewController: contentVC)
        
        secondFloatingPanelController.surfaceView.appearance.cornerRadius = 20
        secondFloatingPanelController.delegate = self
        
        secondDimmingView = UIView(frame: view.bounds)
        secondDimmingView.backgroundColor = UIColor.appBlack.withAlphaComponent(0.5)
        secondDimmingView.isHidden = true
        secondDimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFloatingPanel)))
        
        view.addSubview(secondDimmingView)
        
        secondFloatingPanelController.addPanel(toParent: self)
        secondFloatingPanelController.hide(animated: false, completion: nil)
    }
    
    @objc func dismissFloatingPanel() {
        secondFloatingPanelController.hide(animated: true) {
            self.secondDimmingView.isHidden = true
            self.secondDimmingView.alpha = 0.0
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
            self.secondDimmingView.isHidden = true
            tabBarController?.tabBar.isHidden = false
        }
        
        if loc.y < minY {
            fpc.surfaceLocation = CGPoint(x: loc.x, y: minY)
        }
    }
}
