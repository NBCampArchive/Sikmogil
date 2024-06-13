//
//  DiaryRecordFloatingViewController.swift
//  Sikmogil
//
//  Created by 문기웅 on 6/9/24.
//

import UIKit
import Then
import SnapKit

class DiaryRecordFloatingViewController: UIViewController {
    
    private let label = UILabel().then {
        $0.text = "오늘의 한 줄 일기를 작성해보세요!"
        $0.font = Suite.regular.of(size: 22)
        $0.textAlignment = .center
    }
    
    private let diaryTextView = UITextView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .appLightGray
        $0.font = Suite.regular.of(size: 14)
        $0.textAlignment = .left
        $0.keyboardType = .default
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    let doneButton = UIButton().then {
        $0.setTitle("작성 완료", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupViews()
        setupConstraints()
        hideKeyboardWhenTappedAround()
        
        doneButton.addTarget(self, action: #selector(tapDoneButton), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubviews(label, diaryTextView, doneButton)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
        }
        
        diaryTextView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(100)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(diaryTextView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(60)
        }
    }
    
    @objc func tapDoneButton() {
        if diaryTextView.text.isEmpty {
            self.dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "일기를 저장하시겠어요?", message: nil, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "네", style: .default) { _ in
               //TODO: 일기 저장 추가
                self.dismiss(animated: true)
            }
            
            let cancelAction = UIAlertAction(title: "아니요", style: .cancel) { _ in
                self.dismiss(animated: true)
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
    }
}
