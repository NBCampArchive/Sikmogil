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
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = .clear
    }
    
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
    
    let wavewView = WaveProgressView().then {
        $0.layer.cornerRadius = 150
        $0.layer.masksToBounds = true
        $0.backgroundColor = .customLightGray
        $0.progress = 0.5
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
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentsView)
        contentsView.addSubviews(circularProgressBar, customCircularProgressBar, wavewView)
        contentsView.addSubview(label)
    }
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        circularProgressBar.snp.makeConstraints {
            $0.top.equalToSuperview()
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
        
        wavewView.snp.makeConstraints {
            $0.top.equalTo(customCircularProgressBar.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
}

