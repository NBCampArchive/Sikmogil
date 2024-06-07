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
        let homeVC = ViewController()
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), tag: 0)
        
        let dietVC = DietMainViewController()
        dietVC.tabBarItem = UITabBarItem(title: "식단", image: UIImage(named: "diet"), tag: 1)
        
        let exerciseVC = ViewController()
        exerciseVC.tabBarItem = UITabBarItem(title: "운동", image: UIImage(named: "exercise"), tag: 2)
        
        let communicationVC = ViewController()
        communicationVC.tabBarItem = UITabBarItem(title: "소통", image: UIImage(named: "communication"), tag: 3)
        
        let profileVC = ViewController()
        profileVC.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(named: "profile"), tag: 4)
        
        let controllers = [homeVC, dietVC, exerciseVC, communicationVC, profileVC]
        
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        
        // 탭바 선택 인덱스 설정 ( 0 부터 시작 )
        selectedIndex = 0
    }
    
    private func setupTabBarAppearance() {
        UITabBar.appearance().tintColor = .customBlack
        UITabBar.appearance().unselectedItemTintColor = .customDarkGray
        UITabBar.appearance().backgroundColor = .customLightGray
    }
}
