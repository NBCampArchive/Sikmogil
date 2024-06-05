//
//  Step3ViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import UIKit
import SnapKit
import Then

class Step3ViewController: UIViewController {
    
    var viewModel: OnboardingViewModel {
        return onboardingPageViewController!.viewModel
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "알림 설정"
        $0.font = Suite.bold.of(size: 28)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "하루 리마인드 알림을 원하는 시간을 선택해주세요"
        $0.font = Suite.semiBold.of(size: 14)
        $0.textColor = .customDarkGray
    }
    
    private let timePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.locale = Locale(identifier: "ko_KR")
        $0.preferredDatePickerStyle = .wheels
    }
    
    private let doneButton = UIButton(type: .system).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.backgroundColor = .customBlack
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupAddTargets()
    }
    
    private func setupAddTargets() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, timePicker)
        view.addSubview(doneButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(doneButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
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
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(200)
            $0.width.equalToSuperview().offset(-32)
            $0.bottom.equalToSuperview().offset(-32)
        }
    
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func doneButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.string(from: timePicker.date)
        
        viewModel.saveReminderData(reminderTime: selectedTime)
        
        viewModel.submitProfile { result in
            switch result {
            case .success:
                print("Profile submitted successfully")
                // 완료 후의 동작 (예: 다음 화면으로 이동)
            case .failure(let error):
                print("Failed to submit profile: \(error)")
                // 에러 처리
            }
        }
    }
}
