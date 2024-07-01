//
//  PhotoSelectViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/30/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class PhotoSelectViewController: UIViewController {
    
    private var imageURL: URL
    private var titleText: String
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var deleteButton = UIButton().then {
        let trashImage = UIImage(systemName: "trash")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        $0.setImage(trashImage, for: .normal)
        $0.setTitle("  삭제", for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 16)
    }
    
    init(imageURL: URL, title: String) {
        self.imageURL = imageURL
        self.titleText = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = titleText
        
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 아이템 색상 변경
        navigationController?.navigationBar.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = textAttributes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 네비게이션 아이템 색상 복원
        navigationController?.navigationBar.tintColor = .appBlack
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appBlack]
    }
    
    private func setupViews() {
        view.addSubviews(imageView, deleteButton)
        
        loadImage()
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func loadImage() {
        imageView.kf.setImage(with: imageURL, placeholder: nil, options: [
            .transition(.fade(0.5))
        ]) { result in
            switch result {
            case .success(_):
                print("이미지 로드 성공")
            case .failure(let error):
                print("이미지 로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
            $0.leading.trailing.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
        }
    }
    
    @objc private func deleteButtonTapped() {
        // TODO: - 이미지 삭제 로직 구현
        print("삭제 버튼")
    }
}
