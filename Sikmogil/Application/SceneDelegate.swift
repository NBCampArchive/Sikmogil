//
//  SceneDelegate.swift
//  Sikmogil
//
//  Created by 박현렬 on 5/31/24.
//

import UIKit
import KeychainSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        // MARK: - API Test 시 아래 코드를 주석 처리하고 진행해주세요 (간단한 UI 수정시에만 사용해주세요)
        let viewController = OnboardingViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
        
        // MARK: - API Test 시 아래 코드를 활성화 하고 진행해주세요
        // 토큰 유효성 검사
//        if KeychainSwift().get("refreshToken") != nil {
//            // Refresh 토큰이 있으면 토큰 갱신 시도
//            LoginAPIManager.shared.refreshToken { result in
//                switch result {
//                case .success:
//                    // 토큰 갱신 성공, 메인 화면으로 이동
//                    DispatchQueue.main.async {
//                        self.showMainScreen()
//                    }
//                case .failure:
//                    // 토큰 갱신 실패, 로그인 화면으로 이동
//                    DispatchQueue.main.async {
//                        self.showLoginScreen()
//                    }
//                }
//            }
//        } else {
//            // Refresh 토큰이 없으면 로그인 화면으로 이동
//            showLoginScreen()
//        }
        //여기까지 주석 처리
    }
    
    private func showLoginScreen() {
        let loginViewController = LoginViewController()
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
    }
    
    private func showMainScreen() {
        let mainViewController = BottomTabBarController()
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

