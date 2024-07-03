//
//  PrivacyPolicyViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/20/24.
//

import UIKit
import SnapKit
import Then
import MarkdownView
import SafariServices

class PrivacyPolicyViewController: UIViewController {
    
    var onAgree: (() -> Void)?
    
    private let titleText = UILabel().then {
        $0.text = "개인정보 처리방침"
        $0.font = Suite.bold.of(size: 24)
    }
    
    private let md = MarkdownView().then {
        $0.load(markdown: """
        #### **개인정보의 처리 목적**
        - **서비스 제공**
        <small>키, 몸무게, 체중 등 건강 관련 데이터를 수집하여 맞춤형 건강관리 서비스를 제공합니다.</small>
        
        - **회원 관리**
        <small>회원제 서비스 이용에 따른 본인확인, 개인 식별, 부정 이용 방지 등을 위해 사용됩니다.</small>
        
        - **서비스 개선**
        <small>서비스 개선 및 신규 서비스 개발을 위해 사용됩니다.</small>
        
        #### **개인정보 파일 현황**
        - **개인정보 항목**
        <small>이름, 이메일 주소, 키, 몸무게, 체중</small>
        
        - **수집 방법**
        <small>회원가입, 서비스 이용 중 사용자 입력</small>
        
        - **쿠키 사용 여부**
        <small>당사는 쿠키를 저장하지 않으며 이용하지 않습니다. 이용자가 이에 대해 의문이 있다면 해당 서비스(애플 및 각 광고 미디어)로 직접 연락해야 합니다.</small>
        
        #### **개인정보의 처리 및 보유기간**
        - **처리 및 보유 항목**
        <small>이름, 이메일 주소, 키, 몸무게, 체중</small>
        - **보유 기간**
        <small>서비스 이용 기간 동안 보유하며, 회원 탈퇴 시 지체 없이 파기합니다.</small>
        
        #### **개인정보의 제3자 제공에 관한 사항**
        - <small>당사는 개인정보를 제3자에게 제공하지 않고 있습니다.</small>
        
        #### **개인정보처리 위탁**
        - <small>당사는 개인정보를 위탁하고 있지 않습니다.</small>
        
        #### **정보주체의 권리, 의무 및 그 행사방법**
        - <small>**이용자는 개인정보 주체로서 권리 행사할 수 있습니다.**</small>
            <small>1)개인정보 열람요구
            2)오류 등이 있을 경우 정정 요구
            3)삭제요구
            4)처리 정지 요구</small>
        
        - <small>당사는 개인정보를 저장하거나 위탁하지 않습니다.</small>
        
        #### **개인정보의 파기**
        - <small>사용자가 원할 경우 '회원탈퇴' 기능으로 개인정보를 파기할 수 있습니다.</small>
        
        #### **타사 모듈 사용에 대한 안내**
        - <small>탑재된 타사 서비스 모듈은 없습니다.</small>
        
        #### **개인정보 보호책임자 작성**
        - <small>본 개인정보처리정책에 대해 궁금하신 사항이 있거나, 개인정보 처리절차에 대한 질문, 의견 또는 우려가 있을 경우 아래 연락처로 연락 주시기 바랍니다.
        
        이메일: <a href="mailto:sikmogilhealthcare@gmail.com">sikmogilhealthcare@gmail.com</a></small>
        """, css: """
        small {
            font-size: 14px;
        }
        """)
    }
    
    let nextButton = UIButton(type: .system).then {
        $0.setTitle("동의", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.backgroundColor = .customBlack
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupLinkHandler()
        nextButton.addTarget(self, action: #selector(agreeTapped), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubviews(titleText, md)
        view.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        titleText.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        md.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-66)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
        
    }
    
    private func setupLinkHandler() {
        md.onTouchLink = { [weak self] request in
            guard let url = request.url else { return false }
            
            if url.scheme == "mailto" {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    return false
                }
            } else if url.scheme == "https" {
                let safari = SFSafariViewController(url: url)
                self?.present(safari, animated: true, completion: nil)
                return false
            }
            return true
        }
    }
    
    @objc private func agreeTapped() {
        dismiss(animated: true) {
            self.onAgree?()
        }
    }
}

