//
//  DietBottomSheet.swift
//  Sikmogil
//
//  Created by 희라 on 6/3/24.
//  [View] **설명** 식단 추가 바텀시트 페이지

import UIKit
import SnapKit
import Combine

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
    }
    let breakfastIcon = UIImageView().then {
        $0.image = UIImage(named: "dietIcon")
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
    // 🍎 lunchView
    let lunchView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
    }
    let lunchIcon = UIImageView().then {
        $0.image = UIImage(named: "dietIcon")
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
        $0.textAlignment = .left
    }
    let lunchAddTabButton = UIButton().then {
        $0.setImage(UIImage(named: "addIconRound"), for: .normal)
    }
    // 🍎 dinnerView
    let dinnerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
    }
    let dinnerIcon = UIImageView().then {
        $0.image = UIImage(named: "dietIcon")
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
        $0.textAlignment = .left
    }
    let dinnerAddTabButton = UIButton().then {
        $0.setImage(UIImage(named: "addIconRound"), for: .normal)
    }
    
    // MARK: - Properties
    var totalBreakfastKcal = 0
    var breakfastFoodItems: [FoodItem] = []
    
    var totalLunchKcal = 0
    var lunchFoodItems: [FoodItem] = []
    
    var totalDinnerKcal = 0
    var dinnerFoodItems: [FoodItem] = []
    
    // breakfastView height constraint
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
        albumButton.addTarget(self, action: #selector(albumButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubviews(titleLabel,albumButton,breakfastView,lunchView,dinnerView)
        breakfastView.addSubviews(breakfastIcon,breakfastTitleLabel,breakfastKcalLabel,breakfastAddTabButton)
        lunchView.addSubviews(lunchIcon,lunchTitleLabel,lunchKcalLabel,lunchAddTabButton)
        dinnerView.addSubviews(dinnerIcon,dinnerTitleLabel,dinnerKcalLabel,dinnerAddTabButton)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(16)
        }
        albumButton.snp.makeConstraints{
            $0.top.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(30)
            $0.width.equalTo(91)
        }
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
            $0.width.equalTo(65)
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
        }
    }
    
    // MARK: - Actions
    @objc func breakfastAddTabButtonTapped() {
        let addDietMenuViewController = AddDietMenuViewController()
        addDietMenuViewController.hidesBottomBarWhenPushed = true
        addDietMenuViewController.addMeal = { [weak self] foodItem in
            guard let self = self else { return }
            
            self.breakfastFoodItems.append(foodItem) // foodItem을 breakfastfoodItems에 추가
            
            if let kcal = Int(foodItem.amtNum1) {
                addMealViewModel.totalBreakfastKcal += kcal
            }
            
            print(addMealViewModel.totalBreakfastKcal)
            
            // 새로운 UIView 생성 및 추가
            let newFoodContentView = UIView()
            
            let newFoodTitleLabel = UILabel().then {
                $0.text = "\(foodItem.foodNmKr)"
                $0.textColor = .appDarkGray
                $0.font = Suite.semiBold.of(size: 16)
                $0.textAlignment = .left
            }
            let newFoodKcalLabel = UILabel().then {
                $0.text = "\(foodItem.amtNum1) Kcal"
                $0.textColor = .appDarkGray
                $0.font = Suite.semiBold.of(size: 16)
                $0.textAlignment = .right
            }
            
            newFoodContentView.addSubviews(newFoodTitleLabel, newFoodKcalLabel)
            self.breakfastView.addSubview(newFoodContentView)
            
            // UIView & UILabel 제약 조건 설정
            var previousView = self.breakfastView.subviews.last { $0 != newFoodContentView && $0 != self.breakfastTitleLabel }
            newFoodContentView.snp.makeConstraints {
                $0.top.equalTo(previousView?.snp.bottom ?? self.breakfastTitleLabel.snp.bottom).offset(10)
                $0.leading.equalTo(self.breakfastTitleLabel)
                $0.trailing.equalTo(self.breakfastKcalLabel)
                $0.height.equalTo(16)
            }
            newFoodTitleLabel.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.trailing.equalTo(newFoodKcalLabel.snp.leading)
            }
            newFoodKcalLabel.snp.makeConstraints {
                $0.top.equalTo(newFoodContentView)
                $0.centerX.equalTo(self.breakfastKcalLabel)
            }
            //breakfastView 높이 조정
            self.breakfastViewHeightConstraint?.update(offset: self.breakfastView.frame.height + 26)
        }
        navigationController?.pushViewController(addDietMenuViewController, animated: true)
    }
    
    @objc func lunchAddTabButtonTapped() {
        let addDietMenuViewController = AddDietMenuViewController()
        addDietMenuViewController.hidesBottomBarWhenPushed = true
        addDietMenuViewController.addMeal = { [weak self] foodItem in
            guard let self = self else { return }
            
            self.lunchFoodItems.append(foodItem) // foodItem을 lunchFoodItems에 추가
            
            if let kcal = Int(foodItem.amtNum1) {
                addMealViewModel.totalLunchKcal += kcal
            }
            
            // 새로운 UIView 생성 및 추가
            let newFoodContentView = UIView()
            
            let newFoodTitleLabel = UILabel().then {
                $0.text = "\(foodItem.foodNmKr)"
                $0.textColor = .appDarkGray
                $0.font = Suite.semiBold.of(size: 16)
                $0.textAlignment = .left
            }
            let newFoodKcalLabel = UILabel().then {
                $0.text = "\(foodItem.amtNum1) Kcal"
                $0.textColor = .appDarkGray
                $0.font = Suite.semiBold.of(size: 16)
                $0.textAlignment = .right
            }
            
            newFoodContentView.addSubviews(newFoodTitleLabel, newFoodKcalLabel)
            self.lunchView.addSubview(newFoodContentView)
            
            // UIView & UILabel 제약 조건 설정
            var previousView = self.lunchView.subviews.last { $0 != newFoodContentView && $0 != self.lunchTitleLabel }
            newFoodContentView.snp.makeConstraints {
                $0.top.equalTo(previousView?.snp.bottom ?? self.lunchTitleLabel.snp.bottom).offset(10)
                $0.leading.equalTo(self.lunchTitleLabel)
                $0.trailing.equalTo(self.lunchKcalLabel)
                $0.height.equalTo(16)
            }
            newFoodTitleLabel.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.trailing.equalTo(newFoodKcalLabel.snp.leading)
            }
            newFoodKcalLabel.snp.makeConstraints {
                $0.top.equalTo(newFoodContentView)
                $0.centerX.equalTo(self.lunchKcalLabel)
            }
            // lunchView 높이 조정
            self.lunchViewHeightConstraint?.update(offset: self.lunchView.frame.height + 26)
        }
        navigationController?.pushViewController(addDietMenuViewController, animated: true)
    }
    
    @objc func dinnerAddTabButtonTapped() {
        let addDietMenuViewController = AddDietMenuViewController()
        addDietMenuViewController.hidesBottomBarWhenPushed = true
        addDietMenuViewController.addMeal = { [weak self] foodItem in
            guard let self = self else { return }
            
            self.dinnerFoodItems.append(foodItem) // foodItem을 dinnerFoodItems에 추가
            
            if let kcal = Int(foodItem.amtNum1) {
                addMealViewModel.totalDinnerKcal += kcal
            }
            
            // 새로운 UIView 생성 및 추가
            let newFoodContentView = UIView()
            
            let newFoodTitleLabel = UILabel().then {
                $0.text = "\(foodItem.foodNmKr)"
                $0.textColor = .appDarkGray
                $0.font = Suite.semiBold.of(size: 16)
                $0.textAlignment = .left
            }
            let newFoodKcalLabel = UILabel().then {
                $0.text = "\(foodItem.amtNum1) Kcal"
                $0.textColor = .appDarkGray
                $0.font = Suite.semiBold.of(size: 16)
                $0.textAlignment = .right
            }
            
            newFoodContentView.addSubviews(newFoodTitleLabel, newFoodKcalLabel)
            self.dinnerView.addSubview(newFoodContentView)
            
            // UIView & UILabel 제약 조건 설정
            var previousView = self.dinnerView.subviews.last { $0 != newFoodContentView && $0 != self.dinnerTitleLabel }
            newFoodContentView.snp.makeConstraints {
                $0.top.equalTo(previousView?.snp.bottom ?? self.dinnerTitleLabel.snp.bottom).offset(10)
                $0.leading.equalTo(self.dinnerTitleLabel)
                $0.trailing.equalTo(self.dinnerKcalLabel)
                $0.height.equalTo(16)
            }
            newFoodTitleLabel.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.trailing.equalTo(newFoodKcalLabel.snp.leading)
            }
            newFoodKcalLabel.snp.makeConstraints {
                $0.top.equalTo(newFoodContentView)
                $0.centerX.equalTo(self.dinnerKcalLabel)
            }
            // dinnerView 높이 조정
            self.dinnerViewHeightConstraint?.update(offset: self.dinnerView.frame.height + 26)
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
    }
}
