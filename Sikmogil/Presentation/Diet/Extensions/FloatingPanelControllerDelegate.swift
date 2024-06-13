//
//  File.swift
//  Sikmogil
//
//  Created by 희라 on 6/5/24.
//  [extension] **설명** DietMainView 플로팅패널 Delegate

import Foundation
import FloatingPanel

extension DietMainViewController: FloatingPanelControllerDelegate {
    
    // FloatingPanel이 이동할 때 호출되는 메서드
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        
        if fpc.state != .hidden {
            tabBarController?.tabBar.isHidden = true
        }

        // 패널의 현재 위치 가져오기
        let loc = fpc.surfaceLocation
        // 패널이 완전히 내려간 위치
        let maxY = fpc.surfaceLocation(for: .tip).y
        
        // tip보다 아래로 내려가면 패널 닫음
        if loc.y > maxY {
            fpc.move(to: .hidden, animated: true)
            fpc.hide(animated: true){
                self.tabBarController?.tabBar.isHidden = false
                fpc.view.removeFromSuperview()
                fpc.removeFromParent()
            }
        }
    }
}
