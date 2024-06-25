//
//  CustomNavigationBar.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/25/24.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAppearance()
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground() // 투명 배경 설정
        appearance.backgroundEffect = nil // 블러 효과 제거
        appearance.backgroundColor = .clear // 원하는 배경색 설정
        appearance.shadowColor = .clear // 그림자 제거
        
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance = backButtonAppearance
        
        // Appearance 설정을 네비게이션 바에 적용
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance // compactAppearance도 설정
    }
}
