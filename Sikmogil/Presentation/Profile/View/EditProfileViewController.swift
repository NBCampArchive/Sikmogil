//
//  EditProfileViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/5/24.
//

import UIKit
import SnapKit
import Then
import Combine

class EditProfileViewController: UIViewController {
    
    var userProfile: UserProfile?
    var onProfileUpdate: ((UserProfile) -> Void)?
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = ProfileViewModel()
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "default_profile")
        $0.layer.cornerRadius = 75
        $0.layer.masksToBounds = true
        $0.backgroundColor = .gray
        $0.isUserInteractionEnabled = true
    }
    
    let profileLabel = UILabel().then {
        $0.text = "프로필 수정"
        $0.font = Suite.bold.of(size: 24)
        $0.textColor = .appBlack
    }
    
    let profileSubLabel = UILabel().then{
        $0.text = "프로필을 새롭게 수정해보세요."
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    let nicknameView = UIView().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 12
    }
    
    let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    let nickname = UITextField().then {
        $0.text = "우주최강고양이"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appBlack
    }
    
    let heightView = UIView().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 12
    }
    
    let heightLabel = UILabel().then {
        $0.text = "키"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    let height = UITextField().then {
        $0.text = "000"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appBlack
    }
    let heightUnitLabel = UILabel().then {
        $0.text = "cm"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appDarkGray
    }
    
    let weightView = UIView().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 12
    }
    
    let weightLabel = UILabel().then {
        $0.text = "몸무게"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    let weight = UITextField().then {
        $0.text = "0.0"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appBlack
    }
    
    let weightUnitLabel = UILabel().then {
        $0.text = "Kg"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appDarkGray
    }
    
    let saveButton = UIButton(type: .system).then {
        $0.setTitle("저장하기", for: .normal)
        $0.backgroundColor = .appBlack
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        bindViewModel()
        
        if let profile = userProfile {
            nickname.text = profile.nickname
            height.text = profile.height
            weight.text = profile.weight
        }
    }
    
    private func bindViewModel() {
        // Initial values
        viewModel.nickname = nickname.text ?? ""
        viewModel.height = height.text ?? ""
        viewModel.weight = weight.text ?? ""
        
        // Bind nickname
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: nickname)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.nickname, on: viewModel)
            .store(in: &cancellables)
        
        // Bind height
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: height)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.height, on: viewModel)
            .store(in: &cancellables)
        
        // Bind weight
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: weight)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.weight, on: viewModel)
            .store(in: &cancellables)
        
        // Observe changes and update UI
        viewModel.$nickname
            .receive(on: RunLoop.main)
            .sink { [weak self] nickname in
                self?.nickname.text = nickname
            }
            .store(in: &cancellables)
        
        viewModel.$height
            .receive(on: RunLoop.main)
            .sink { [weak self] height in
                self?.height.text = height
            }
            .store(in: &cancellables)
        
        viewModel.$weight
            .receive(on: RunLoop.main)
            .sink { [weak self] weight in
                self?.weight.text = weight
            }
            .store(in: &cancellables)
    }
}

// MARK: - 설정 메서드
extension EditProfileViewController {
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(profileLabel)
        contentView.addSubview(profileSubLabel)
        contentView.addSubview(nicknameView)
        nicknameView.addSubview(nicknameLabel)
        nicknameView.addSubview(nickname)
        
        contentView.addSubview(heightView)
        heightView.addSubview(heightLabel)
        heightView.addSubview(height)
        heightView.addSubview(heightUnitLabel)
        
        contentView.addSubview(weightView)
        weightView.addSubview(weightLabel)
        weightView.addSubview(weight)
        weightView.addSubview(weightUnitLabel)
        
        view.addSubview(saveButton)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        profileLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        profileSubLabel.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(16)
        }
        
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(profileSubLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameView.snp.top).offset(10)
            $0.leading.equalTo(nicknameView.snp.leading).offset(10)
        }
        
        nickname.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nicknameView.snp.leading).offset(10)
            $0.trailing.equalTo(nicknameView.snp.trailing).offset(-10)
        }
        
        heightView.snp.makeConstraints {
            $0.top.equalTo(nicknameView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
        }
        
        heightLabel.snp.makeConstraints {
            $0.top.equalTo(heightView.snp.top).offset(10)
            $0.leading.equalTo(heightView.snp.leading).offset(10)
        }
        
        height.snp.makeConstraints {
            $0.top.equalTo(heightLabel.snp.bottom).offset(5)
            $0.leading.equalTo(heightView.snp.leading).offset(10)
            $0.trailing.equalTo(heightUnitLabel.snp.leading).offset(-10)
        }
        
        heightUnitLabel.snp.makeConstraints {
            $0.centerY.equalTo(height)
            $0.trailing.equalTo(heightView.snp.trailing).offset(-10)
        }
        
        weightView.snp.makeConstraints {
            $0.top.equalTo(heightView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
        }
        
        weightLabel.snp.makeConstraints {
            $0.top.equalTo(weightView.snp.top).offset(10)
            $0.leading.equalTo(weightView.snp.leading).offset(10)
        }
        
        weight.snp.makeConstraints {
            $0.top.equalTo(weightLabel.snp.bottom).offset(5)
            $0.leading.equalTo(weightView.snp.leading).offset(10)
            $0.trailing.equalTo(weightUnitLabel.snp.leading).offset(-50)
        }
        weightUnitLabel.snp.makeConstraints {
            $0.centerY.equalTo(weight)
            $0.trailing.equalTo(weightView.snp.trailing).offset(-10)
        }
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(weightView.snp.bottom).offset(100)
        }
        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).inset(20)
            $0.height.equalTo(60)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.masksToBounds = true
    }
}

// MARK: - 사용자 액션
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func profileImageTapped() { // 이미지 피커
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImageView.image = pickedImage
            profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
            profileImageView.layer.masksToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        // UI와 ViewModel 동기화
        viewModel.nickname = nickname.text ?? ""
        viewModel.height = height.text ?? ""
        viewModel.weight = weight.text ?? ""
        
        viewModel.saveProfileData()
        let updatedProfile = UserProfile(
            nickname: viewModel.nickname,
            height: viewModel.height,
            weight: viewModel.weight,
            gender: userProfile?.gender ?? "",
            targetWeight: userProfile?.targetWeight ?? "",
            targetDate: userProfile?.targetDate ?? "",
            canEatCalorie: userProfile?.canEatCalorie ?? 0,
            createdDate: userProfile?.createdDate ?? "",
            remindTime: userProfile?.remindTime ?? ""
        )
        
        viewModel.submitProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.onProfileUpdate?(updatedProfile)
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Error updating profile: \(error)")
                }
            }
        }
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: animationDuration) {
                self.scrollView.contentInset.bottom = keyboardHeight
                self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            
            UIView.animate(withDuration: animationDuration) {
                self.scrollView.contentInset.bottom = 0
                self.scrollView.verticalScrollIndicatorInsets.bottom = 0
            }
        }
    }
}
