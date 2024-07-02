//
//  DietPhotoSelectViewController.swift
//  Sikmogil
//
//  Created by 희라 on 7/2/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class DietPhotoSelectViewController: UIViewController {
    
    private var imageData: Data
    private var titleText: String
    private var imageIndex: Int
    private var viewModel: DietAlbumViewModel
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var deleteButton = UIButton().then {
        let trashImage = UIImage(systemName: "trash")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        $0.setImage(trashImage, for: .normal)
        $0.setTitle("  삭제", for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 16)
        $0.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    init(imageData: Data, title: String, imageIndex: Int, viewModel: DietAlbumViewModel) {
        self.imageData = imageData
        self.titleText = title
        self.imageIndex = imageIndex
        self.viewModel = viewModel
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
        navigationController?.navigationBar.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = textAttributes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .appBlack
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appBlack]
    }
    
    private func setupViews() {
        view.addSubviews(imageView, deleteButton)
        
        loadImage()
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func loadImage() {
        if let image = UIImage(data: imageData) {
            imageView.image = image
            print("이미지 로드 성공")
        } else {
            print("이미지 로드 실패: 데이터가 유효하지 않습니다")
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
        let alertController = UIAlertController(title: "사진 삭제", message: "정말 삭제하시겠어요?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.deletePhoto()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func deletePhoto() {
        viewModel.deleteImage(at: imageIndex) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    //화면이동
                    self.navigationController?.popViewController(animated: true)
                    //부모뷰 컬렉션뷰 리로드데이터
                    if let albumVC = self.navigationController?.viewControllers.last as? DietAlbumViewController {
                        albumVC.albumCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                print("이미지 삭제 실패: \(error)")
            }
        }
    }
}

