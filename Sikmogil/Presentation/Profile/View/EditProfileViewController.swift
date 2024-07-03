//
//  EditProfileViewController.swift
//  Sikmogil
//
//  Created by 박준영 on 6/5/24.
//  [프로필수정] 🖋️ 프로필 수정 🖋️

import UIKit
import Combine
import Kingfisher
import NVActivityIndicatorView
import SnapKit
import Then

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var viewModel: ProfileViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    private var selectedImage: UIImage?
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 75
        $0.layer.masksToBounds = true
        $0.backgroundColor = .appSkyBlue
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = UIImage(named: "AppIcon")
    }
    
    private let profileLabel = UILabel().then {
        $0.text = "프로필 수정"
        $0.font = Suite.bold.of(size: 24)
        $0.textColor = .appBlack
    }
    
    private let profileSubLabel = UILabel().then {
        $0.text = "프로필을 새롭게 수정해보세요."
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    private let nicknameView = UIView().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 12
    }
    
    private let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    private let nickname = UITextField().then {
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appBlack
        $0.tag = 1
    }
    
    private let heightView = UIView().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 12
    }
    
    private let heightLabel = UILabel().then {
        $0.text = "키"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    private let height = UITextField().then {
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appBlack
        $0.keyboardType = .decimalPad
        $0.tag = 2
    }
    
    private let heightUnitLabel = UILabel().then {
        $0.text = "cm"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appDarkGray
    }
    
    private let weightView = UIView().then {
        $0.backgroundColor = .appLightGray
        $0.layer.cornerRadius = 12
    }
    
    private let weightLabel = UILabel().then {
        $0.text = "몸무게"
        $0.font = Suite.regular.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    private let weight = UITextField().then {
        $0.font = Suite.regular.of(size: 16)
        $0.keyboardType = .decimalPad
        $0.textColor = .appBlack
        $0.tag = 3
    }
    
    private let weightUnitLabel = UILabel().then {
        $0.text = "kg"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appDarkGray
    }
    
    private let saveButton = UIButton(type: .system).then {
        $0.setTitle("저장하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
        $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private let loadingIndicator = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .appGreen, padding: 0)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
        bindViewModel()
        setDelegates()
        configureTapGesture()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchUserProfile()
    }
    
    // MARK: - Actions
    @objc private func nicknameDidChange(_ textField: UITextField) {
        viewModel?.nickname = textField.text ?? ""
    }
    
    @objc private func heightDidChange(_ textField: UITextField) {
        viewModel?.height = textField.text ?? ""
    }
    
    @objc private func weightDidChange(_ textField: UITextField) {
        viewModel?.weight = textField.text ?? ""
    }
    
    @objc private func saveButtonTapped() {
        print("tap save button")
        saveProfile()
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$nickname
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nickname in
                self?.nickname.text = nickname
            }
            .store(in: &cancellables)
        
        viewModel.$height
            .receive(on: DispatchQueue.main)
            .sink { [weak self] height in
                self?.height.text = height
            }
            .store(in: &cancellables)
        
        viewModel.$weight
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weight in
                self?.weight.text = weight
            }
            .store(in: &cancellables)
        
        viewModel.$picture
            .receive(on: DispatchQueue.main)
            .sink { [weak self] picture in
                guard let self = self else { return }
                if picture.isEmpty {
                    self.profileImageView.image = UIImage(named: "AppIcon")
                } else {
                    self.loadImage(from: picture)
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadImage(from urlString: String?) {
        guard let urlString = urlString else { return }
        profileImageView.kf.setImage(with: URL(string: urlString))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        self.selectedImage = selectedImage
        profileImageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //    private func saveProfile() {
    //        guard let viewModel = viewModel else {
    //            print("viewmodel")
    //            return
    //        }
    //        loadingIndicator.startAnimating()
    //        if let selectedImage = self.selectedImage {
    //            viewModel.uploadImage(selectedImage) { [weak self] result in
    //                DispatchQueue.main.async {
    //                    switch result {
    //                    case .success(let url):
    //                        viewModel.picture = url
    //                        self?.finalizeProfileSave()
    //                    case .failure(let error):
    //                        print("이미지 업로드 실패: \(error)")
    //                        self?.showErrorAlert(message: "이미지 업로드 실패. 다시 시도해주세요.")
    //                        self?.loadingIndicator.stopAnimating()
    //                    }
    //                }
    //            }
    //        } else {
    //            finalizeProfileSave()
    //        }
    //    }
    
    private func saveProfile() {
        guard let viewModel = viewModel else { print("viewmodel")
            return }
        loadingIndicator.startAnimating()
        // 업로드할 이미지가 있는지 확인하고 업로드
        if let selectedImage = self.selectedImage {
            viewModel.uploadImage(selectedImage) { [weak self] result in
                switch result {
                case .success(let url):
                    DispatchQueue.main.async {
                        viewModel.picture = url
                        // URL이 성공적으로 설정된 후 프로필 저장
                        print("이미지 포함 저장")
                        self?.finalizeProfileSave()
                    }
                case .failure(let error):
                    print("이미지 업로드 실패: \(error)")
                    self?.showErrorAlert(message: "이미지 업로드 실패. 다시 시도해주세요.")
                }
            }
        } else {
            // 업로드할 이미지가 없으면 바로 프로필 저장
            print("이미지 없이 저장")
            finalizeProfileSave()
        }
    }
    
    //    private func finalizeProfileSave() {
    //        viewModel?.saveProfileData()
    //        if let isNicknameChanged = viewModel?.isNicknameChanged, isNicknameChanged {
    //            UserAPIManager.shared.checkNickname(nickname: viewModel?.nickname ?? "") { [weak self] result in
    //                guard let self = self else { return }
    //                switch result {
    //                case .success(let data):
    //                    if data.statusCode == 400 {
    //                        DispatchQueue.main.async {
    //                            self.showErrorAlert(message: "중복된 닉네임이에요!\n다른 닉네임으로 시도해 주세요")
    //                        }
    //                    } else {
    //                        self.submitProfile()
    //                    }
    //                case .failure(let error):
    //                    DispatchQueue.main.async {
    //                        self.showErrorAlert(message: "서버가 불안정 합니다.\n잠시 후 다시 시도해주세요.")
    //                        print("\(error.localizedDescription)")
    //                    }
    //                }
    //            }
    //        } else {
    //            submitProfile()
    //        }
    //    }
    
    private func finalizeProfileSave() {
        viewModel?.saveProfileData()
        if let isNicknameChanged = viewModel?.isNicknameChanged, isNicknameChanged {
            UserAPIManager.shared.checkNickname(nickname: viewModel?.nickname ?? "") { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    if data.statusCode == 400 {
                        DispatchQueue.main.async {
                            self.showErrorAlert(message: "중복된 닉네임이에요!\n다른 닉네임으로 시도해 주세요")
                        }
                    } else {
                        self.submitProfile()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showErrorAlert(message: "서버가 불안정 합니다.\n잠시 후 다시 시도해주세요.")
                        print("\(error.localizedDescription)")
                    }
                }
            }
        } else {
            submitProfile()
        }
    }
    
    private func submitProfile() {
        viewModel?.submitProfile { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                switch result {
                case .success:
                    print("프로필 업데이트 성공")
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("업데이트 에러: \(error)")
                    self?.showErrorAlert(message: "프로필 업데이트 실패. 다시 시도해주세요.")
                }
            }
        }
    }
    //
    //    private func submitProfile() {
    //        viewModel?.submitProfile { [weak self] result in
    //            DispatchQueue.main.async {
    //                self?.loadingIndicator.stopAnimating()
    //                switch result {
    //                case .success:
    //                    print("프로필 업데이트 성공")
    //                    self?.showCustomAlertAndNavigateBack()
    //                case .failure(let error):
    //                    print("업데이트 에러: \(error)")
    //                    self?.showErrorAlert(message: "프로필 업데이트 실패. 다시 시도해주세요.")
    //                }
    //            }
    //        }
    //    }
    
    //    private func showErrorAlert(message: String) {
    //        let customAlert = CustomAlertView().then {
    //            $0.setTitle("오류 ❗️")
    //            $0.setMessage(message)
    //            $0.setConfirmAction(self, action: #selector(dismissCustomAlert))
    //            $0.showButtons(confirm: true, cancel: false)
    //        }
    //
    //        customAlert.frame = self.view.bounds
    //        self.view.addSubview(customAlert)
    //
    //        customAlert.show(animated: true)
    //    }
    
    //    private func showCustomAlertAndNavigateBack(showConfirmButton: Bool = false, showCancelButton: Bool = false) {
    //        let customAlert = CustomAlertView().then {
    //            $0.setTitle("✨ 성공 ✨")
    //            $0.setMessage("프로필 수정이 완료되었습니다.")
    //            $0.setCancelAction(self, action: #selector(dismissCustomAlert))
    //            $0.setConfirmAction(self, action: #selector(dismissCustomAlert))
    //            $0.showButtons(confirm: showConfirmButton, cancel: showCancelButton)
    //        }
    //
    //        customAlert.frame = self.view.bounds
    //        self.view.addSubview(customAlert)
    //
    //        customAlert.show(animated: true)
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
    //            if !showConfirmButton && !showCancelButton {
    //                customAlert.removeFromSuperview()
    //                self?.navigationController?.popViewController(animated: true)
    //            }
    //        }
    //    }
    
    //    @objc private func dismissCustomAlert() {
    //        if let customAlert = view.subviews.first(where: { $0 is CustomAlertView }) {
    //            customAlert.removeFromSuperview()
    //            navigationController?.popViewController(animated: true)
    //        }
    //    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류 ❗️", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createVerticalStackView(with views: [UIView]) -> UIStackView {
        return UIStackView(arrangedSubviews: views).then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.spacing = 6
        }
    }

    // MARK: - Setup Views
    private func setupViews() {
        view.addSubviews(scrollView, saveButton, loadingIndicator)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(profileLabel)
        contentView.addSubview(profileSubLabel)
        contentView.addSubview(nicknameView)
        contentView.addSubview(heightView)
        contentView.addSubview(weightView)
        
        let nicknameStackView = createVerticalStackView(with: [nicknameLabel, nickname])
        nicknameView.addSubview(nicknameStackView)
        
        let heightStackView = createVerticalStackView(with: [heightLabel, height])
        heightView.addSubview(heightStackView)
        heightView.addSubview(heightUnitLabel)
        
        let weightStackView = createVerticalStackView(with: [weightLabel, weight])
        weightView.addSubview(weightStackView)
        weightView.addSubview(weightUnitLabel)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(saveButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        profileLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        profileSubLabel.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nicknameView.snp.makeConstraints {
            $0.top.equalTo(profileSubLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(80)
        }
        
        let nicknameStackView = nicknameView.subviews.first { $0 is UIStackView } as? UIStackView
        
        nicknameStackView?.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(nicknameView.snp.leading).offset(16)
            $0.trailing.equalTo(nicknameView.snp.trailing).offset(-10)
        }
        
        heightView.snp.makeConstraints {
            $0.top.equalTo(nicknameView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(80)
        }
        
        let heightStackView = heightView.subviews.first { $0 is UIStackView } as? UIStackView
        
        heightStackView?.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(heightView.snp.leading).offset(16)
            $0.trailing.equalTo(heightUnitLabel.snp.leading).offset(-10)
        }
        
        heightUnitLabel.snp.makeConstraints {
            $0.centerY.equalTo(height)
            $0.trailing.equalTo(heightView.snp.trailing).offset(-16)
            $0.width.equalTo(30)
        }
        
        weightView.snp.makeConstraints {
            $0.top.equalTo(heightView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(80)
        }
        
        let weightStackView = weightView.subviews.first { $0 is UIStackView } as? UIStackView
        
        weightStackView?.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(weightView.snp.leading).offset(16)
            $0.trailing.equalTo(weightUnitLabel.snp.leading).offset(-10)
        }
        
        weightUnitLabel.snp.makeConstraints {
            $0.centerY.equalTo(weight)
            $0.trailing.equalTo(weightView.snp.trailing).offset(-16)
            $0.width.equalTo(30)
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(weightView.snp.bottom).offset(100)
        }
        
        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
    }
    
    // MARK: - Configure Methods
    private func setDelegates() {
        nickname.delegate = self
        height.delegate = self
        weight.delegate = self
    }
    
    private func configureTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc private func profileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case nickname:
            let allowedCharacters = CharacterSet.alphanumerics
            let characterSet = CharacterSet(charactersIn: string)
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            return allowedCharacters.isSuperset(of: characterSet) && newLength <= 10
        case height, weight:
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // 소수점이 두 번 이상 입력되지 않도록 제한
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            let decimalCount = prospectiveText.components(separatedBy: decimalSeparator).count - 1
            if decimalCount > 1 {
                return false
            }
            
            // 자연수 3자리와 소수점 이하 1자리까지 허용
            let components = prospectiveText.components(separatedBy: decimalSeparator)
            if components.count == 1 {
                // 소수점이 없는 경우
                return components[0].count <= 3
            } else if components.count == 2 {
                // 소수점이 있는 경우
                let integerPart = components[0]
                let fractionPart = components[1]
                return integerPart.count <= 3 && fractionPart.count <= 1
            } else {
                return false
            }
        default:
            return true
        }
    }
}
