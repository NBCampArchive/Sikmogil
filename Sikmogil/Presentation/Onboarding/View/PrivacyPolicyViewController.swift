//
//  PrivacyPolicyViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/20/24.
//

import UIKit
import SnapKit
import Then

class PrivacyPolicyViewController: UIViewController {
    
    var onAgree: (() -> Void)?
    
    private let titleText = UILabel().then {
        $0.text = "개인정보 처리방침"
        $0.font = Suite.bold.of(size: 24)
    }
    
    private let textView = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.isEditable = false
        $0.isScrollEnabled = true
        $0.text = """
        1. 개인정보의 처리 목적
        서비스 제공
            키, 몸무게, 체중 등 건강 관련 데이터를 수집하여 맞춤형 건강관리 서비스를 제공합니다.
        회원 관리
            회원제 서비스 이용에 따른 본인확인, 개인 식별, 부정 이용 방지 등을 위해 사용됩니다.
        서비스 개선
            서비스 개선 및 신규 서비스 개발을 위해 사용됩니다.
        
        2. 개인정보 파일 현황
        개인정보 항목
            이름, 이메일 주소, 키, 몸무게, 체중
        수집 방법
            회원가입, 서비스 이용 중 사용자 입력
        쿠키 사용 여부
            당사는 쿠키를 저장하지 않으며 이용하지 않습니다. 이용자가 이에 대해 의문이 있다면 해당 서비스(애플 및 각 광고 미디어)로 직접 연락해야 합니다.
        
        3. 개인정보의 처리 및 보유기간
        처리 및 보유 항목: 이름, 이메일 주소, 키, 몸무게, 체중
        보유 기간: 서비스 이용 기간 동안 보유하며, 회원 탈퇴 시 지체 없이 파기합니다.
        
        4. 개인정보의 제3자 제공에 관한 사항 :
        당사는 개인정보를 제3자에게 제공하지 않고 있습니다.
        
        5. 개인정보처리 위탁 :
        당사는 개인정보를 위탁하고 있지 않습니다.
        
        6. 정보주체의 권리, 의무 및 그 행사방법 :
        이용자는 개인정보주체로서 권리 행사할 수 있습니다.
        
        1) 개인정보 열람요구
        2) 오류 등이 있을 경우 정정 요구
        3) 삭제요구
        4) 처리 정지 요구
        
        당사는 개인정보를 저장하거나 위탁하지 않습니다.
        
        7. 개인정보의 파기 :
        사용자가 원할 경우 '회원탈퇴' 기능으로 개인정보를 파기할 수 있습니다.
        
        8. 타사 모듈 사용에 대한 안내 :
        탑재된 타사 서비스 모듈은 없습니다.
        
        9. 개인정보 보호책임자 작성 :
        본 개인정보처리정책에 대해 궁금하신 사항이 있거나, 개인정보 처리절차에 대한 질문, 의견 또는 우려가 있을 경우 아래 연락처로 연락 주시기 바랍니다.
        
        이메일 : devpark435@gmail.com
        """
    }
    
    private let nextButton = UIButton(type: .system).then {
        $0.setTitle("동의", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.backgroundColor = .customBlack
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        nextButton.addTarget(self, action: #selector(agreeTapped), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubviews(titleText, textView)
        view.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        titleText.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-66)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
        
    }
    
    @objc private func agreeTapped() {
        dismiss(animated: true) {
            self.onAgree?()
        }
    }
}

