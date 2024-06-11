//
//  UIApplication.swift
//  Sikmogil
//
//  Created by 희라 on 6/4/24.
//  [extension] **설명** 최상단에 표시되고 있는 뷰 컨트롤러를 찾는 데 사용. 플로팅배너에 필요

import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController? {
        
        // 내비게이션 컨트롤러 타입이라면 현재 화면에 보이는 컨트롤러.
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        // 탭바 컨트롤러 타입이라면 선택되어 있는 뷰 컨트롤러.
        if let tabController = controller as? UITabBarController {
            // 탭바 내에서 모달로 표시된 경우에도 탭바를 반환
            if let selected = tabController.selectedViewController {
                if let presented = selected.presentedViewController {
                    return topViewController(controller: presented)
                }
                return selected
            }
        }
        
        // 프레젠트 상태면 프레젠트 된(모달로 표시된) 뷰 컨트롤러.
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
    
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            // 활성화된 씬 중에서 키 윈도우를 반환
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first { $0.isKeyWindow }
        } else {
            // iOS 13 미만에서는 기존 방식 사용
            return UIApplication.shared.keyWindow
        }
    }
}
