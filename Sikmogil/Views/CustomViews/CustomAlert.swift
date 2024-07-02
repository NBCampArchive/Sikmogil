//
//  CustomAlert.swift
//  Sikmogil
//
//  Created by Developer_P on 7/2/24.
//

import UIKit
import SnapKit
import Then

class CustomAlertView: UIView {
    
    private let alertView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = Suite.bold.of(size: 16)
    }
    
    private let messageLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = Suite.regular.of(size: 14)
        $0.numberOfLines = 0
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .appDarkGray
        $0.layer.cornerRadius = 8
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .appYellow
        $0.layer.cornerRadius = 8
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        alertView.addSubview(buttonStackView)
    }
    
    private func setupConstraints() {
        alertView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(alertView).offset(40)
            $0.leading.equalTo(alertView).offset(20)
            $0.trailing.equalTo(alertView).offset(-20)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(alertView).offset(20)
            $0.trailing.equalTo(alertView).offset(-20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.leading.equalTo(alertView).offset(20)
            $0.trailing.equalTo(alertView).offset(-20)
            $0.height.equalTo(40)
        }
        
        alertView.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.bottom).offset(20)
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
        layoutIfNeeded()
    }
    
    func setMessage(_ message: String) {
        messageLabel.text = message
        layoutIfNeeded()
    }
    
    func setCancelAction(_ target: Any?, action: Selector) {
        cancelButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setConfirmAction(_ target: Any?, action: Selector) {
        confirmButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func showButtons(confirm: Bool, cancel: Bool) {
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if cancel {
            buttonStackView.addArrangedSubview(cancelButton)
        }
        
        if confirm {
            buttonStackView.addArrangedSubview(confirmButton)
        }
        
        buttonStackView.isHidden = buttonStackView.arrangedSubviews.isEmpty
        
        if buttonStackView.arrangedSubviews.isEmpty {
            buttonStackView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
        } else {
            buttonStackView.snp.updateConstraints {
                $0.height.equalTo(40)
            }
        }
        
        layoutIfNeeded()
    }
    
    func show(animated: Bool = true) {
        if animated {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
                self.transform = CGAffineTransform.identity
            }
        } else {
            self.alpha = 1
        }
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { _ in
                self.removeFromSuperview()
                completion?()
            }
        } else {
            removeFromSuperview()
            completion?()
        }
    }
}
