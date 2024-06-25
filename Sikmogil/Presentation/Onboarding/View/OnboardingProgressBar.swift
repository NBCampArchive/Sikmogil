//
//  OnboardingProgressBar.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import UIKit
import SnapKit

class OnboardingProgressBar: UIView {
    private let progressBar = UIProgressView(progressViewStyle: .default).then {
        $0.trackTintColor = .customLightGray
        $0.progressTintColor = .customBlack
        $0.layer.cornerRadius = 7.5
        $0.clipsToBounds = true
    }
    
    private let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(progressBar)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(15) // 원하는 높이 설정
        }
        
        progressBar.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(1) // 살짝 여유를 두어 예쁘게 보이게 설정
        }
    }
    
    func setProgress(_ progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }
}

