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
    
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }

        imageView.kf.setImage(with: imageURL, placeholder: nil, options: [
            .transition(.fade(0.5))
        ])
    }
}
