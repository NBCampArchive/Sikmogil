//
//  ReminderSettingsViewController.swift
//  Sikmogil
//
//  Created by 박준영 on 6/6/24.
//  [리마인드] ⏰ 리마인드 시간 설정 ⏰

import UIKit
import SnapKit
import Then
import Combine

class ReminderSettingsViewController: UIViewController {
    
    var viewModel: ProfileViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "리마인드 알림 시간 설정"
        $0.font = Suite.bold.of(size: 28)
        $0.textColor = .appBlack
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "하루 리마인드 알림을 원하는 시간을 선택해주세요"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    private let timePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.locale = Locale(identifier: "ko_KR")
        $0.preferredDatePickerStyle = .wheels
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
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupAddTargets() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - 리마인드 시간 저장
    private func saveReminderTime(_ time: String) {
        UserDefaults.standard.set(time, forKey: "ReminderTime")
        viewModel?.reminderTime = time
        viewModel?.saveReminderData()
    }
    
    // MARK: - 뷰모델 바인딩
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        // 뷰모델의 reminderTime과 timeTextField를 바인딩
        viewModel.$reminderTime
            .sink { [weak self] time in
                guard let self = self else { return }
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                if let date = formatter.date(from: time) {
                    self.timePicker.date = date
                }
            }
            .store(in: &cancellables)

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
    
    @objc private func completeButtonTapped() {
        guard let viewModel = viewModel else {
            print("ViewModel is nil")
            return
        }
        
        // timeTextField의 값을 뷰모델에 업데이트
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let selectedTime = formatter.string(from: timePicker.date)
        
        viewModel.reminderTime = selectedTime
        
        // 유효성 검사 후 저장 및 프로필 업데이트
        timeTextFieldWarningLabel.isHidden = true
        viewModel.saveReminderData()
        saveReminderTime(viewModel.reminderTime)
        
        // 데이터를 저장하는 부분 (submitProfile 호출)
        viewModel.submitProfile { [weak self] result in
            switch result {
            case .success:
                viewModel.debugPrint()
                self?.showAlertAndNavigateToProfile()
                self?.registerNotification(time: viewModel.reminderTime)
            case .failure(let error):
                self?.showErrorAlert(error: error)
            }
        }
        
    }
    
    private func registerNotification(time: String) {
        let components = time.split(separator: ":").map { Int($0) ?? 0 }
        var dateComponents = DateComponents()
        dateComponents.hour = components[0]
        dateComponents.minute = components[1]
        NotificationHelper.shared.scheduleDailyNotification(at: dateComponents) { error in
            if let error = error {
                print("알림 예약 실패: \(error)")
            } else {
                print("알림 예약 성공")
            }
        }
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "에러", message: "프로필 업데이트 실패: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertAndNavigateToProfile() {
        let alert = UIAlertController(title: "성공", message: "리마인드 설정이 완료되었습니다.", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            alert.dismiss(animated: true) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
