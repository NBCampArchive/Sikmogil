//
//  ProfileCoordinatorController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/18/24.
//

import UIKit
import Combine

class ProfileCoordinatorController {
    private let navigationController: UINavigationController
    private let viewModel = ProfileViewModel()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let profileViewController = ProfileViewController()
        profileViewController.coordinator = self
        profileViewController.viewModel = viewModel
        navigationController.pushViewController(profileViewController, animated: false)
    }

    func showEditProfile() {
        let editProfileVC = EditProfileViewController()
        editProfileVC.viewModel = viewModel
        navigationController.pushViewController(editProfileVC, animated: true)
    }

    func showNotificationSettings() {
        let notificationSettingsVC = NotificationSettingsViewController()
//        notificationSettingsVC.viewModel = viewModel
//        notificationSettingsVC.coordinator = self
        navigationController.pushViewController(notificationSettingsVC, animated: true)
    }

    func showGoalSettings() {
        let goalSettingsVC = GoalSettingsViewController()
        goalSettingsVC.viewModel = viewModel
        navigationController.pushViewController(goalSettingsVC, animated: true)
    }
    
    func showReminderSettings() {
        let reminderSettingsVC = ReminderSettingsViewController()
        reminderSettingsVC.viewModel = viewModel
        navigationController.pushViewController(reminderSettingsVC, animated: true)
    }
}
