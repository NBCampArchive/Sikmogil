//
//  CalendarViewController.swift
//  Sikmogil
//
//  Created by 문기웅 on 6/4/24.
//

import UIKit
import Then
import SnapKit
import FSCalendar
import FloatingPanel
import Combine

class CalendarViewController: UIViewController {
    
    private let viewModel = CalendarViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var editDiaryFloatingPanelController: FloatingPanelController!
    private var previousPanelState: FloatingPanelState = .hidden
    
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
        $0.text = ""
        $0.font = Suite.regular.of(size: 16)
    }
    
    private let detailButton = UIButton().then {
        $0.setTitle("자세한 내용을 확인해보세요!", for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 16)
        $0.backgroundColor = .clear
        $0.setTitleColor(.appDarkGray, for: .normal)
    }
    
    private let writeButton = UIButton().then {
        $0.layer.cornerRadius = 28
        $0.backgroundColor = .appBlack
        $0.setImage(.addDiary, for: .normal)
    }
    
    private var boldDates: [Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.description())
        
        setupViews()
        setupConstraints()
        setupDiaryPannel()
        
        bindViewModel()
        viewModel.loadCalendarData()
        viewModel.loadTargetData()
        
        let today = Date()
            calendar.select(today)
            updateDiaryLabel(for: today)
        
        detailButton.addTarget(self, action: #selector(tapDetailButton), for: .touchUpInside)
        writeButton.addTarget(self, action: #selector(tapWriteButton), for: .touchUpInside)
        
        navigationController?.navigationBar.isHidden = false
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        editDiaryFloatingPanelController.dismiss(animated: true)
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
            $0.bottom.equalTo(detailButton.snp.bottom).offset(100)
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
            $0.width.equalTo(56)
            $0.height.equalTo(56)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func bindViewModel() {
        viewModel.$errorMessage // 에러 메시지 출력
            .receive(on: DispatchQueue.main)
            .sink { errorMessage in
                if let errorMessage = errorMessage {
                    print(errorMessage)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$calendarListModels
            .receive(on: DispatchQueue.main)
            .print("캘린더 데이터 업데이트")
            .sink { [weak self] _ in
                self?.calendar.selectedDates.forEach { self?.calendar.deselect($0) }
                self?.calendar.reloadData()
                if let today = self?.calendar.today {
                               self?.updateDiaryLabel(for: today)
                           }
            }
            .store(in: &cancellables)
        
        viewModel.$createDate
            .combineLatest(viewModel.$targetDate)
            .receive(on: DispatchQueue.main)
            .print("기간 업데이트")
            .sink { [weak self] createDate, targetDate in
                if let createDate = createDate, let targetDate = targetDate {
                    self?.boldDates = self?.generateDates(from: createDate, to: targetDate) ?? []
                    self?.calendar.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateDiaryLabel(for date: Date) {
        updateDayLabel(for: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString = dateFormatter.string(from: date)
        
        if let record = viewModel.calendarListModels?.first(where: { $0.diaryDate == dateString }) {
            diaryLabel.text = record.diaryText ?? "기록이 없습니다."
            if record.diaryText != nil {
                diaryLabel.textColor = .black
            } else {
                diaryLabel.textColor = .appDarkGray
            }
        } else {
            diaryLabel.text = "기록이 없습니다."
            diaryLabel.textColor = .appDarkGray
        }
    }
    
    private func updateDayLabel(for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M.d EEEE" // "M.d EEEE" 형식으로 설정
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일로 설정
        let dateString = dateFormatter.string(from: date)
        dayLabel.text = dateString
    }
    
    @objc func tapDetailButton() {
        let nextView = DayViewController()
        nextView.viewModel = viewModel
        
        self.present(nextView, animated: true)
    }
    
    @objc func tapWriteButton() {
        editDiaryFloatingPanelController.addPanel(toParent: self)
    }
    
    // 키보드가 나타날 때 호출되는 메서드
    @objc override func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if userInfo[UIResponder.keyboardFrameEndUserInfoKey] is CGRect {
            // FloatingPanel 높이 수정
            editDiaryFloatingPanelController.move(to: .full, animated: true)
        }
    }
    
    // 키보드가 사라질 때 호출되는 메서드
    @objc override func keyboardWillHide(notification: NSNotification) {
        editDiaryFloatingPanelController.move(to: .half, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CalendarViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ vc: FloatingPanelController) {
        if vc.state == .full {
            vc.backdropView.dismissalTapGestureRecognizer.isEnabled = false
        } else if vc.state == .half {
            vc.backdropView.dismissalTapGestureRecognizer.isEnabled = false

            // 상태가 .full에서 .half로 변경되었을 때 키보드를 숨김
            if previousPanelState == .full {
                view.endEditing(true)
            }
        } else {
            vc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        }
        previousPanelState = vc.state
    }

    
    func floatingPanelDidRemove(_ vc: FloatingPanelController) {
        vc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        
    }
    
    func setupDiaryPannel(){
        editDiaryFloatingPanelController = FloatingPanelController()
        
        let contentVC = DiaryRecordFloatingViewController()
        contentVC.viewModel = viewModel
        editDiaryFloatingPanelController.set(contentViewController: contentVC)
        
        editDiaryFloatingPanelController.layout = CustomFloatingPanelLayout()
        editDiaryFloatingPanelController.isRemovalInteractionEnabled = true
        editDiaryFloatingPanelController.changePanelStyle()
        editDiaryFloatingPanelController.delegate = self
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func createDate(from dateString: String) -> Date {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy.MM.dd"
           return dateFormatter.date(from: dateString)!
       }
    
    func generateDates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        let calendar = Calendar.current
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let calendar = Calendar.current
        if boldDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return .appBlack // 볼드 처리된 날짜의 텍스트 색상
        } else {
            return .appLightGray // 기본 텍스트 색상
        }
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.description(), for: date, at: position) as? CalendarCell else {
            print("Error: CalendarCell is nil")
            return FSCalendarCell() }
                
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString = dateFormatter.string(from: date)
        
        var colors: [UIColor] = []
        if let record = viewModel.calendarListModels?.first(where: { $0.diaryDate == dateString }) {
            if record.dietPicture != nil {
                colors.append(.appYellow)
            }
            if record.workoutList != nil {
                colors.append(.appGreen)
            }
        }
        
        cell.configure(with: colors)
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.selectedDate = date
        updateDiaryLabel(for: date)
    }
    
    private func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIFont? {
        let calendar = Calendar.current
        if boldDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return Suite.bold.of(size: 16) // 볼드 처리된 날짜의 배경 색상
        } else {
            return Suite.regular.of(size: 16) // 기본 배경 색상
        }
    }
    
    // 선택된 날짜의 색상을 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .appGreen
    }
    
    // 오늘 날짜의 색상을 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if Calendar.current.isDateInToday(date) {
            return .appYellow
        }
        return nil
    }
}
