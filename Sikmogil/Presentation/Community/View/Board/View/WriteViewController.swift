//
//  WriteViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/2/24.
//

import UIKit
import SnapKit
import Then
import MobileCoreServices

class WriteViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - Properties
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let titleTextField = UITextField().then {
        let placeholderText = "제목을 입력해 주세요."
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: Suite.bold.of(size: 24),
            .foregroundColor: UIColor.appDeepDarkGray
        ]
        $0.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
    }
    
    private let dietButton = UIButton(type: .system).then {
        $0.setTitle("다이어트", for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 14)
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.appBlack.cgColor
        $0.setTitleColor(.appBlack, for: .normal)
        $0.backgroundColor = .white
        $0.tag = 0
    }
    
    private let workoutButton = UIButton(type: .system).then {
        $0.setTitle("운동", for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 14)
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.setTitleColor(.appDarkGray, for: .normal)
        $0.backgroundColor = .white
        $0.tag = 1
    }
    
    private let freeButton = UIButton(type: .system).then {
        $0.setTitle("자유", for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 14)
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.appDarkGray.cgColor
        $0.setTitleColor(.appDarkGray, for: .normal)
        $0.backgroundColor = .white
        $0.tag = 2
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    private let contentTextView = UITextView().then {
        $0.text = "내용을 입력해 주세요.\n부적절한 글은 차단 조치 될 수 있습니다."
        $0.textColor = .appDarkGray
        $0.font = Suite.medium.of(size: 16)
    }
    
    private let imageLabel = UILabel().then {
        $0.text = "사진 등록"
        $0.font = Suite.bold.of(size: 16)
        $0.textColor = .appBlack
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let submitButton = UIButton(type: .system).then {
        $0.setTitle("글 올리기", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.tintColor = .white
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
    
    private let dividerView1 = UIView().then {
        $0.backgroundColor = .appDarkGray
    }
    
    private let dividerView2 = UIView().then {
        $0.backgroundColor = .appDarkGray
    }
    
    private let addPhotoButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        
        $0.setImage(UIImage(systemName: "plus", withConfiguration: config)?.withTintColor(.appDarkGray, renderingMode: .alwaysOriginal), for: .normal)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.backgroundColor = .appLightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupButtons()
        
        navigationController?.navigationBar.isHidden = false
        contentTextView.delegate = self
        scrollView.delaysContentTouches = false
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(scrollView, submitButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleTextField, buttonStackView, contentTextView, imageLabel, collectionView, dividerView1, dividerView2, addPhotoButton)
        buttonStackView.addArrangedSubviews(dietButton, workoutButton, freeButton)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(submitButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(view.snp.height)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        dividerView1.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(dividerView1.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        dividerView2.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(dividerView2.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(imageLabel.snp.top).offset(-16)
        }
        
        imageLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(imageLabel.snp.bottom).offset(8)
            $0.leading.equalTo(addPhotoButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.top.equalTo(imageLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(100)
        }
        
        submitButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    private func setupButtons() {
        dietButton.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        workoutButton.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        freeButton.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            updateButtonSelection(selectedButton: dietButton)
        case 1:
            updateButtonSelection(selectedButton: workoutButton)
        case 2:
            updateButtonSelection(selectedButton: freeButton)
        default:
            break
        }
    }
    
    private func updateButtonSelection(selectedButton: UIButton) {
        [dietButton, workoutButton, freeButton].forEach { button in
            if button == selectedButton {
                button.layer.borderColor = UIColor.black.cgColor
                button.setTitleColor(.black, for: .normal)
            } else {
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.setTitleColor(.gray, for: .normal)
            }
        }
    }
    
    @objc private func addPhotoButtonTapped() {
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

extension WriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 // 임시 데이터
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        // 임시 이미지
        let imageURLs = [
            "https://d35sohbc9et6k7.cloudfront.net/profile/8ddbb613-ef4d-430c-a313-c2f87a84300f_image0.jpeg",
            "https://d35sohbc9et6k7.cloudfront.net/profile/8ddbb613-ef4d-430c-a313-c2f87a84300f_image0.jpeg",
            "https://d35sohbc9et6k7.cloudfront.net/profile/8ddbb613-ef4d-430c-a313-c2f87a84300f_image0.jpeg"
        ]
        cell.imageView.kf.setImage(with: URL(string: imageURLs[indexPath.item]))
        return cell
    }
}

extension WriteViewController: UICollectionViewDelegate {
    
}

// MARK: - UITextViewDelegate
extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .appDarkGray {
            textView.text = nil
            textView.textColor = .appBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해 주세요.\n부적절한 글은 차단 조치 될 수 있습니다."
            textView.textColor = .appDarkGray
        }
    }
}

extension WriteViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}

class ImageCell: UICollectionViewCell {
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
