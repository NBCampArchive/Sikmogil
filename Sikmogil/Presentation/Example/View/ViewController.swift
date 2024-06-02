//
//  ViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 5/31/24.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    
    let circularProgressBar = CircularProgressBar().then {
        $0.backgroundColor = .clear
        $0.progressColor = .systemBlue
        $0.trackColor = .lightGray
    }
    
    let customCircularProgressBar = CustomCircularProgressBar().then {
        $0.backgroundColor = .clear
        $0.progressColor = .systemYellow
        $0.trackColor = .lightGray
    }
    
    let label = UILabel().then {
        $0.text = "Hello, World!"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20)
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        
        // 프로그래스 업데이트 (예시: 0.75 -> 75%)
        circularProgressBar.progress = 0.95
        customCircularProgressBar.progress = 0.9
    }
    
    private func setupViews() {
        view.addSubviews(circularProgressBar, customCircularProgressBar)
        view.addSubview(label)
    }
    
    private func setupConstraints() {
        circularProgressBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        customCircularProgressBar.snp.makeConstraints {
            $0.top.equalTo(circularProgressBar.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        label.snp.makeConstraints {
            $0.center.equalTo(customCircularProgressBar)
        }
    }
    
}

// ViewController나 View 파일은 각 뷰 폴더의 하위 파일에 View라는 파일을 생성해 추가해주세요.
// Cell 파일 같은경우 View > Cell 폴더를 생성해서 추가해주세요.
