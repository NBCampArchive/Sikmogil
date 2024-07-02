//
//  BoardMainViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/18/24.
//

import UIKit
import SnapKit
import Then
import Combine

class BoardMainViewController: UIViewController {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = BoardListViewModel()
    
    private let customSegmentedControl = CustomSegmentedControl(frame: .zero, buttonTitles: ["전체", "다이어트", "운동", "자유"])
    
    private let tableView = UITableView().then {
        $0.register(BoardListCell.self, forCellReuseIdentifier: "BoardListCell")
        $0.separatorStyle = .none
    }
    
    private var currentCategoryIndex: Int = 0 {
        didSet {
            let category = categoryForIndex(currentCategoryIndex)
                        viewModel.fetchBoardList(category: category, reset: true)
        }
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    private let searchButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = .search
        config.background.backgroundColor = .appDarkGray
        config.cornerStyle = .capsule
        $0.configuration = config
    }
    
    private let writeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = .addPost
        config.imagePadding = 10
        config.background.backgroundColor = .appBlack
        config.cornerStyle = .capsule
        $0.configuration = config
    }
    
    private var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupTableView()
        bindViewModel()
        setupButton()
        viewModel.fetchBoardList(category: categoryForIndex(currentCategoryIndex), reset: true)
    }
    
    private func setupButton() {
        searchButton.addAction(UIAction { [weak self] _ in
            print("searchButtonTapped")
//            let searchVC = SearchViewController()
//            self?.navigationController?.pushViewController(searchVC, animated: true)
        }, for: .touchUpInside)
        
        writeButton.addAction(UIAction { [weak self] _ in
            print("writesearchButtonTapped")
//            let writeVC = WriteViewController()
//            self?.navigationController?.pushViewController(writeVC, animated: true)
        }, for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubview(customSegmentedControl)
        view.addSubview(tableView)
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubviews(searchButton, writeButton)
        customSegmentedControl.onSelectSegment = { [weak self] index in
            self?.segmentChanged(index: index)
        }
        
    }
    
    private func setupConstraints() {
        customSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(customSegmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.width.equalTo(50)
        }
        
        searchButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }

        writeButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        tableView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        tableView.addGestureRecognizer(swipeRight)
    }
    
    private func segmentChanged(index: Int) {
            currentCategoryIndex = index
            customSegmentedControl.setSelectedIndex(index: index)
            customSegmentedControl.updateButtonSelection()
            let category = categoryForIndex(index)
            viewModel.fetchBoardList(category: category, reset: true)
        }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
            if gesture.direction == .left {
                if currentCategoryIndex < customSegmentedControl.buttonTitles.count - 1 {
                    currentCategoryIndex += 1
                    segmentChanged(index: currentCategoryIndex)
                }
            } else if gesture.direction == .right {
                if currentCategoryIndex > 0 {
                    currentCategoryIndex -= 1
                    segmentChanged(index: currentCategoryIndex)
                }
            }
        }
    
    private func bindViewModel() {
        viewModel.$boardList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func categoryForIndex(_ index: Int) -> String {
        switch index {
        case 0: return "ALL"
        case 1: return "DIET"
        case 2: return "WORKOUT"
        case 3: return "FREE"
        default: return "ALL"
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류 ❗️", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension BoardMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.boardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BoardListCell", for: indexPath) as? BoardListCell else {
            return UITableViewCell()
        }
        
        let board = viewModel.boardList[indexPath.row]
        cell.configure(with: board)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 2 {
            viewModel.fetchNextPage(category: categoryForIndex(currentCategoryIndex))
        }
    }
}
