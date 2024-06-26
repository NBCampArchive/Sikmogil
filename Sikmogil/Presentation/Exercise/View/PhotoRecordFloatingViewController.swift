//
//  PhotoRecordFloatingViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/26/24.
//

import UIKit

class PhotoRecordFloatingViewController: UIViewController {

    private let label = UILabel().then {
        $0.text = "사진을 추가하시겠습니까?"
        $0.font = Suite.semiBold.of(size: 24)
    }
    
    private let addPhotoButton =  UIButton().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 16
        $0.layer.cornerRadius = 8
    }
    
    private let addPhotoIcon = UIImageView().then {
        $0.image = .photoplus
        $0.contentMode = .scaleAspectFit
    }
    
    private let imageView = UIImageView().then {
        $0.image = .exerciseIconFill // 임시 사진
        $0.backgroundColor = .appGreen
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 8
    }

    private let doneButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
    }
    
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(label, addPhotoButton, imageView, doneButton)
        addPhotoButton.addSubview(addPhotoIcon)
        
        doneButton.addTarget(self, action: #selector(tapDoneButton), for: .touchUpInside)
        print(#function)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(100)
        }
        
        addPhotoIcon.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerY.equalTo(addPhotoButton)
            $0.leading.equalTo(addPhotoButton.snp.trailing).offset(16)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(addPhotoButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(60)
        }
    }
    
    @objc func tapDoneButton() {
       // 사진 등록 후 앨범으로 이동
        let albumVC = ExerciseAlbumViewController()
        navigationController?.pushViewController(albumVC, animated: true)
    }
}
