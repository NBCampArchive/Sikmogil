//
//  DietAlbumViewController.swift
//  Sikmogil
//
//  Created by 희라 on 6/5/24.
//  [View] **설명** 식단 앨범

import UIKit
import SnapKit
import Then
import MobileCoreServices

class DietAlbumViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - UI components
    let albumTitleLabel = UILabel().then {
        $0.text = "식단 앨범"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 28)
        $0.textAlignment = .left
    }
    let albumTitleSubLabel = UILabel().then {
        $0.text = "먹은 음식을 사진으로 기록해보세요!"
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 14)
        $0.textAlignment = .left
    }
    let albumAddPhotoButton = UIButton().then {
        $0.setTitle("사진 기록하기", for: .normal)
        $0.backgroundColor = .appBlack
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(albumAddPhotoButtonTapped), for: .touchUpInside)
    }
    let albumCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    var viewModel: DietAlbumViewModel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        viewModel = DietAlbumViewModel()
        
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        
        albumCollectionView.register(DietAlbumCollectionViewCell.self, forCellWithReuseIdentifier: DietAlbumCollectionViewCell.identifier)
        
        viewModel.loadImages(0) { [weak self] in
            DispatchQueue.main.async {
                self?.albumCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubviews(albumTitleLabel, albumTitleSubLabel, albumCollectionView, albumAddPhotoButton)
    }

    private func setupConstraints() {
        albumTitleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
        }
        albumTitleSubLabel.snp.makeConstraints{
            $0.top.equalTo(albumTitleLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalToSuperview()
        }
        albumCollectionView.snp.makeConstraints{
            $0.top.equalTo(albumTitleSubLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        albumAddPhotoButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
    }
    
    // MARK: - Actions
    // 카메라/앨범 중 선택
    @objc func albumAddPhotoButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "사진 찍기", style: .default) { _ in
            self.presentImagePicker(sourceType: .camera)
        }
        
        let photoLibraryAction = UIAlertAction(title: "앨범에서 가져오기", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeImage as String] // JPG 또는 PNG 이미지만 선택 가능하도록 설정
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: nil, message: "JPG 또는 PNG 이미지만 선택 가능합니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DietAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.savedDietImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DietAlbumCollectionViewCell.identifier, for: indexPath) as! DietAlbumCollectionViewCell
        let dietImage = viewModel.savedDietImages[indexPath.item]
        cell.imageView.image = UIImage(data: dietImage.foodPicture)
        cell.dataLabel.text = "\(dietImage.dietDate)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingSpace = 8 * (itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        confirmDeleteImage(at: indexPath)
    }
    
    func confirmDeleteImage(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "사진 삭제", message: "이 사진을 삭제하시겠습니까?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            let index = indexPath.item
            self.viewModel.deleteImage(at: index) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.albumCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("Failed to delete image: \(error)")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension DietAlbumViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.saveImage(image) { [weak self] result in
                switch result {
                case .success:
                    self?.viewModel.loadImages(0) {
                        DispatchQueue.main.async {
                            self?.albumCollectionView.reloadData()
                        }
                    }
                case .failure(let error):
                    print("Failed to save image: \(error)")
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
