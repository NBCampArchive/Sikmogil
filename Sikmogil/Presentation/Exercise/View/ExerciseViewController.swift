//
//  ExerciseViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/3/24.
//

import UIKit
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

    let exerciseMenuButton = UIButton(type: .system).then {
        $0.setTitle("운동", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 28)
        $0.tintColor = .appBlack
    }

    let stepsMenuButton = UIButton(type: .system).then {
        $0.setTitle("걸음 수", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 28)
        $0.tintColor = .appDarkGray
    }

    private let progressView = UIView().then {
        $0.backgroundColor = .clear
    }

    private let customCircularProgressBar = CustomCircularProgressBar().then {
        $0.backgroundColor = .clear
        $0.progressColor = .appGreen
        $0.trackColor = .appLightGray
    }

    private let exerciseCircleView = UIView().then {
        $0.backgroundColor = .appGreen
        $0.layer.cornerRadius = 40
    }

    private let activeImage = UIImageView().then {
        $0.image = .active
        $0.contentMode = .scaleAspectFit
    }

    private let progressLabel = UILabel().then {
        $0.text = "활동시간 00분\n소모칼로리 0kcal"
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.font = Suite.semiBold.of(size: 18)
        $0.textColor = .appDarkGray
    }

    private let historyLabel = UILabel().then {
        $0.text = "운동 기록"
        $0.font = Suite.bold.of(size: 28)
        $0.textColor = .appBlack
    }

    private let albumButton = UIButton().then {
        $0.setTitle("앨범", for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 16)
        $0.tintColor = .white
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }

    private let startExerciseButton = UIButton().then {
        $0.setTitle("운동하기", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 20)
        $0.tintColor = .white
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }

    private let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
    }
    
    // MARK: - Setup View
    private func setupViews() {
        view.backgroundColor = .white
        customCircularProgressBar.progress = 0.6
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExerciseHistoryCell.self, forCellReuseIdentifier: ExerciseHistoryCell.identifier)
        
        view.addSubviews(scrollView, startExerciseButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(descriptionLabel, progressView, historyLabel, albumButton, tableView)
        progressView.addSubviews(customCircularProgressBar, exerciseCircleView, progressLabel)
        exerciseCircleView.addSubview(activeImage)
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
        
        exerciseCircleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview().inset(60)
        }
        
        activeImage.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(30)
        }
        
        progressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(exerciseCircleView.snp.bottom).offset(16)
        }
        
        historyLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(16)
            $0.top.equalTo(progressView.snp.bottom)
        }
        
        albumButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView).inset(16)
            $0.width.equalTo(90)
            $0.height.equalTo(30)
            $0.centerY.equalTo(historyLabel)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(historyLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(tableView.contentSize.height)
        }
        
        // 테이블 뷰의 높이 설정
        tableView.layoutIfNeeded()
        let tableViewHeight = 10 * 88
        // TODO: 데이터 개수 넣어서 높이 설정하기
        
        tableView.snp.updateConstraints {
            $0.height.equalTo(tableViewHeight)
        }
        
        // contentView의 높이 설정
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(tableView.snp.bottom).offset(100)
        }
        
        startExerciseButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).inset(26)
            $0.height.equalTo(60)
        }
    }
    
    // MARK: - Setup Button
    private func setupButtons() {
        startExerciseButton.addTarget(self, action: #selector(startExerciseButtonTapped), for: .touchUpInside)
        stepsMenuButton.addTarget(self, action: #selector(stepsMenuButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startExerciseButtonTapped() {
        let exerciseSelectionVC = ExerciseSelectionViewController()
        navigationController?.pushViewController(exerciseSelectionVC, animated: true)
    }
    
    @objc private func stepsMenuButtonTapped() {
        let stepsVC = StepsViewController()
        navigationController?.pushViewController(stepsVC, animated: true)
    }
}

// MARK: - UITableView
extension ExerciseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseHistoryCell.identifier, for: indexPath) as? ExerciseHistoryCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: UIImage.exercise, exercise: "운동 종목 \(indexPath.row + 1)", calories: "\(100 * (indexPath.row + 1)) kcal")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
