//
//  NotificationSettingsViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/5/24.
//

import UIKit
import SnapKit
import Then

class NotificationSettingsViewController: UIViewController {
    
    // UI Elements
    let tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.isScrollEnabled = false
    }
    
    let notificationSwitch = UISwitch().then {
        $0.isOn = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Add tableView
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        // Layout using SnapKit
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100) // Adjust height as needed
        }
        
        // Add Notification Switch
        view.addSubview(notificationSwitch)
        notificationSwitch.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension NotificationSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "리마인드 알림 시간 설정"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection
    }
}
