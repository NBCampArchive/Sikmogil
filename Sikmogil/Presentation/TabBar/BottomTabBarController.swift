//
//  BottomTabBarController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/3/24.
//

import UIKit

class BottomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupTabBarAppearance()
    }
    
    private func setupTabBar() {
        let homeVC = MainViewController()
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), tag: 0)
        
        let dietVC = DietMainViewController()
        dietVC.tabBarItem = UITabBarItem(title: "식단", image: UIImage(named: "diet"), tag: 1)
        
        let exerciseVC = ExerciseMenuViewController()
        exerciseVC.tabBarItem = UITabBarItem(title: "운동", image: UIImage(named: "exercise"), tag: 2)
        
        let communicationVC = CommunityNavigationViewController()
        communicationVC.tabBarItem = UITabBarItem(title: "소통", image: UIImage(named: "communication"), tag: 3)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(named: "profile"), tag: 4)
        
        let controllers = [homeVC, dietVC, exerciseVC, communicationVC, profileVC]
        
        viewControllers = controllers.map { CustomNavigationController(rootViewController: $0) }
        
//        hidesBottomBarWhenPushed = true
        // 탭바 선택 인덱스 설정 ( 0 부터 시작 )
        selectedIndex = 0
    }
    
    //MARK: - 목표 수정 화면으로 이동
    func moveToProfileAndGoalSetting() {
        // 4번째 탭으로 이동
        self.selectedIndex = 3
        
        // 해당 탭의 네비게이션 컨트롤러를 통해 원하는 뷰 컨트롤러로 네비게이션
        if let navController = self.viewControllers?[3] as? UINavigationController {
            let settingVC = SettingsViewController()
            settingVC.hidesBottomBarWhenPushed = true
            
            let goalSettingVC = GoalSettingsViewController()
            goalSettingVC.viewModel = settingVC.viewModel
            navController.pushViewController(settingVC, animated: false)
            navController.pushViewController(goalSettingVC, animated: true)
        }
    }
    
    private func setupTabBarAppearance() {
        UITabBar.appearance().tintColor = .appBlack
        UITabBar.appearance().unselectedItemTintColor = .appDarkGray
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appLightGray
        
        
        // 모든 상태에 대해 같은 appearance를 적용합니다.
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        tabBar.layer.cornerRadius = 32
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
    }
}
