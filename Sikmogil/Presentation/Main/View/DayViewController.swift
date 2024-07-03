//
//  DayViewController.swift
//  Sikmogil
//
//  Created by 문기웅 on 6/6/24.
//

import UIKit
import SnapKit
import Then
import Combine

enum Section: Int, CaseIterable {
    case dietPhotos
    case workoutPhotos
}

class DayViewController: UIViewController {
    
    var viewModel: CalendarViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private var dietPhotos: [String] = []
    private var workoutPhotos: [String] = []
    
    private var eatKal: Int = 0
    private var workoutKal: Int = 0
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    private let scrollSubView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "6월 6일"
        $0.font = Suite.bold.of(size: 20)
    }
    
    private let blueDot = UIView().then {
        $0.backgroundColor = .appDustBlue
        $0.layer.cornerRadius = 5
    }
    
    private let diaryLabel = UILabel().then {
        $0.text = "한 줄 일기"
        $0.font = Suite.bold.of(size: 16)
    }
    
    private let diaryView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
    }
    
    private let diaryTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.font = Suite.regular.of(size: 16)
        $0.text = ""
    }
    
    private lazy var  collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout()).then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        $0.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(210), heightDimension: .absolute(210))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 8
            
            // Create header size and item
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appLightGray
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        setupViews()
        setupConstraints()
        
        bindeViewModel()
    }
    
    private func bindeViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.loadDayCalendar(calendarDate: DateHelper.shared.formatDateToYearMonthDay( viewModel.selectedDate ?? Date()))
        print(DateHelper.shared.formatDateToYearMonthDay( viewModel.selectedDate ?? Date()))
        
        viewModel.$calendarModels
            .receive(on: DispatchQueue.main)
            .sink { calendarModel in
                self.updateUI(with: calendarModel)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with calendarModel: DailyCalendarModel?) {
        guard let calendarModel = calendarModel else { return }
        
        dateLabel.text = calendarModel.diaryDate
        diaryTextView.text = calendarModel.diaryText
        
        dietPhotos = calendarModel.dietPictureDTOS?.compactMap { $0.foodPicture }.filter { !$0.isEmpty } ?? []
        eatKal = calendarModel.totalCalorieEaten ?? 0
        workoutPhotos = calendarModel.workoutLists?.compactMap { $0.workoutPicture }.filter { !$0.isEmpty } ?? []
        workoutKal = calendarModel.workoutLists?.compactMap { $0.calorieBurned }.reduce(0, +) ?? 0
        
        collectionView.reloadData()
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollSubView)
        
        scrollSubView.addSubviews(dateLabel, blueDot, diaryLabel, diaryView, diaryTextView, collectionView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollSubView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(collectionView.snp.top).offset(550)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.equalToSuperview().offset(16)
        }
        
        blueDot.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(22)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(10)
            $0.height.equalTo(10)
        }
        
        diaryLabel.snp.makeConstraints {
            $0.centerY.equalTo(blueDot.snp.centerY)
            $0.leading.equalTo(blueDot.snp.trailing).offset(8)
        }
        
        diaryView.snp.makeConstraints {
            $0.top.equalTo(diaryLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(150)
        }
        
        diaryTextView.snp.makeConstraints {
            $0.top.equalTo(diaryView.snp.top).offset(8)
            $0.leading.equalTo(diaryView.snp.leading).offset(8)
            $0.trailing.equalTo(diaryView.snp.trailing).offset(-8)
            $0.bottom.equalTo(diaryView.snp.bottom).offset(-8)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(diaryView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-32)
        }
    }
}

extension DayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .dietPhotos:
            return dietPhotos.count
        case .workoutPhotos:
            return workoutPhotos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .clear
        
        let photoURL: String
        switch Section(rawValue: indexPath.section)! {
        case .dietPhotos:
            photoURL = dietPhotos[indexPath.item]
        case .workoutPhotos:
            photoURL = workoutPhotos[indexPath.item]
        }
        
        if let url = URL(string: photoURL), !photoURL.isEmpty {
            cell.imageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [
                    .transition(.fade(0.5))
                ],
                progressBlock: nil)
            cell.noImageLabel.isHidden = true
        } else {
            cell.imageView.image = nil
            cell.noImageLabel.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as! HeaderView
            switch Section(rawValue: indexPath.section)! {
            case .dietPhotos:
                headerView.titleLabel.text = "식단"
                if eatKal > 0 {
                    headerView.subTitleLabel.text = "\(eatKal)kal"
                } else {
                    headerView.subTitleLabel.text = ""
                }
                headerView.subTitleLabel.textColor = .appYellow
                headerView.dot.backgroundColor = .appYellow
            case .workoutPhotos:
                headerView.titleLabel.text = "운동"
                if workoutKal > 0 {
                    headerView.subTitleLabel.text = "\(workoutKal)kal"
                } else {
                    headerView.subTitleLabel.text = ""
                }
                headerView.subTitleLabel.textColor = .appGreen
                headerView.dot.backgroundColor = .appGreen
            }
            return headerView
        }
        return UICollectionReusableView()
    }
}
