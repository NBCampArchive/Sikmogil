//
//  AddDietMenuViewController.swift
//  Sikmogil
//
//  Created by 희라 on 6/4/24.
//  [View] **설명** 식사추가 페이지

import UIKit
import FloatingPanel

class AddDietMenuViewController: UIViewController {
    
    // MARK: - UI components
    let TitleLabel = UILabel().then {
        $0.text = "식사 추가"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 28)
        $0.textAlignment = .left
    }
    let searchBar = UISearchBar().then {
        $0.placeholder = "무슨 음식을 드셨나요?"
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.layer.borderWidth = 1
        $0.searchTextField.layer.borderColor = UIColor.appBlack.cgColor
        $0.searchTextField.layer.cornerRadius = 10
    }
    let searchResultTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(AddDietMenuTableViewCell.self, forCellReuseIdentifier: "AddDietMenuTableViewCell")
        $0.separatorStyle = .none
    }
    
    // MARK: - Properties
    var foodItems: [FoodItem] = []  // 데이터 저장 배열
    var addMeal: ((FoodItem) -> Void)?
    
    var scrollIndex = 10
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        fetchFoodData(searchText: "")
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubviews(TitleLabel, searchBar, searchResultTableView)
    }
    
    private func fetchFoodData(searchText: String) {
        FoodDbAPIManager.shared.fetchFoodItems(searchQuery: searchText, index: scrollIndex) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    // API 응답 처리
                    self.handleSuccessResponse(items)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    // 에러 처리
                    self.handleError(error)
                }
            }
        }
    }
    
    private func setupConstraints() {
        TitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(16)
        }
        searchBar.snp.makeConstraints{
            $0.top.equalTo(TitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        searchResultTableView.snp.makeConstraints{
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AddDietMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddDietMenuTableViewCell", for: indexPath) as? AddDietMenuTableViewCell else {
            return UITableViewCell()
        }
        
        let foodItem = foodItems[indexPath.row]
        cell.foodItem = foodItem
        cell.cellTitleLabel.text = foodItem.foodNmKr
        cell.cellInfoLabel.text = foodItem.servingSize
        cell.cellKcalLabel.text = "\(foodItem.amtNum1) Kcal"
        
        cell.addMealAction = { [weak self] foodItem in
            self?.addMeal?(foodItem)
            self?.navigationController?.popViewController(animated: true)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 테이블뷰의 끝에 도달했을 때 추가 데이터 로드
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if contentOffsetY > contentHeight - frameHeight {
            // 스크롤이 끝에 도달했을 때 추가 데이터를 로드
            loadMoreData()
        }
    }
    
    private func loadMoreData() {
        // scrollIndex를 10 증가시킴
        if scrollIndex < 50 {
            scrollIndex += 10
        }
        
        // 현재 검색어에 맞는 추가 데이터를 로드
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }
        
        fetchFoodData(searchText: searchText)
    }
}

// MARK: - UISearchBarDelegate
extension AddDietMenuViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // 키보드가 나타나도록 설정
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 버튼(리턴 키)을 눌렀을 때의 액션
        searchBar.resignFirstResponder()  // 키보드 숨기기
        
        // 검색어가 공백일 경우
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            print("검색어를 입력해주세요.")
            return
        }
        
        // 특수 문자 체크
        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_+{}[]|\"':;<>,.?/~`")
        if let _ = searchText.rangeOfCharacter(from: specialCharacterSet) {
            print("검색어에 특수 문자는 사용할 수 없습니다.")
            return
        }
        
        // scrollIndex를 10으로 초기화
        scrollIndex = 10
        
        FoodDbAPIManager.shared.fetchFoodItems(searchQuery: searchText, index: scrollIndex) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    // API 응답 처리
                    self.handleSuccessResponse(items)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    // 에러 처리
                    self.handleError(error)
                }
            }
        }
    }
    
    private func handleSuccessResponse(_ items: [FoodItem]) {
        self.foodItems = items
        searchResultTableView.reloadData()
        searchResultTableView.setContentOffset(.zero, animated: true)
    }
    
    private func handleError(_ error: Error) {
        print("데이터를 가져오는 중 오류 발생: \(error.localizedDescription)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()  // 키보드 숨기기
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = nil  // 검색어 초기화
    }
}
