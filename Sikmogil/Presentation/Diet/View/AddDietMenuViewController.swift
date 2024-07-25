//
//  AddDietMenuViewController.swift
//  Sikmogil
//
//  Created by 희라 on 6/4/24.
//  [View] **설명** 식사추가 페이지

import UIKit
import FloatingPanel

class AddDietMenuViewController: UIViewController {
    
    var floatingPanel: FloatingPanelController!
    var previousPanelState: FloatingPanelState = .hidden
    
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
        $0.tintColor = .appBlack
        $0.setValue("취소", forKey: "cancelButtonText")
        $0.backgroundImage = UIImage()
    }
    let searchResultTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(AddDietMenuTableViewCell.self, forCellReuseIdentifier: "AddDietMenuTableViewCell")
        $0.separatorStyle = .none
    }
    let handWrittenButton = UIButton().then {
        $0.setTitle("+ 직접추가", for: .normal)
        $0.backgroundColor = .appBlack
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 16)
        $0.tintColor = .white
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(showHandWrittenButtonBottomSheet), for: .touchUpInside)
        // 버튼 히든 처리
        //        $0.isHidden = true
    }
    var overlayView: UIView! //키보드 활성화시 호출
    
    // MARK: - Properties
    var foodItems: [FoodItem] = []  // 데이터 저장 배열
    var addMeal: ((FoodItem) -> Void)?
    
    var scrollIndex = 10
    var isLoading = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        fetchFoodData(searchText: "")
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        searchBar.delegate = self
        
        setupOverlayView()
        setupFloatingPanel()
        
        // NotificationCenter에 옵저버 추가
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToDietBottomSheet), name: .didAddMeal, object: nil)
    }
    deinit {
        // 옵저버 제거
        NotificationCenter.default.removeObserver(self, name: .didAddMeal, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubviews(TitleLabel, searchBar, searchResultTableView, handWrittenButton)
    }
    
    private func setupOverlayView() {
        overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.isHidden = true
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        view.addSubview(overlayView)
    }
    
    @objc override func dismissKeyboard() {
        searchBar.resignFirstResponder()
        overlayView.isHidden = true
    }
    
    private func fetchFoodData(searchText: String) {
        isLoading = true
        FoodDbAPIManager.shared.fetchFoodItems(searchQuery: searchText, index: scrollIndex) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let items):
                    // 기존 데이터를 유지하고 새로운 데이터만 추가
                    self.foodItems.append(contentsOf: items)
                    self.searchResultTableView.reloadData()
                case .failure(let error):
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
            $0.top.equalTo(TitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(8)
        }
        searchResultTableView.snp.makeConstraints{
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        handWrittenButton.snp.makeConstraints{
            $0.centerY.equalTo(TitleLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(32)
            $0.width.equalTo(88)
        }
    }
    
    func setupFloatingPanel() {
        floatingPanel = FloatingPanelController()
        floatingPanel.layout = CustomFloatingPanelLayout()
        floatingPanel.isRemovalInteractionEnabled = true
        floatingPanel.changePanelStyle()
        floatingPanel.delegate = self
    }
    
    private func showBottomSheet(contentVC: UIViewController) {
        guard let floatingPanel = floatingPanel else {
            print("Error: FloatingPanelController is not initialized")
            return
        }
        floatingPanel.set(contentViewController: contentVC)
        floatingPanel.addPanel(toParent: self)
    }
    
    @objc private func showHandWrittenButtonBottomSheet() {
        let contentVC = AddDietMenuBottomSheetViewController()
        contentVC.addMealAction = { [weak self] foodItem in
            self?.addMeal?(foodItem)
            self?.floatingPanel.move(to: .hidden, animated: true)
        }
        showBottomSheet(contentVC: contentVC)
    }
    
    @objc private func navigateToDietBottomSheet() {
        // DietBottomSheetViewController로 화면 이동
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
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
        
        if contentOffsetY > contentHeight - frameHeight - 100 { // 약간의 여유를 둠
            // 스크롤이 끝에 도달했을 때 추가 데이터를 로드
            loadMoreData()
        }
    }
    
    
    private func loadMoreData() {
        guard !isLoading else { return }
        
        scrollIndex += 10 // 증가된 인덱스
        
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
        overlayView.isHidden = false
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 버튼(리턴 키)을 눌렀을 때의 액션
        searchBar.resignFirstResponder()  // 키보드 숨기기
        overlayView.isHidden = true
        
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
        
        // scrollIndex를 0으로 초기화
        scrollIndex = 0
        
        foodItems.removeAll() // 새로운 검색어에 대한 기존 데이터 제거
        searchResultTableView.reloadData()
        
        fetchFoodData(searchText: searchText)
    }
    
    private func handleSuccessResponse(_ items: [FoodItem]) {
        foodItems.append(contentsOf: items)
        searchResultTableView.reloadData()
    }
    
    private func handleError(_ error: Error) {
        print("데이터를 가져오는 중 오류 발생: \(error.localizedDescription)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()  // 키보드 숨기기
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = nil  // 검색어 초기화
        overlayView.isHidden = true
    }
}

extension AddDietMenuViewController: FloatingPanelControllerDelegate {
    
    func floatingPanelDidChangeState(_ vc: FloatingPanelController) {
        if vc.state == .full {
            tabBarController?.tabBar.isHidden = true
            vc.backdropView.dismissalTapGestureRecognizer.isEnabled = false
        } else if vc.state == .half  {
            tabBarController?.tabBar.isHidden = true
            vc.backdropView.dismissalTapGestureRecognizer.isEnabled = false
            
            // 상태가 .full에서 .half로 변경되었을 때 키보드를 숨김
            if previousPanelState == .full {
                view.endEditing(true)
            }
        } else {
            vc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        }
        previousPanelState = vc.state
    }
    
    func floatingPanelDidRemove(_ vc: FloatingPanelController) {
        tabBarController?.tabBar.isHidden = false
        vc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
    }
}

extension Notification.Name {
    static let didAddMeal = Notification.Name("didAddMeal")
}
