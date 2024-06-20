//
//  NotificationSettingsViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/5/24.
//  [알림설정] 🔔 알림설정 🔔

import UIKit
import SnapKit
import Then
import UserNotifications

class NotificationSettingsViewController: UIViewController {
    
    var viewModel: ProfileViewModel?
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "알림 설정"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "알림/소리를 설정해보세요."
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print(requests)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadReminderTime() // 리마인드 시간 로드
    }
    
    private func loadReminderTime() {
        guard let reminderTime = viewModel?.reminderTime else { return }
        viewModel?.reminderTime = reminderTime
        tableView.reloadData()
    }
    
    private func saveNotificationSetting(isEnabled: Bool) {
        print("알림 설정 저장 호출됨: \(isEnabled)")
        UserDefaults.standard.set(isEnabled, forKey: "NotificationEnabled")
        if isEnabled {
            let defaultTime = viewModel?.reminderTime ?? ":"
            print("기본 알림 시간: \(defaultTime)")
            let components = defaultTime.split(separator: ":").map { Int($0) ?? 0 }
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
        } else {
            NotificationHelper.shared.clearAllNotifications()
            print("모든 알림이 취소되었습니다.")
        }
    }
    
    private func loadNotificationSetting() -> Bool {
        return UserDefaults.standard.bool(forKey: "NotificationEnabled")
    }
    
    // MARK: - UI 설정
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - 제약 조건 설정
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        let tableViewHeight = tableView.contentSize.height
        
        tableView.snp.remakeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(tableViewHeight)
        }
        
        contentView.snp.remakeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.bottom.equalTo(tableView.snp.bottom).offset(16)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension NotificationSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            cell.label.text = "리마인드 알림 시간 설정"
            cell.customSwitch.isHidden = true
            cell.showsAccessoryButton = true
        case 1:
            cell.label.text = "Notification"
            cell.customSwitch.isHidden = false
            cell.customSwitch.isOn = loadNotificationSetting()
            cell.showsAccessoryButton = false
            cell.switchValueChanged = { [weak self] isOn in
                print("스위치 값 변경됨: \(isOn)")
                self?.saveNotificationSetting(isEnabled: isOn)
            }
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let reminderVC = ReminderSettingsViewController()
            if let viewModel = viewModel {
                reminderVC.viewModel = viewModel // viewModel 전달
            }
            navigationController?.pushViewController(reminderVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 4 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 1
    }
}
