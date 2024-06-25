//
//  SplashViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/23/24.
//

import UIKit
import SnapKit
import Then
import KeychainSwift

class SplashViewController: UIViewController {
    private let splashImageView = UIImageView().then {
        $0.image = UIImage(named: "backgroundImage") // 최종 이미지
        $0.contentMode = .scaleAspectFill
        $0.alpha = 0 // 애니메이션 완료 후 표시될 이미지
    }
    
    private let logoTitle = UILabel().then {
        $0.text = "식목일"
        $0.font = BagelFatOne.regular.of(size: 40)
        $0.textColor = .appBlack
        $0.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(splashImageView, logoTitle)
        
        splashImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(200)
        }
        
        performSplashAnimation()
    }
    
    private func performSplashAnimation() {
        var circleDiameter: CGFloat = 300
        let circles = createCircles(diameter: circleDiameter)
        
        for circle in circles {
            view.addSubview(circle)
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
            for circle in circles {
                circle.center = self.view.center
            }
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                for circle in circles {
                    switch circle.tag {
                    case 0:
                        circle.center = CGPoint(x: self.view.frame.size.width + circleDiameter, y: self.view.frame.size.height + circleDiameter)
                    case 1:
                        circle.center = CGPoint(x: -circleDiameter, y: self.view.frame.size.height + circleDiameter)
                    case 2:
                        circle.center = CGPoint(x: self.view.frame.size.width + circleDiameter, y: -circleDiameter)
                    case 3:
                        circle.center = CGPoint(x: -circleDiameter, y: -circleDiameter)
                    default:
                        break
                    }
                }
                self.splashImageView.alpha = 1
                self.logoTitle.alpha = 1
            } completion: { _ in
                print("스플래시 애니메이션 완료")
                self.checkTokenAndNavigate()
            }
        }
    }
    
    private func createCircles(diameter: CGFloat) -> [UIView] {
        var circles = [UIView]()
        
        let colors: [UIColor] = [.appGreen, .appYellow, .appPurple, .appSkyBlue]
        
        for index in 0..<4 {
            let circle = UIView().then {
                $0.frame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
                $0.layer.cornerRadius = diameter / 2
                $0.backgroundColor = colors[index]
                $0.tag = index
            }
            circles.append(circle)
        }
        
        let viewWidth = view.frame.size.width
        let viewHeight = view.frame.size.height
        
        circles[0].center = CGPoint(x: -diameter, y: -diameter) // 왼쪽 상단
        circles[1].center = CGPoint(x: viewWidth + diameter, y: -diameter) // 오른쪽 상단
        circles[2].center = CGPoint(x: -diameter, y: viewHeight + diameter) // 왼쪽 하단
        circles[3].center = CGPoint(x: viewWidth + diameter, y: viewHeight + diameter) // 오른쪽 하단
        
        return circles
    }
    
    private func checkTokenAndNavigate() {
        if KeychainSwift().get("refreshToken") != nil {
            // Refresh 토큰이 있으면 토큰 갱신 시도
            LoginAPIManager.shared.refreshToken { result in
                switch result {
                case .success:
                    // 토큰 갱신 성공, 메인 화면으로 이동
                    DispatchQueue.main.async {
                        print("메인화면 이동")
                        self.navigateToMainScreen()
                    }
                case .failure:
                    // 토큰 갱신 실패, 로그인 화면으로 이동
                    DispatchQueue.main.async {
                        print("로그인 이동")
                        self.navigateToLoginScreen()
                    }
                }
            }
        } else {
            // Refresh 토큰이 없으면 로그인 화면으로 이동
            navigateToLoginScreen()
        }
    }
    
    private func navigateToLoginScreen() {
        print("로그인 화면으로 이동")
        let loginViewController = LoginViewController()
        let navigationController = CustomNavigationController(rootViewController: loginViewController)
        setRootViewController(navigationController)
    }
    
    private func navigateToMainScreen() {
        print("메인 화면으로 이동")
        let bottomTabBarController = BottomTabBarController()
        setRootViewController(bottomTabBarController)
    }
    
    private func setRootViewController(_ viewController: UIViewController) {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            UIView.animate(withDuration: 1.5) {
                window.rootViewController = viewController
                window.makeKeyAndVisible()
            }
        }
    }
}
