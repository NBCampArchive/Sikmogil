//
//  CustomImagePickerController.swift
//  Sikmogil
//
//  Created by Developer_P on 7/2/24.
//  [기본 이미지설정] 🌆 프로필 업데이트시 기본이미지로 돌아가는 버튼 🌆

import UIKit

class CustomImagePickerController: UIImagePickerController {

    var cancelButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        // "기본이미지" 버튼 추가
        addCancelButton()
    }

    private func addCancelButton() {
        // 버튼 설정
        cancelButton = UIButton(type: .system)
        cancelButton?.setTitle("기본이미지", for: .normal)
        cancelButton?.setTitleColor(.white, for: .normal)
        cancelButton?.backgroundColor = .appBlack
        cancelButton?.layer.cornerRadius = 16
        cancelButton?.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        guard let cancelButton = cancelButton else { return }

        // 버튼 위치 설정
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 150),
            cancelButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func cancelButtonTapped() {
        // 기본 이미지로 설정
        NotificationCenter.default.post(name: Notification.Name("CancelImageSelection"), object: nil)
        dismiss(animated: true, completion: nil)
    }
}
