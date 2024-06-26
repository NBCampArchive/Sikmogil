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
        $0.textColor = .black
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "공복 알림을 원하는 시간으로 선택해주세요"
        $0.font = Suite.semiBold.of(size: 14)
        $0.textColor = .darkGray
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
        $0.layer.cornerRadius = 8
    }
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupAddTargets()
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupAddTargets() {
        
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
            $0.top.equalToSuperview().offset(32)
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
            $0.height.equalTo(60)
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
}

private func showAlertAndNavigateToProfile() {
    let alert = UIAlertController(title: "성공", message: "공복 시간 설정이 완료되었습니다.", preferredStyle: .alert)
}


