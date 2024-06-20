//
//  EditProfileViewController.swift
//  Sikmogil
//
//  Created by Developer_P on 6/5/24.
//  [프로필수정] 🖋️ 프로필 수정 🖋️

import UIKit
import SnapKit
import Then
import Combine

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var viewModel: ProfileViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    private var selectedImage: UIImage? // 임시로 선택된 이미지를 저장할 변수
    
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
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let profileLabel = UILabel().then {
        $0.text = "프로필 수정"
        $0.font = Suite.bold.of(size: 24)
        $0.textColor = .appBlack
    }
    
    let profileSubLabel = UILabel().then {
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
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appBlack
        $0.tag = 1
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
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appBlack
        $0.tag = 2
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
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appBlack
        $0.tag = 3
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
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
        bindViewModel()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        // 데이터를 받아오는 부분
        viewModel?.fetchUserProfile()
        
        nickname.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        height.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        weight.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchUserProfile()
    }
    
    // 텍스트 필드 및 프로필 이미지 변경 액션
    @objc private func textFieldDidChange(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            viewModel?.nickname = textField.text ?? ""
        case 2:
            viewModel?.height = textField.text ?? ""
        case 3:
            viewModel?.weight = textField.text ?? ""
        default:
            break
        }
    }
    
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
                self.loadImage(from: picture)
            }
            .store(in: &cancellables)
    }

    // URL로부터 이미지를 비동기적으로 로드하여 profileImageView에 뿌려주는 부분
    private func loadImage(from urlString: String) {
        guard !urlString.isEmpty, let url = URL(string: urlString) else {
            print("URL 문자열이 비어 있습니다.")
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(named: "profile")
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                print("이미지 로드 실패: \(error?.localizedDescription ?? "오류 설명 없음")")
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(named: "profile")
                }
                return
            }
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    // 데이터를 저장하는 부분 (이미지 업로드 및 URL 할당)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        profileImageView.image = selectedImage
        
        // 선택된 이미지를 임시 저장
        self.selectedImage = selectedImage
    }
    
    private func saveProfile() {
        guard let viewModel = viewModel else { return }
        
        // 업로드할 이미지가 있는지 확인하고 업로드
        if let selectedImage = self.selectedImage {
            viewModel.uploadImage(selectedImage) { [weak self] (result: Result<URL, Error>) in
                switch result {
                case .success(let url):
                    DispatchQueue.main.async {
                        viewModel.picture = url.absoluteString
                        // URL이 성공적으로 설정된 후 프로필 저장
                        self?.finalizeProfileSave()
                    }
                case .failure(let error):
                    print("이미지 업로드 실패: \(error)")
                    self?.showErrorAlert(message: "이미지 업로드 실패. 다시 시도해주세요.")
                }
            }
        } else {
            // 업로드할 이미지가 없으면 바로 프로필 저장
            finalizeProfileSave()
        }
    }
    
    private func finalizeProfileSave() {
        viewModel?.saveProfileData()
        viewModel?.submitProfile { [weak self] result in
            DispatchQueue.main.async {
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
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [profileImageView, profileLabel, profileSubLabel, nicknameView, heightView, weightView, saveButton].forEach {
            contentView.addSubview($0)
        }
        nicknameView.addSubview(nicknameLabel)
        nicknameView.addSubview(nickname)
        
        heightView.addSubview(heightLabel)
        heightView.addSubview(height)
        heightView.addSubview(heightUnitLabel)
        
        weightView.addSubview(weightLabel)
        weightView.addSubview(weight)
        weightView.addSubview(weightUnitLabel)
    }
    
    private func setupConstraints() {
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
            $0.width.equalTo(30)
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
            $0.trailing.equalTo(weightUnitLabel.snp.leading).offset(-10)
        }
        
        weightUnitLabel.snp.makeConstraints {
            $0.centerY.equalTo(weight)
            $0.trailing.equalTo(weightView.snp.trailing).offset(-10)
            $0.width.equalTo(30)
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
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func profileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 데이터를 저장하는 부분 (프로필 저장)
    @objc func saveButtonTapped() {
        saveProfile()
    }
}
