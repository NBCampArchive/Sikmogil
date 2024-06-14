//
//  DietBottomSheet.swift
//  Sikmogil
//
//  Created by 희라 on 6/3/24.
//  [View] **설명** 식단 추가 바텀시트 페이지

import UIKit
import SnapKit
import Then

class DietBottomSheetViewController: UIViewController {
    
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
        $0.textAlignment = .left
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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
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
            $0.height.equalTo(80)
        }
        breakfastIcon.snp.makeConstraints{
            $0.centerY.equalTo(breakfastView)
            $0.leading.equalTo(breakfastView).offset(12)
        }
        breakfastTitleLabel.snp.makeConstraints{
            $0.centerY.equalTo(breakfastView)
            $0.leading.equalTo(breakfastIcon.snp.trailing).offset(12)
        }
        breakfastAddTabButton.snp.makeConstraints{
            $0.centerY.equalTo(breakfastView)
            $0.trailing.equalTo(breakfastView).inset(20)
        }
        breakfastKcalLabel.snp.makeConstraints{
            $0.centerY.equalTo(breakfastView)
            $0.trailing.equalTo(breakfastView).inset(56)
        }
        // 🍎 lunchView
        lunchView.snp.makeConstraints{
            $0.top.equalTo(breakfastView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(80)
        }
        lunchIcon.snp.makeConstraints{
            $0.centerY.equalTo(lunchView)
            $0.leading.equalTo(lunchView).offset(12)
        }
        lunchTitleLabel.snp.makeConstraints{
            $0.centerY.equalTo(lunchView)
            $0.leading.equalTo(lunchIcon.snp.trailing).offset(12)
        }
        lunchAddTabButton.snp.makeConstraints{
            $0.centerY.equalTo(lunchView)
            $0.trailing.equalTo(lunchView).inset(20)
        }
        lunchKcalLabel.snp.makeConstraints{
            $0.centerY.equalTo(lunchView)
            $0.trailing.equalTo(lunchView).inset(56)
        }
        // 🍎 dinnerView
        dinnerView.snp.makeConstraints{
            $0.top.equalTo(lunchView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(80)
        }
        dinnerIcon.snp.makeConstraints{
            $0.centerY.equalTo(dinnerView)
            $0.leading.equalTo(dinnerView).offset(12)
        }
        dinnerTitleLabel.snp.makeConstraints{
            $0.centerY.equalTo(dinnerView)
            $0.leading.equalTo(dinnerIcon.snp.trailing).offset(12)
        }
        dinnerAddTabButton.snp.makeConstraints{
            $0.centerY.equalTo(dinnerView)
            $0.trailing.equalTo(dinnerView).inset(20)
        }
        dinnerKcalLabel.snp.makeConstraints{
            $0.centerY.equalTo(dinnerView)
            $0.trailing.equalTo(dinnerView).inset(56)
        }
    }
    
    // MARK: - Actions
    @objc func breakfastAddTabButtonTapped() {
        let addDietMenuViewController = AddDietMenuViewController()
        addDietMenuViewController.hidesBottomBarWhenPushed = true
        addDietMenuViewController.addMeal = { [weak self] foodItem in
            guard let self = self else { return }
            // 아침 식사 칼로리 레이블 업데이트
            self.breakfastKcalLabel.text = "\(foodItem.amtNum1) Kcal"
        }
        navigationController?.pushViewController(addDietMenuViewController, animated: true)
    }
    @objc func lunchAddTabButtonTapped() {
        let addDietMenuViewController = AddDietMenuViewController()
        addDietMenuViewController.hidesBottomBarWhenPushed = true
        addDietMenuViewController.addMeal = { [weak self] foodItem in
            guard let self = self else { return }
            // 점심 식사 칼로리 레이블 업데이트
            self.lunchKcalLabel.text = "\(foodItem.amtNum1) Kcal"
        }
        navigationController?.pushViewController(addDietMenuViewController, animated: true)
    }
    @objc func dinnerAddTabButtonTapped() {
        let addDietMenuViewController = AddDietMenuViewController()
        addDietMenuViewController.hidesBottomBarWhenPushed = true
        addDietMenuViewController.addMeal = { [weak self] foodItem in
            guard let self = self else { return }
            // 저녁 식사 칼로리 레이블 업데이트
            self.dinnerKcalLabel.text = "\(foodItem.amtNum1) Kcal"
        }
        navigationController?.pushViewController(addDietMenuViewController, animated: true)
    }
    @objc func albumButtonTapped() {
        let dietAlbumViewController = DietAlbumViewController()
        dietAlbumViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(dietAlbumViewController, animated: true)
    }
}
