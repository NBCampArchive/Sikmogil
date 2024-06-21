//
//  DietBottomSheet.swift
//  Sikmogil
//
//  Created by 희라 on 6/3/24.
//  [View] **설명** 식단 추가 바텀시트 페이지

import UIKit
import SnapKit
import Combine
import FloatingPanel

class DietBottomSheetViewController: UIViewController {
    
    var addMealViewModel: AddMealViewModel = AddMealViewModel.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI components
    let contentView = UIView().then {
        $0.backgroundColor = .appLightGray
    }
    let titleLabel = UILabel().then {
        $0.text = "식사"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 28)
        $0.textAlignment = .left
    }
    let albumButton = UIButton().then {
        $0.setTitle("앨범", for: .normal)
        $0.backgroundColor = .appBlack
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.semiBold.of(size: 16)
        
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
    }
    // 🍎 breakfastView
    let breakfastView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    let breakfastIcon = UIImageView().then {
        $0.image = UIImage(named: "dietIconb")
        $0.contentMode = .scaleAspectFit
    }
    let breakfastTitleLabel = UILabel().then {
        $0.text = "아침"
        $0.textColor = .appBlack
        $0.font = Suite.semiBold.of(size: 20)
        $0.textAlignment = .left
    }
    let breakfastKcalLabel = UILabel().then {
        $0.text = "000kcal"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 16)
        $0.textAlignment = .right
    }
    let breakfastAddTabButton = UIButton().then {
        $0.setImage(UIImage(named: "addIconRound"), for: .normal)
    }
    let breakfastTableView = UITableView().then {
        $0.register(BreakfastTableViewCell.self, forCellReuseIdentifier: "BreakfastTableViewCell")
        $0.separatorStyle = .none
    }
    // 🍎 lunchView
    let lunchView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    let lunchIcon = UIImageView().then {
        $0.image = UIImage(named: "dietIconl")
        $0.contentMode = .scaleAspectFit
    }
    let lunchTitleLabel = UILabel().then {
        $0.text = "점심"
        $0.textColor = .appBlack
        $0.font = Suite.semiBold.of(size: 20)
        $0.textAlignment = .left
    }
    let lunchKcalLabel = UILabel().then {
        $0.text = "000kcal"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 16)
        $0.textAlignment = .right
    }
    let lunchAddTabButton = UIButton().then {
        $0.setImage(UIImage(named: "addIconRound"), for: .normal)
    }
    let lunchTableView = UITableView().then {
        $0.register(LunchTableViewCell.self, forCellReuseIdentifier: "LunchTableViewCell")
        $0.separatorStyle = .none
    }
    // 🍎 dinnerView
    let dinnerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    let dinnerIcon = UIImageView().then {
        $0.image = UIImage(named: "dietIcon")
        $0.contentMode = .scaleAspectFit
    }
    let dinnerTitleLabel = UILabel().then {
        $0.text = "저녁"
        $0.textColor = .appBlack
        $0.font = Suite.semiBold.of(size: 20)
        $0.textAlignment = .left
    }
    let dinnerKcalLabel = UILabel().then {
        $0.text = "000kcal"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 16)
        $0.textAlignment = .right
    }
    let dinnerAddTabButton = UIButton().then {
        $0.setImage(UIImage(named: "addIconRound"), for: .normal)
    }
    let dinnerTableView = UITableView().then {
        $0.register(DinnerTableViewCell.self, forCellReuseIdentifier: "DinnerTableViewCell")
        $0.separatorStyle = .none
    }
    
    // MARK: - Properties
    //공공데이터 api 받아오는 변수
    var breakfastFoodItems: [FoodItem] = []
    var lunchFoodItems: [FoodItem] = []
    var dinnerFoodItems: [FoodItem] = []
    
    //동적뷰 용 높이 변수
    var breakfastViewHeightConstraint: Constraint?
    var lunchViewHeightConstraint: Constraint?
    var dinnerViewHeightConstraint: Constraint?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        // 구독 설정
        subscribeToViewModel()
        
        breakfastAddTabButton.addTarget(self, action: #selector(breakfastAddTabButtonTapped), for: .touchUpInside)
        lunchAddTabButton.addTarget(self, action: #selector(lunchAddTabButtonTapped), for: .touchUpInside)
        dinnerAddTabButton.addTarget(self, action: #selector(dinnerAddTabButtonTapped), for: .touchUpInside)
        //albumButton.addTarget(self, action: #selector(albumButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubviews(titleLabel,breakfastView,lunchView,dinnerView) //albumButton 제외처리
        breakfastView.addSubviews(breakfastIcon,breakfastTitleLabel,breakfastKcalLabel,breakfastAddTabButton,breakfastTableView)
        lunchView.addSubviews(lunchIcon,lunchTitleLabel,lunchKcalLabel,lunchAddTabButton,lunchTableView)
        dinnerView.addSubviews(dinnerIcon,dinnerTitleLabel,dinnerKcalLabel,dinnerAddTabButton,dinnerTableView)
        
        // 테이블뷰 설정
        breakfastTableView.delegate = self
        breakfastTableView.dataSource = self
        lunchTableView.delegate = self
        lunchTableView.dataSource = self
        dinnerTableView.delegate = self
        dinnerTableView.dataSource = self
        
        if let fpc = parent as? FloatingPanelController {
            fpc.surfaceView.containerMargins.bottom = 0
        }
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
//        albumButton.snp.makeConstraints{
//            $0.top.equalTo(titleLabel)
//            $0.trailing.equalToSuperview().inset(16)
//            $0.height.equalTo(30)
//            $0.width.equalTo(91)
//        }
        // 🍎 breakfastView
        breakfastView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            self.breakfastViewHeightConstraint = $0.height.equalTo(80).constraint
        }
        breakfastIcon.snp.makeConstraints{
            $0.top.equalTo(breakfastView).offset(12)
            $0.leading.equalTo(breakfastView).offset(8)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        breakfastTitleLabel.snp.makeConstraints{
            $0.centerY.equalTo(breakfastIcon)
            $0.leading.equalTo(breakfastIcon.snp.trailing).offset(8)
        }
        breakfastAddTabButton.snp.makeConstraints{
            $0.centerY.equalTo(breakfastIcon)
            $0.trailing.equalTo(breakfastView).inset(20)
        }
        breakfastKcalLabel.snp.makeConstraints{
            $0.centerY.equalTo(breakfastIcon)
            $0.trailing.equalTo(breakfastView).inset(56)
            $0.width.equalTo(80)
        }
        breakfastTableView.snp.makeConstraints {
            $0.top.equalTo(breakfastIcon.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        // 🍎 lunchView
        lunchView.snp.makeConstraints{
            $0.top.equalTo(breakfastView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            self.lunchViewHeightConstraint = $0.height.equalTo(80).constraint
        }
        lunchIcon.snp.makeConstraints{
            $0.top.equalTo(lunchView).offset(12)
            $0.leading.equalTo(lunchView).offset(8)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        lunchTitleLabel.snp.makeConstraints{
            $0.centerY.equalTo(lunchIcon)
            $0.leading.equalTo(lunchIcon.snp.trailing).offset(8)
        }
        lunchAddTabButton.snp.makeConstraints{
            $0.centerY.equalTo(lunchIcon)
            $0.trailing.equalTo(lunchView).inset(20)
        }
        lunchKcalLabel.snp.makeConstraints{
            $0.centerY.equalTo(lunchIcon)
            $0.trailing.equalTo(lunchView).inset(56)
            $0.width.equalTo(80)
        }
        lunchTableView.snp.makeConstraints {
            $0.top.equalTo(lunchIcon.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        // 🍎 dinnerView
        dinnerView.snp.makeConstraints{
            $0.top.equalTo(lunchView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            self.dinnerViewHeightConstraint = $0.height.equalTo(80).constraint
        }
        dinnerIcon.snp.makeConstraints{
            $0.top.equalTo(dinnerView).offset(12)
            $0.leading.equalTo(dinnerView).offset(8)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        dinnerTitleLabel.snp.makeConstraints{
            $0.centerY.equalTo(dinnerIcon)
            $0.leading.equalTo(dinnerIcon.snp.trailing).offset(8)
        }
        dinnerAddTabButton.snp.makeConstraints{
            $0.centerY.equalTo(dinnerIcon)
            $0.trailing.equalTo(dinnerView).inset(20)
        }
        dinnerKcalLabel.snp.makeConstraints{
            $0.centerY.equalTo(dinnerIcon)
            $0.trailing.equalTo(dinnerView).inset(56)
            $0.width.equalTo(80)
        }
        dinnerTableView.snp.makeConstraints {
            $0.top.equalTo(dinnerIcon.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc func breakfastAddTabButtonTapped() {
        let addDietMenuViewController = AddDietMenuViewController()
        addDietMenuViewController.hidesBottomBarWhenPushed = true
        addDietMenuViewController.addMeal = { [weak self] foodItem in
            guard let self = self else { return }
            
            // 업로드할 식단 데이터를 생성하고 업로드 요청
            let dietList = DietList(dietListId: 0, calorie: Int(foodItem.amtNum1) ?? 0, foodName: foodItem.foodNmKr, mealTime: "breakfast")
            addMealViewModel.addDietList(for: DateHelper.shared.formatDateToYearMonthDay(Date()), dietList: dietList) { result in
                switch result {
                case .success:
                    print("아침 식단 업로드 성공")
                case .failure(let error):
                    print("아침 식단 업로드 실패: \(error)")
                }
            }
        }
        guard let navigationController = navigationController else {
            print("Error: navigationController is nil")
            return
        }
        navigationController.pushViewController(addDietMenuViewController, animated: true)
    }
    
    @objc func lunchAddTabButtonTapped() {
        let addDietMenuViewController = AddDietMenuViewController()
        addDietMenuViewController.hidesBottomBarWhenPushed = true
        addDietMenuViewController.addMeal = { [weak self] foodItem in
            guard let self = self else { return }
            
            // 업로드할 식단 데이터를 생성하고 업로드 요청
            let dietList = DietList(dietListId: 0, calorie: Int(foodItem.amtNum1) ?? 0, foodName: foodItem.foodNmKr, mealTime: "lunch")
            addMealViewModel.addDietList(for: DateHelper.shared.formatDateToYearMonthDay(Date()), dietList: dietList) { result in
                switch result {
                case .success:
                    print("점심 식단 업로드 성공")
                case .failure(let error):
                    print("점심 식단 업로드 실패: \(error)")
                }
            }
        }
        navigationController?.pushViewController(addDietMenuViewController, animated: true)
    }
    
    @objc func dinnerAddTabButtonTapped() {
        let addDietMenuViewController = AddDietMenuViewController()
        addDietMenuViewController.hidesBottomBarWhenPushed = true
        addDietMenuViewController.addMeal = { [weak self] foodItem in
            guard let self = self else { return }
            
            // 업로드할 식단 데이터를 생성하고 업로드 요청
            let dietList = DietList(dietListId: 0, calorie: Int(foodItem.amtNum1) ?? 0, foodName: foodItem.foodNmKr, mealTime: "dinner")
            addMealViewModel.addDietList(for: DateHelper.shared.formatDateToYearMonthDay(Date()), dietList: dietList) { result in
                switch result {
                case .success:
                    print("저녁 식단 업로드 성공")
                case .failure(let error):
                    print("저녁 식단 업로드 실패: \(error)")
                }
            }
        }
        navigationController?.pushViewController(addDietMenuViewController, animated: true)
    }
    
    @objc func albumButtonTapped() {
        let dietAlbumViewController = DietAlbumViewController()
        dietAlbumViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(dietAlbumViewController, animated: true)
    }
    
    // MARK: - ViewModel
    private func subscribeToViewModel() {
        // AddMealViewModel의 totalBreakfastKcal을 구독하여 breakfastKcalLabel을 업데이트
        addMealViewModel.$totalBreakfastKcal
            .map { "\($0) Kcal" }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.breakfastKcalLabel.text = value
            }
            .store(in: &cancellables)
        
        addMealViewModel.$totalLunchKcal
            .map { "\($0) Kcal" }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.lunchKcalLabel.text = value
            }
            .store(in: &cancellables)
        
        addMealViewModel.$totalDinnerKcal
            .map { "\($0) Kcal" }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.dinnerKcalLabel.text = value
            }
            .store(in: &cancellables)
        
        addMealViewModel.$breakfastDietLists
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.breakfastTableView.reloadData()
                self?.updateBreakfastViewHeight()
            }
            .store(in: &cancellables)
        
        addMealViewModel.$lunchDietLists
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.lunchTableView.reloadData()
                self?.updatelunchViewHeight()
            }
            .store(in: &cancellables)
        addMealViewModel.$dinnerDietLists
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.dinnerTableView.reloadData()
                self?.updatedinnerViewHeight()
            }
            .store(in: &cancellables)
    }
    
    //동적 뷰 관리용 함수
    private func updateBreakfastViewHeight() {
        let defaultHeight: CGFloat = 80
        let tableViewHeight = breakfastTableView.contentSize.height
        let maxAllowedHeight: CGFloat = 280 // 최대 허용 높이
        let newHeight = defaultHeight + min(tableViewHeight, maxAllowedHeight - defaultHeight)
        breakfastViewHeightConstraint?.update(offset: newHeight)
    }
    private func updatelunchViewHeight() {
        let defaultHeight: CGFloat = 80
        let tableViewHeight = lunchTableView.contentSize.height
        let maxAllowedHeight: CGFloat = 280 // 최대 허용 높이
        let newHeight = defaultHeight + min(tableViewHeight, maxAllowedHeight - defaultHeight)
        lunchViewHeightConstraint?.update(offset: newHeight)
    }
    private func updatedinnerViewHeight() {
        let defaultHeight: CGFloat = 80
        let tableViewHeight = dinnerTableView.contentSize.height
        let maxAllowedHeight: CGFloat = 280 // 최대 허용 높이
        let newHeight = defaultHeight + min(tableViewHeight, maxAllowedHeight - defaultHeight)
        dinnerViewHeightConstraint?.update(offset: newHeight)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension DietBottomSheetViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case breakfastTableView:
            return addMealViewModel.breakfastDietLists.count
        case lunchTableView:
            return addMealViewModel.lunchDietLists.count
        case dinnerTableView:
            return addMealViewModel.dinnerDietLists.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case breakfastTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BreakfastTableViewCell", for: indexPath) as! BreakfastTableViewCell
            let item = addMealViewModel.breakfastDietLists[indexPath.row]
            cell.nameLabel.text = "\(item.foodName)"
            cell.kcalLabel.text = "\(item.calorie) Kcal"
            return cell
        case lunchTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LunchTableViewCell", for: indexPath) as! LunchTableViewCell
            let item = addMealViewModel.lunchDietLists[indexPath.row]
            cell.nameLabel.text = "\(item.foodName)"
            cell.kcalLabel.text = "\(item.calorie) Kcal"
            return cell
        case dinnerTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DinnerTableViewCell", for: indexPath) as! DinnerTableViewCell
            let item = addMealViewModel.dinnerDietLists[indexPath.row]
            cell.nameLabel.text = "\(item.foodName)"
            cell.kcalLabel.text = "\(item.calorie) Kcal"
            return cell
        default:
            fatalError("Unknown table view")
        }
    }
    
    //셀 높이 지정: 수동지정이 안되어있으면 컨텐츠크기 계산에 오류발생
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45 // 모든 셀의 높이를 55로 설정합니다.
    }
    
    // 테이블뷰 셀 삭제 액션
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            switch tableView {
            case self.breakfastTableView:
                let item = self.addMealViewModel.breakfastDietLists[indexPath.row]
                let dietListId = item.dietListId // 삭제할 데이터의 ID 가져오기
                
                // 서버에서 데이터 삭제
                self.addMealViewModel.deleteDietList(for: DateHelper.shared.formatDateToYearMonthDay(Date()), dietListId: dietListId) { result in
                    switch result {
                    case .success:
                        // 데이터 소스에서 삭제
                        self.addMealViewModel.breakfastDietLists.remove(at: indexPath.row)
                        // UI 업데이트
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(let error):
                        print("삭제 실패: \(error)")
                        // 실패 시 사용자에게 알림 처리 등
                    }
                }
                
            case self.lunchTableView:
                let item = self.addMealViewModel.lunchDietLists[indexPath.row]
                let dietListId = item.dietListId // 삭제할 데이터의 ID 가져오기
                
                // 서버에서 데이터 삭제
                self.addMealViewModel.deleteDietList(for: DateHelper.shared.formatDateToYearMonthDay(Date()), dietListId: dietListId) { result in
                    switch result {
                    case .success:
                        // 데이터 소스에서 삭제
                        self.addMealViewModel.lunchDietLists.remove(at: indexPath.row)
                        // UI 업데이트
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(let error):
                        print("삭제 실패: \(error)")
                        // 실패 시 사용자에게 알림 처리 등
                    }
                }
                
            case self.dinnerTableView:
                let item = self.addMealViewModel.dinnerDietLists[indexPath.row]
                let dietListId = item.dietListId // 삭제할 데이터의 ID 가져오기
                
                // 서버에서 데이터 삭제
                self.addMealViewModel.deleteDietList(for: DateHelper.shared.formatDateToYearMonthDay(Date()), dietListId: dietListId) { result in
                    switch result {
                    case .success:
                        // 데이터 소스에서 삭제
                        self.addMealViewModel.dinnerDietLists.remove(at: indexPath.row)
                        // UI 업데이트
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(let error):
                        print("삭제 실패: \(error)")
                        // 실패 시 사용자에게 알림 처리 등
                    }
                }
                
            default:
                fatalError("Unknown table view")
            }
            
            
            completion(true)
        }
        
        // 배경색 및 이미지 설정
        deleteAction.backgroundColor = UIColor.white
        let trashImage = UIImage(systemName: "trash")?.withTintColor(UIColor.darkGray, renderingMode: .alwaysOriginal)
        deleteAction.image = trashImage
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
}
