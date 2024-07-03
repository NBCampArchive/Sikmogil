//
//  ExerciseResultViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/4/24.
//

import UIKit
import Combine
import SnapKit
import Then
import FloatingPanel
import NVActivityIndicatorView
 
class ExerciseResultViewController: UIViewController, FloatingPanelControllerDelegate {
    
    // MARK: - Properties
    var viewModel: ExerciseSelectionViewModel?
    private var cancellables = Set<AnyCancellable>()
    var recodingPhotoPanel = FloatingPanelController()
    let loadingIndicator = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .appGreen, padding: 0)
    
    // MARK: - Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let cardView = UIView().then {
        $0.backgroundColor = .appLightGray
    }

    private let checkImage = UIImageView().then {
        $0.image = .check
        $0.contentMode = .scaleAspectFit
    }

    private let completionLabel = UILabel().then {
        $0.text = "운동을 끝마쳤습니다!"
        $0.font = Suite.semiBold.of(size: 20)
        $0.textColor = .appBlack
    }

    private let cardStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }

    private let progressView = UIView().then {
        $0.backgroundColor = .clear
    }

    private let circularProgressBar = AnimationProgressBar().then {
        $0.backgroundColor = .clear
        $0.progressColor = .appGreen
        $0.trackColor = .appLightGray
    }

    private let progressLabel = UILabel().then {
        $0.textColor = .appDeepDarkGray
        $0.font = Suite.semiBold.of(size: 20)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        let fullText = "예상 소모 칼로리는\n0kcal 예요"
        let font = Suite.semiBold.of(size: 20)
        let changeText = "0kcal"
        let color = UIColor.appGreen
        $0.setAttributedText(fullText: fullText, changeText: changeText, color: color, font: font)
    }

    private let resultView = UIView()

    private let exerciseImage = UIImageView().then {
        $0.image = .running
        $0.contentMode = .scaleAspectFit
    }

    private let exerciseLabel = UILabel().then {
        $0.text = "운동 이름"
        $0.font = Suite.semiBold.of(size: 18)
        $0.textColor = .appDeepDarkGray
    }

    private let verticalLine = UIView().then {
        $0.backgroundColor = .appDarkGray
    }

    private let timeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
    }

    private let kcalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
    }

    private let timeLabel = UILabel().then {
        $0.text = "Time"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appDarkGray
    }

    private let kcalLabel = UILabel().then {
        $0.text = "kcal"
        $0.font = Suite.regular.of(size: 16)
        $0.textColor = .appDarkGray
    }

    private let timeValueLabel = UILabel().then {
        $0.text = "0h.00min"
        $0.font = Suite.medium.of(size: 18)
        $0.textColor = .appBlack
    }

    private let kcalValueLabel = UILabel().then {
        $0.text = "0Kcal"
        $0.font = Suite.medium.of(size: 18)
        $0.textColor = .appBlack
    }

    // 사진 추가 버튼 히든 처리
    private let photoButton = UIButton().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.appBlack.cgColor
//        $0.isHidden = true
    }
    
    private let photoIcon = UIImageView().then {
        $0.image = .photoIcon
        $0.contentMode = .scaleAspectFit
//        $0.isHidden = true
    }
    
    private let addButton = UIButton().then {
        $0.setTitle("추가하기", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.tintColor = .white
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
  
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
        bindViewModel()
        setupFloatingPanel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startProgressBarAnimation()
    }
    
    private func startProgressBarAnimation() {
        circularProgressBar.animateProgress(to: 1.0, duration: 3.0)
    }
    
    // MARK: - Setup Binding
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$expectedCalories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] calories in
                self?.updateProgressLabel(calories: calories)
                self?.kcalValueLabel.text = "\(calories)kcal"
            }
            .store(in: &cancellables)
        
        viewModel.$selectedTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.timeValueLabel.text = time
            }
            .store(in: &cancellables)
        
        viewModel.$selectedExercise
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exercise in
                self?.exerciseLabel.text = exercise
                self?.updateExerciseImage(exercise: exercise ?? "기타")
            }
            .store(in: &cancellables)
    }
    
    private func updateProgressLabel(calories: Int) {
        let fullText = "예상 소모 칼로리는\n\(calories)kcal 예요"
        let changeText = "\(calories)kcal"
        let font = Suite.semiBold.of(size: 20)
        let color = UIColor.appGreen
        progressLabel.setAttributedText(fullText: fullText, changeText: changeText, color: color, font: font)
    }
    
    private func updateExerciseImage(exercise: String) {
        guard let viewModel = viewModel else { return }
        let iconName = viewModel.iconName(for: exercise)
        exerciseImage.image = UIImage(named: iconName)
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(scrollView, photoButton, addButton, loadingIndicator)
        scrollView.addSubview(contentView)
        contentView.addSubviews(cardView, progressView, resultView)
        cardStackView.addArrangedSubviews(checkImage, completionLabel)
        cardView.addSubview(cardStackView)
        progressView.addSubviews(circularProgressBar, progressLabel)
        resultView.addSubviews(exerciseImage, exerciseLabel, verticalLine, timeStackView, kcalStackView)
        timeStackView.addArrangedSubviews(timeLabel, timeValueLabel)
        kcalStackView.addArrangedSubviews(kcalLabel, kcalValueLabel)
        photoButton.addSubview(photoIcon)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        cardView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.top.equalToSuperview().inset(16)
            $0.height.equalTo(64)
        }
        
        cardStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        checkImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        progressView.snp.makeConstraints {
            $0.width.height.equalTo(300)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cardView.snp.bottom).offset(50)
        }
        
        circularProgressBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        progressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        resultView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.top.equalTo(progressView.snp.bottom).offset(40)
        }
        
        exerciseImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(32)
        }
        
        exerciseLabel.snp.makeConstraints {
            $0.centerY.equalTo(exerciseImage)
            $0.leading.equalTo(exerciseImage.snp.trailing).offset(8)
        }
        
        verticalLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(76)
            $0.centerX.equalTo(exerciseImage)
            $0.top.equalTo(exerciseImage.snp.bottom).offset(20)
            $0.bottom.equalTo(resultView).inset(20)
        }
        
        timeStackView.snp.makeConstraints {
            $0.leading.equalTo(verticalLine).offset(20)
            $0.centerY.equalTo(verticalLine)
        }
        
        kcalStackView.snp.makeConstraints {
            $0.trailing.equalTo(resultView).inset(16)
            $0.centerY.equalTo(verticalLine)
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(resultView.snp.bottom).offset(60)
        }
        
        photoButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(48)
            $0.width.equalTo(52)
            $0.centerY.equalTo(addButton)
        }
        
        photoIcon.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        
        addButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(photoButton.snp.trailing).offset(16)
            // 버튼 히든 제약조건
//            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(48)
        }
    }
    
    // MARK: - Setup Buttons
    private func setupButtons() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
    }
    
    @objc private func photoButtonTapped() {
        self.present(recodingPhotoPanel, animated: true)
    }

    @objc private func addButtonTapped() {
        let alert = UIAlertController(title: nil, message: "운동을 추가하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.performAddOperation()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func performAddOperation() {
        guard let viewModel = viewModel else { return }
        
        let exerciseData = viewModel.saveExerciseData()
        
        // 로딩 인디케이터 시작
        loadingIndicator.startAnimating()
        
        // 운동 리스트에 이미지가 있는 경우
        if let exerciseImage = viewModel.selectedImageView {
            uploadExerciseImageAndData(exerciseImage: exerciseImage, exerciseData: exerciseData)
        } else {
            // 운동 리스트에 이미지가 없는 경우 바로 서버에 추가
            addExerciseListData(exerciseData: exerciseData)
        }
    }
    
    private func uploadExerciseImageAndData(exerciseImage: UIImage, exerciseData: ExerciseListModel) {
        guard let viewModel = viewModel else { return }
        
        viewModel.uploadExerciseImage(image: exerciseImage, directory: "exercise_images") { [weak self] result in
            switch result {
            case .success(let imageURL):
                // 이미지 업로드 후, 운동 리스트 데이터에 이미지 URL 설정
                var updatedExerciseData = exerciseData
                updatedExerciseData.workoutPicture = imageURL
                
                // 운동 리스트 데이터 서버에 추가
                self?.addExerciseListData(exerciseData: updatedExerciseData)
                
            case .failure(let error):
                print("이미지 업로드 실패", error)
                self?.showErrorAlert(message: "이미지 업로드 실패. 다시 시도해주세요.")
            }
        }
    }
    
    private func addExerciseListData(exerciseData: ExerciseListModel) {
        guard let viewModel = viewModel else { return }
        viewModel.addExerciseListData(exerciseList: exerciseData) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                switch result {
                case .success:
                    print("운동 리스트 추가 성공")
                    self?.navigationController?.popToRootViewController(animated: true)
                case .failure(let error):
                    print("운동 리스트 추가 실패", error)
                    self?.showErrorAlert(message: "운동 리스트 추가 실패. 다시 시도해주세요.")
                    
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류 ❗️", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupFloatingPanel() {
        
        recodingPhotoPanel = FloatingPanelController()
        
        let contentVC = PhotoRecordFloatingViewController()
        contentVC.viewModel = self.viewModel

        recodingPhotoPanel.set(contentViewController: contentVC)
        recodingPhotoPanel.layout = CustomFloatingPanelLayout()
        recodingPhotoPanel.isRemovalInteractionEnabled = true
    
        recodingPhotoPanel.changePanelStyle()
        recodingPhotoPanel.delegate = self
    }
}
