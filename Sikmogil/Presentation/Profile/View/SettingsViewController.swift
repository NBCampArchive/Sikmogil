//
//  NotificationSettingsViewController.swift
//  Sikmogil
//
//  Created by 박준영 on 6/5/24.
//  [알림설정] 🔔 설정 

import UIKit
import SnapKit
import Then
import UserNotifications

class NotificationSettingsViewController: UIViewController {
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let userTitleLabel = UILabel().then {
        $0.text = "회원 정보"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    
    private let notificationTitleLabel = UILabel().then {
        $0.text = "알림 설정"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    
    private let informationTitleLabel = UILabel().then {
        $0.text = "이용 정보"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    
    private let userTableView = UITableView(frame: .zero).then {
        $0.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .singleLine
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    private let notificationTableView = UITableView(frame: .zero).then {
        $0.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .singleLine
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    private let informationTableView = UITableView(frame: .zero).then {
        $0.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .singleLine
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        checkAndRegisterNotification()
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - 알림설정 저장 및 예약제거
    private func saveNotificationSetting(isEnabled: Bool) {
        print("알림 설정 저장 호출됨: \(isEnabled)")
        UserDefaults.standard.set(isEnabled, forKey: "NotificationEnabled")
    }
    
    private func checkAndRegisterNotification() {
        let isEnabled = loadNotificationSetting()
    }
    
    // 알림 설정 로드
    private func loadNotificationSetting() -> Bool {
        return UserDefaults.standard.bool(forKey: "NotificationEnabled")
    }
    
    // MARK: - setupViews
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(userTitleLabel)
        contentView.addSubview(userTableView)
        contentView.addSubview(notificationTitleLabel)
        contentView.addSubview(notificationTableView)
        contentView.addSubview(informationTitleLabel)
        contentView.addSubview(informationTableView)
        
        userTableView.delegate = self
        userTableView.dataSource = self
        
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        
        informationTableView.delegate = self
        informationTableView.dataSource = self
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        userTitleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        userTableView.snp.makeConstraints {
            $0.top.equalTo(userTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        notificationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(userTableView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        notificationTableView.snp.makeConstraints {
            $0.top.equalTo(notificationTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        informationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(notificationTableView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        informationTableView.snp.makeConstraints {
            $0.top.equalTo(informationTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension NotificationSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case userTableView:
            return 3
        case notificationTableView:
            return 3
        case informationTableView:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else {
            return UITableViewCell()
        }
        
        switch tableView {
        case userTableView:
            switch indexPath.row {
            case 0:
                cell.label.text = "프로필 수정"
                cell.iconImageView.image = UIImage(named: "user")
                cell.customSwitch.isHidden = true
                cell.showsAccessoryButton = true
            case 1:
                cell.label.text = "목표 설정"
                cell.iconImageView.image = UIImage(named: "marker")
                cell.customSwitch.isHidden = true
                cell.showsAccessoryButton = true
            case 2:
                cell.label.text = "계정 관리"
                cell.iconImageView.image = UIImage(named: "key")
                cell.customSwitch.isHidden = true
                cell.showsAccessoryButton = true
            default:
                break
            }
        case notificationTableView:
            switch indexPath.row {
            case 0:
                cell.label.text = "리마인드 알림 설정"
                cell.iconImageView.image = UIImage(named: "clock")
                cell.customSwitch.isHidden = true
                cell.showsAccessoryButton = true
            case 1:
                cell.label.text = "공복 알림 시간 설정"
                cell.iconImageView.image = UIImage(named: "stopwatch")
                cell.customSwitch.isHidden = true
                cell.showsAccessoryButton = true
            case 2:
                cell.iconImageView.image = UIImage(named: "alarm")
                cell.label.text = "알림 On / Off"
                cell.customSwitch.isHidden = false
                cell.customSwitch.isOn = loadNotificationSetting()
                cell.showsAccessoryButton = false
                cell.switchValueChanged = { [weak self] isOn in
                    print("알림 ON : \(isOn)")
                    self?.saveNotificationSetting(isEnabled: isOn)
                }
            default:
                break
            }
        case informationTableView:
            cell.iconImageView.image = UIImage(named: "Information")
            cell.label.text = "개인정보 처리 방침"
            cell.customSwitch.isHidden = true
            cell.showsAccessoryButton = true
        default:
            break
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == userTableView {
            switch indexPath.row {
            case 0:
                let editProfileVC = EditProfileViewController()
                navigationController?.pushViewController(editProfileVC, animated: true)
            case 1:
                let goalSettingsVC = GoalSettingsViewController()
                navigationController?.pushViewController(goalSettingsVC, animated: true)
//            case 2:
//                let accountManagementVC = AccountManagementViewController()
//                navigationController?.pushViewController(accountManagementVC, animated: true)
            default:
                break
            }
        } else if tableView == notificationTableView {
            switch indexPath.row {
            case 0:
                let reminderVC = ReminderSettingsViewController()
                reminderVC.viewModel = ProfileViewModel()
                navigationController?.pushViewController(reminderVC, animated: true)
//            case 1:
//                let fastingReminderVC = FastingReminderSettingsViewController()
//                navigationController?.pushViewController(fastingReminderVC, animated: true)
            default:
                break
            }
        } else if tableView == informationTableView {
            let privacyPolicyVC = PrivacyPolicyViewController()
            navigationController?.pushViewController(privacyPolicyVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
