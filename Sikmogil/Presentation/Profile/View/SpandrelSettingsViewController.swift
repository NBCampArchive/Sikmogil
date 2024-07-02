//
//  SpandrelSettingsViewController.swift
//  Sikmogil
//
//  Created by 박준영 on 6/26/24.
//  [공복알림] ⏰ 공복알림 시간설정 ⏰

import UIKit
import SnapKit
import Then
import Combine

class SpandrelSettingsViewController: UIViewController {
    
    //    var viewModel: ProfileViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "공복 알림 시간 설정"
        $0.font = Suite.bold.of(size: 28)
        $0.textColor = .appBlack
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "원하는 공복 시간을 설정해주세요!"
        $0.font = Suite.semiBold.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    private let timePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .wheels
        $0.calendar = Calendar(identifier: .gregorian)
        $0.locale = Locale(identifier: "en_GB") // 24시간 형식
        $0.date = Date()
    }
    
    private let timeTextFieldWarningLabel = UILabel().then {
        $0.text = "시간을 입력해주세요"
        $0.font = Suite.regular.of(size: 12)
        $0.textColor = .red
        $0.isHidden = true
    }
    
    private let completeButton = UIButton(type: .system).then {
        $0.setTitle("저장하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupAddTargets()
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
        loadSavedTime()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupAddTargets() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func completeButtonTapped() {
        saveSelectedTime(date: timePicker.date)
        showAlertAndNavigateToProfile()
        print("Time saved: \(timePicker.date)")
    }
    
    private func saveSelectedTime(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // 24시간 형식으로 저장
        let timeString = dateFormatter.string(from: date)
        
        UserDefaults.standard.set(timeString, forKey: "fastingTime")
    }
    
    private func loadSavedTime() {
        if let savedTimeString = UserDefaults.standard.string(forKey: "fastingTime") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            if let savedTime = dateFormatter.date(from: savedTimeString) {
                timePicker.date = savedTime
            }
        } else {
            // 기본값을 14:00으로 설정
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            if let defaultTime = dateFormatter.date(from: "14:00") {
                timePicker.date = defaultTime
            }
        }
    }
    
    private func showAlertAndNavigateToProfile() {
        let alert = UIAlertController(title: "성공", message: "공복 시간 설정이 완료되었습니다.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            alert.dismiss(animated: true) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    
    // MARK: - setupConstraints
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, timePicker, timeTextFieldWarningLabel)
        view.addSubview(completeButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(completeButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        timePicker.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        timeTextFieldWarningLabel.snp.makeConstraints {
            $0.top.equalTo(timePicker.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
    
}



