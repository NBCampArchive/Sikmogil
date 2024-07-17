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

class ExercisePhotoViewController: UIViewController {
    
    private var imageURL: URL
    private var titleText: String
    private var imageId: Int
    private let viewModel: ExerciseAlbumViewModel
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var deleteButton = UIButton().then {
        let trashImage = UIImage(systemName: "trash")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        $0.setImage(trashImage, for: .normal)
        $0.setTitle("  삭제", for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 16)
    }
    
    init(
        imageURL: URL,
        title: String,
        imageId: Int,
        viewModel: ExerciseAlbumViewModel
    ) {
        self.imageURL = imageURL
        self.titleText = title
        self.imageId = imageId
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
        let alertController = UIAlertController(title: nil, message: "정말 삭제하시겠어요?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.deletePhoto()
            self?.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func deletePhoto() {
        viewModel.deleteExercisePictureData(
            date: titleText,
            workoutListId: imageId
        ) {_ in }
    }
}
