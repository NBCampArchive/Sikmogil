//
//  EditProfileViewController.swift
//  Sikmogil
//
//  Created by 박준영 on 6/5/24.
//  [프로필수정] 🖋️ 프로필 수정 🖋️

import UIKit
import SnapKit
import Then
import Combine
import Kingfisher
import NVActivityIndicatorView

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
        $0.image = UIImage(named: "profile")
        $0.layer.cornerRadius = 75
        $0.layer.masksToBounds = true
        $0.backgroundColor = .gray
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
//        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
//        profileImageView.layer.masksToBounds = true
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
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 8
    }
    
    let loadingIndicator = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .appGreen, padding: 0)
    
    // MARK: - viewDidLoad
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
        
        navigationController?.navigationBar.isHidden = false
        
        // 프로필 이미지 초기화
        if let profileImageURL = viewModel?.picture {
            loadImage(from: profileImageURL)
        } else {
            profileImageView.image = UIImage(named: "profile")
        }
        
        nickname.addTarget(self, action: #selector(nicknameDidChange(_:)), for: .editingChanged)
        height.addTarget(self, action: #selector(heightDidChange(_:)), for: .editingChanged)
        weight.addTarget(self, action: #selector(weightDidChange(_:)), for: .editingChanged)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchUserProfile()
//        setTabBar(hidden: true, animated: true)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        setTabBar(hidden: false, animated: true)
//    }
    
    @objc private func nicknameDidChange(_ textField: UITextField) {
        viewModel?.nickname = textField.text ?? ""
    }
    
    @objc private func heightDidChange(_ textField: UITextField) {
        viewModel?.height = textField.text ?? ""
    }
    
    @objc private func weightDidChange(_ textField: UITextField) {
        viewModel?.weight = textField.text ?? ""
    }
    
    // MARK: - binding
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
    
    // profileImageView에 뿌려주는 부분
    private func loadImage(from urlString: String?) {
        guard let urlString = urlString else {
            return
        }
        profileImageView.kf.setImage(with: URL(string: urlString))
    }
    
    // 데이터를 저장하는 부분
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
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류 ❗️", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - setupViews
    private func setupViews() {
        view.addSubviews(scrollView, saveButton, loadingIndicator)
        scrollView.addSubview(contentView)
        
        [profileImageView, profileLabel, profileSubLabel, nicknameView, heightView, weightView/*, saveButton*/].forEach {
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
    }
    
    @objc func profileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 데이터를 저장하는 부분 (프로필 저장)
    @objc func saveButtonTapped() {
        print("tap save button")
        saveProfile()
    }
}
