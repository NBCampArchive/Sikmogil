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
    
    private let customSegmentedControl = CustomSegmentedControl(frame: .zero, buttonTitles: ["전체", "다이어트", "운동", "자유"])
    
    private let tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private var currentCategoryIndex: Int = 0 {
        didSet {
            fetchDataForCategory(index: currentCategoryIndex)
        }
    }
    
    private var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupTableView()
        fetchDataForCategory(index: 0)
    }
    
    private func setupViews() {
        view.addSubview(customSegmentedControl)
        view.addSubview(tableView)
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
    
    private func fetchDataForCategory(index: Int) {
        // 여기에 각 카테고리에 따른 데이터를 요청하고 tableView를 리로드하는 로직을 추가하세요.
        // 예시 데이터:
        switch index {
        case 0:
            data = ["전체 항목 1", "전체 항목 2", "전체 항목 3"]
        case 1:
            data = ["다이어트 항목 1", "다이어트 항목 2", "다이어트 항목 3"]
        case 2:
            data = ["운동 항목 1", "운동 항목 2", "운동 항목 3"]
        case 3:
            data = ["자유 항목 1", "자유 항목 2", "자유 항목 3"]
        default:
            data = []
        }
        tableView.reloadData()
    }
}

extension BoardMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
