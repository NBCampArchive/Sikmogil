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
    private var imageView = UIImageView()
    private var imageURL: URL
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
    }
    
    private func setupView() {
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        loadImageAndAdjustLayout()
    }
    
    private func loadImageAndAdjustLayout() {
        imageView.kf.setImage(with: imageURL, placeholder: nil, options: [
            .transition(.fade(0.5))
        ]) { result in
            switch result {
            case .success(let value):
                self.adjustImageViewLayout(for: value.image)
            case .failure(let error):
                print("이미지 로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func adjustImageViewLayout(for image: UIImage) {
        let imageViewAspectRatio = image.size.width / image.size.height
        let screenAspectRatio = view.frame.width / view.frame.height
        
        if imageViewAspectRatio > screenAspectRatio {
            // 가로가 더 긴 경우
            imageView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(imageView.snp.width).multipliedBy(1.0 / imageViewAspectRatio)
                $0.centerY.equalToSuperview()
            }
        } else {
            // 세로가 더 긴 경우
            imageView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.width.equalTo(imageView.snp.height).multipliedBy(imageViewAspectRatio)
                $0.centerX.equalToSuperview()
            }
        }
    }
}
