//
//  SettingsViewController.swift
//  Sikmogil
//
//  Created by 박준영 on 6/5/24.
//  [설정] ⚙️ 설정 ⚙️

import UIKit
import SnapKit
import Then
import UserNotifications

class SettingsViewController: UIViewController {
    
    var viewModel = ProfileViewModel()
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let userTitleLabel = UILabel().then {
        $0.text = "회원 정보"
        $0.font = Suite.bold.of(size: 24)
        $0.textColor = .black
    }
    
    private let notificationTitleLabel = UILabel().then {
        $0.text = "알림 설정"
        $0.font = Suite.bold.of(size: 24)
        $0.textColor = .black
    }
    
    private let informationTitleLabel = UILabel().then {
        $0.text = "이용 정보"
        $0.font = Suite.bold.of(size: 24)
        $0.textColor = .black
    }
    
    private let userTableView = UITableView(frame: .zero).then {
        $0.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .singleLine
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    private let notificationTableView = UITableView(frame: .zero).then {
        $0.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .singleLine
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    private let informationTableView = UITableView(frame: .zero).then {
        $0.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.separatorStyle = .singleLine
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        checkAndRegisterNotification()
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Notification Settings
    private func saveNotificationSetting(isEnabled: Bool) {
        print("알림 설정 저장 호출됨: \(isEnabled)")
        UserDefaults.standard.set(isEnabled, forKey: "NotificationEnabled")
    }
    
    private func checkAndRegisterNotification() {
        _ = loadNotificationSetting()
    }
    
    private func loadNotificationSetting() -> Bool {
        return UserDefaults.standard.bool(forKey: "NotificationEnabled")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(userTitleLabel, userTableView, notificationTitleLabel, notificationTableView, informationTitleLabel, informationTableView)
        
        userTableView.delegate = self
        userTableView.dataSource = self
        
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        
        informationTableView.delegate = self
        informationTableView.dataSource = self
    }
    
    // MARK: - Setup Constraints
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
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        switch tableView {
        case userTableView:
            switch indexPath.row {
            case 0:
                cell.label.text = "프로필 수정"
                cell.iconImageView.image = UIImage(named: "user")?.withRenderingMode(.alwaysOriginal).withTintColor(.appDeepDarkGray)
                cell.customSwitch.isHidden = true
                cell.showsAccessoryButton = true
            case 1:
                cell.label.text = "목표 설정"
                cell.iconImageView.image = UIImage(named: "marker")?.withRenderingMode(.alwaysOriginal).withTintColor(.appDeepDarkGray)
                cell.customSwitch.isHidden = true
                cell.showsAccessoryButton = true
            case 2:
                cell.label.text = "계정 관리"
                cell.iconImageView.image = UIImage(named: "key")?.withRenderingMode(.alwaysOriginal).withTintColor(.appDeepDarkGray)
                cell.customSwitch.isHidden = true
                cell.showsAccessoryButton = true
            default:
                break
            }
        case notificationTableView:
            switch indexPath.row {
            case 0:
                cell.label.text = "리마인드 알림 설정"
                cell.iconImageView.image = UIImage(named: "clock")?.withRenderingMode(.alwaysOriginal).withTintColor(.appDeepDarkGray)
                cell.customSwitch.isHidden = true
                cell.showsAccessoryButton = true
            case 1:
                cell.label.text = "공복 알림 시간 설정"
                cell.iconImageView.image = UIImage(named: "stopwatch")?.withRenderingMode(.alwaysOriginal).withTintColor(.appDeepDarkGray)
                cell.customSwitch.isHidden = true
                cell.showsAccessoryButton = true
            case 2:
                cell.iconImageView.image = UIImage(named: "alarm")?.withRenderingMode(.alwaysOriginal).withTintColor(.appDeepDarkGray)
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
            cell.iconImageView.image = UIImage(named: "Information")?.withRenderingMode(.alwaysOriginal).withTintColor(.appDeepDarkGray)
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
                editProfileVC.viewModel = viewModel
                navigationController?.pushViewController(editProfileVC, animated: true)
            case 1:
                let goalSettingsVC = GoalSettingsViewController()
                goalSettingsVC.viewModel = viewModel
                navigationController?.pushViewController(goalSettingsVC, animated: true)
            case 2:
                presentAccountManagementActionSheet()
            default:
                break
            }
        } else if tableView == notificationTableView {
            switch indexPath.row {
            case 0:
                let reminderVC = ReminderSettingsViewController()
                reminderVC.viewModel = ProfileViewModel()
                navigationController?.pushViewController(reminderVC, animated: true)
            case 1:
                let spandrelVC = SpandrelSettingsViewController()
                navigationController?.pushViewController(spandrelVC, animated: true)
            default:
                break
            }
        } else if tableView == informationTableView {
            let privacyPolicyVC = PrivacyPolicyViewController()
            privacyPolicyVC.nextButton.isHidden = true
            navigationController?.pushViewController(privacyPolicyVC, animated: true)
        }
    }
    private func presentAccountManagementActionSheet() {
        let actionSheet = UIAlertController(title: "계정 관리", message: "회원 탈퇴 시 모든 정보가 지워집니다", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "로그아웃", style: .default) { _ in
            self.presentLogoutConfirmation()
        }
        
        let deleteAccountAction = UIAlertAction(title: "회원탈퇴", style: .destructive) { _ in
            self.presentDeleteAccountConfirmation()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheet.addAction(logoutAction)
        actionSheet.addAction(deleteAccountAction)
        actionSheet.addAction(cancelAction)
        
        // iPad 대응
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // 로그아웃 확인 얼럿
    private func presentLogoutConfirmation() {
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "예", style: .default) { _ in
            self.logout()
        }
        
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // 회원탈퇴 확인 얼럿
    private func presentDeleteAccountConfirmation() {
        let alert = UIAlertController(title: "회원탈퇴", message: "정말 회원탈퇴 하시겠습니까?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "예", style: .destructive) { _ in
            self.deleteAccount()
        }
        
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func logout() {
        TokenStorage.shared.clearTokens()
        navigationRootView()
    }
    
    private func deleteAccount() {
        print("회원 탈퇴")
        UserAPIManager.shared.deleteAccount() { result in
            switch result {
            case .success():
                print("회원 탈퇴 성공")
                TokenStorage.shared.clearTokens()
                self.navigationRootView()
            case .failure(_):
                print("회원 탈퇴 실패")
            }
        }
    }
    
    private func navigationRootView() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let loginVC = SplashViewController()
            let navController = CustomNavigationController(rootViewController: loginVC)
            
            UIView.transition(with: sceneDelegate.window!, duration: 0.5, options: .transitionFlipFromRight, animations: {
                sceneDelegate.window?.rootViewController = navController
            })
            
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
