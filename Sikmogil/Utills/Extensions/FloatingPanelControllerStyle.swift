//
//  FloatingPanelControllerStyle.swift
//  Sikmogil
//
//  Created by 희라 on 6/4/24.
//  [extension] **설명** 플로팅패널 기본 스타일

import UIKit
import FloatingPanel

extension FloatingPanelController {
    
    func changePanelStyle() {
        let appearance = SurfaceAppearance()
        let shadow = SurfaceAppearance.Shadow()
        
        // 그림자
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: -4.0)
        shadow.opacity = 0.15
        shadow.radius = 2
        appearance.shadows = [shadow]
        
        // 테두리
        appearance.cornerRadius = 25.0
        appearance.backgroundColor = .clear
        appearance.borderColor = .clear
        appearance.borderWidth = 0
        
        surfaceView.grabberHandle.isHidden = false // 상단 손잡이 바
        surfaceView.appearance = appearance
        
        // 백드롭 (바텀 시트 뒷 화면)
        backdropView.dismissalTapGestureRecognizer.isEnabled = false
        backdropView.backgroundColor = UIColor.black
    }
}
