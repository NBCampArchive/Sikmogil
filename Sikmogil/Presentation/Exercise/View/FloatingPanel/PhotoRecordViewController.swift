//
//  PhotoRecordFloatingViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/26/24.
//

import UIKit
import SnapKit
import Then
import MobileCoreServices

class PhotoRecordViewController: UIViewController, UINavigationControllerDelegate {

    var selectedImage: UIImage?
    var viewModel: ExerciseSelectionViewModel?
    
    private let label = UILabel().then {
        $0.text = "사진을 추가하시겠습니까?"
        $0.font = Suite.semiBold.of(size: 20)
    }
    
    private let addPhotoButton =  UIButton().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 8
    }
    
    private let addPhotoIcon = UIImageView().then {
        $0.image = .addPhoto
        $0.contentMode = .scaleAspectFit
    }
    
    private var photoView = UIView().then {
        $0.layer.cornerRadius = 8
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private var removeButton =  UIButton().then {
        $0.setImage(.removePhoto, for: .normal)
    }

    private let doneButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(label, addPhotoButton, photoView, doneButton)
        addPhotoButton.addSubview(addPhotoIcon)
        photoView.addSubviews(imageView, removeButton)
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
        
        photoView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerY.equalTo(addPhotoButton)
            $0.leading.equalTo(addPhotoButton.snp.trailing).offset(16)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(addPhotoButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    private func setupButtons() {
        doneButton.addTarget(self, action: #selector(tapDoneButton), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(tapPhotoButton), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(tapRemoveButton), for: .touchUpInside)
        updateButtonsState()
    }
    
    @objc private func tapDoneButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapRemoveButton() {
        imageView.image = nil
        viewModel?.selectedImageView = nil
        updateButtonsState()
    }

    private func updateButtonsState() {
        let isImageSelected = imageView.image != nil
        removeButton.isHidden = !isImageSelected
    }
    
    @objc func tapPhotoButton() {
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

// MARK: - UIImagePickerControllerDelegate
extension PhotoRecordViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imageView.image = image
            self.viewModel?.selectedImageView = image
            updateButtonsState()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
