//
//  ExerciseViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/3/24.
//

import UIKit
import Combine
import SnapKit
import Then

class ExerciseViewController: UIViewController {
    
    // MARK: - Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let descriptionLabel = UILabel().then {
        $0.text = "오늘의 활동을 기록해보세요!"
        $0.font = Suite.semiBold.of(size: 14)
        $0.textColor = .appDarkGray
    }
    
    private let progressView = UIView().then {
        $0.backgroundColor = .clear
    }

    private let customCircularProgressBar = CustomCircularProgressBar().then {
        $0.backgroundColor = .clear
        $0.progressColor = .appGreen
        $0.trackColor = .appLightGray
    }
    
    private let exerciseProgressBarIcon = UIImageView().then {
        $0.image = UIImage.exerciseIconFill
    }

    private let progressTimeLabel = UILabel().then {
        $0.text = "활동시간 00분"
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.font = Suite.semiBold.of(size: 16)
        $0.textColor = .appDeepDarkGray
    }
    
    private let progressKcalLabel = UILabel().then {
        $0.text = "소모칼로리 0kcal"
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.font = Suite.semiBold.of(size: 16)
        $0.textColor = .appDeepDarkGray
    }

    private let historyLabel = UILabel().then {
        $0.text = "운동 기록"
        $0.font = Suite.bold.of(size: 22)
        $0.textColor = .appBlack
    }

    private let albumButton = UIButton().then {
        $0.setTitle("앨범", for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 16)
        $0.tintColor = .white
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
        // 앨범 버튼 히든 처리
//        $0.isHidden = true
    }

    private let startExerciseButton = UIButton().then {
        $0.setTitle("운동하기", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 18)
        $0.tintColor = .white
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
        // 운동하기 버튼 히든 처리
        $0.isHidden = true
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "오늘의 운동 기록이 없어요!"
        $0.textAlignment = .center
        $0.font = Suite.semiBold.of(size: 16)
        $0.textColor = .appDeepDarkGray
    }

    private let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    // MARK: - Properties
    let day = DateHelper.shared.formatDateToYearMonthDay(Date())
    private var viewModel = ExerciseViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchExerciseData()
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.$exercises
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.updateProgress()
                self?.updateTableViewHeight()
            }
            .store(in: &cancellables)
        
        viewModel.$totalWorkoutTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totalWorkoutTime in
                self?.updateProgress()
            }
            .store(in: &cancellables)
        
        viewModel.$totalCaloriesBurned
            .receive(on: DispatchQueue.main)
            .sink { [weak self] totalCaloriesBurned in
                self?.updateProgress()
            }
            .store(in: &cancellables)
        
        viewModel.$canEatCalorie
            .sink { [weak self] _ in
                self?.updateProgress()
            }
            .store(in: &cancellables)
    }
    
    private func updateProgress() {
        let totalTime = viewModel.totalWorkoutTime
        let totalCalories = viewModel.totalCaloriesBurned
        progressTimeLabel.text = "활동시간 \(totalTime)분"
        progressKcalLabel.text = "소모칼로리 \(totalCalories)kcal"
        
        if let canEatCalorie = viewModel.canEatCalorie {
            let recommendedCalories = CGFloat(canEatCalorie) * 0.5
            let progress = min(CGFloat(totalCalories) / recommendedCalories, 1.0)
            customCircularProgressBar.progress = progress
        }
    }
    
    private func updateTableViewHeight() {
        let tableViewHeight = viewModel.exercises.count * 88
        tableView.snp.updateConstraints {
            $0.height.equalTo(tableViewHeight)
        }
        
        if viewModel.exercises.count != 0 {
            self.emptyLabel.isHidden = true
        }
        // TODO: - willAppear 데이터 받아오는 부분
    }
    
    // MARK: - Fetch Data
    private func fetchExerciseData() {
        viewModel.getExerciseData(for: day) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.updateProgress()
                    self.viewModel.fetchExerciseList(for: self.day)
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("운동 데이터 불러오기 실패:", error)
            }
        }
    }
    
    // MARK: - Setup View
    private func setupViews() {
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExerciseHistoryCell.self, forCellReuseIdentifier: ExerciseHistoryCell.identifier)
        
        view.addSubviews(scrollView, startExerciseButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(descriptionLabel, progressView, historyLabel, albumButton, tableView, emptyLabel)
        progressView.addSubviews(customCircularProgressBar, exerciseProgressBarIcon, progressTimeLabel, progressKcalLabel)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        progressView.snp.makeConstraints {
            $0.width.height.equalTo(300)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
        }
        
        customCircularProgressBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        exerciseProgressBarIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview().inset(60)
        }
        
        progressTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(exerciseProgressBarIcon.snp.bottom).offset(18)
        }
        
        progressKcalLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(progressTimeLabel.snp.bottom).offset(6)
        }
        
        historyLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(16)
            $0.top.equalTo(progressView.snp.bottom)
        }
        
        albumButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView).inset(16)
            $0.width.equalTo(80)
            $0.height.equalTo(32)
            $0.centerY.equalTo(historyLabel)
        }
        
        emptyLabel.snp.makeConstraints{
            $0.top.equalTo(historyLabel.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(historyLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(tableView.contentSize.height)
        }
        
        // 테이블 뷰의 높이 설정
        tableView.layoutIfNeeded()
        let tableViewHeight = 88
        
        tableView.snp.updateConstraints {
            $0.height.equalTo(tableViewHeight)
        }
        
        // contentView의 높이 설정
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(tableView.snp.bottom).offset(80)
        }
        
        startExerciseButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).inset(26)
            $0.height.equalTo(48)
        }
    }
    
    // MARK: - Setup Button
    private func setupButtons() {
        startExerciseButton.addTarget(self, action: #selector(startExerciseButtonTapped), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(albumButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startExerciseButtonTapped() {
        let exerciseSelectionVC = ExerciseSelectionViewController()
        exerciseSelectionVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(exerciseSelectionVC, animated: true)
    }
    
    @objc private func stepsMenuButtonTapped() {
        let stepsVC = StepsViewController()
        navigationController?.pushViewController(stepsVC, animated: true)
    }
    
    @objc private func albumButtonTapped() {
        let albumVC = ExerciseAlbumViewController()
        albumVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(albumVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ExerciseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exercises.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reversedIndex = viewModel.exercises.count - 1 - indexPath.row
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseHistoryCell.identifier, for: indexPath) as? ExerciseHistoryCell else {
            return UITableViewCell()
        }
        
        let exercise = viewModel.exercises[reversedIndex]
        cell.configure(exercise: exercise)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ExerciseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            let alertController = UIAlertController(title: "운동 삭제", message: "이 운동을 삭제하시겠습니까?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                completion(false)
            }
            let confirmAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                let reversedIndex = self.viewModel.exercises.count - 1 - indexPath.row
                let exercise = self.viewModel.exercises[reversedIndex]
                let listId = exercise.workoutListId
                
                self.viewModel.deleteExerciseListData(for: self.day, exerciseListId: listId) { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.viewModel.exercises.remove(at: reversedIndex)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            self.fetchExerciseData()
                        }
                    case .failure(let error):
                        print("운동 리스트 삭제 실패: \(error)")
                    }
                }
                completion(true)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        // 배경색, 삭제 아이콘
        deleteAction.backgroundColor = UIColor.white
        let trashImage = UIImage(systemName: "trash")?.withTintColor(UIColor.darkGray, renderingMode: .alwaysOriginal)
        deleteAction.image = trashImage
        
        // 삭제 액션 추가
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
