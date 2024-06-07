//
//  DietViewModel.swift
//  Sikmogil
//
//  Created by 희라 on 6/3/24.
//  [ViewModel] **설명** 다이어트 뷰모델, 플로팅패널 연결 등

import UIKit
import FloatingPanel

class DietViewModel {
    func showDietBottomSheet(from viewController: UIViewController) {
        
        let floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = viewController as? FloatingPanelControllerDelegate
        
        floatingPanelController.changePanelStyle()

        // ContentViewController 설정
        let contentVC = DietBottomSheetViewController()
        floatingPanelController.set(contentViewController: contentVC)

        // 패널 추가
        floatingPanelController.addPanel(toParent: viewController)
    }
    
    func showWaterBottomSheet(from viewController: UIViewController) {
        
        let floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = viewController as? FloatingPanelControllerDelegate
        
        floatingPanelController.changePanelStyle()

        // ContentViewController 설정
        let contentVC = WaterBottomSheetViewController()
        floatingPanelController.set(contentViewController: contentVC)

        // 패널 추가
        floatingPanelController.addPanel(toParent: viewController)
    }
}
