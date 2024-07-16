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
import Kingfisher
import SkeletonView

enum Section: Int, CaseIterable {
    case dietText
    case dietPhotos
    case workoutText
    case workoutPhotos
}

class DayViewController: UIViewController {
    
    var viewModel: CalendarViewModel?
    private var cancellables = Set<AnyCancellable>()
    
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
        $0.isEditable = false  // 수정 불가능하게 설정
        $0.isSelectable = false  // 텍스트 선택 비활성화
    }
    
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout()).then {
        $0.isSkeletonable = true
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        $0.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        $0.register(DetailListCell.self, forCellWithReuseIdentifier: DetailListCell.reuseIdentifier)
    }
    
    // MARK: - Compositional Layout
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = Section(rawValue: sectionIndex)!
            
            switch section {
            case .dietText, .workoutText:
                return self.createTextSectionWithHeader()
            case .dietPhotos, .workoutPhotos:
                return self.createPhotoSectionWithoutHeader()
            }
        }
    }
    
    private func createTextSectionWithHeader() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10 // 그룹 간 간격 설정
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createPhotoSectionWithoutHeader() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(200), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10 // 이미지 간 간격
        
        return section
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appLightGray
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        setupViews()
        setupConstraints()
        
        bindeViewModel()
    }
    
    // MARK: - ViewModel Binding
    private func bindeViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.loadDayCalendar(calendarDate: DateHelper.shared.formatDateToYearMonthDay( viewModel.selectedDate ?? Date()))
        print(DateHelper.shared.formatDateToYearMonthDay( viewModel.selectedDate ?? Date()))
        viewModel.loadDayDiet(calendarDate: DateHelper.shared.formatDateToYearMonthDay( viewModel.selectedDate ?? Date()))
        
        viewModel.$calendarModels
            .receive(on: DispatchQueue.main)
            .sink { calendarModel in
                self.updateUI()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI functions
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        
        dateLabel.text = viewModel.diaryDate
        diaryTextView.text = viewModel.diaryText
        
        collectionView.reloadData()
        //        collectionView.layoutIfNeeded()
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollSubView)
        
        scrollSubView.addSubviews(dateLabel, blueDot, diaryLabel, diaryView, diaryTextView, collectionView)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollSubView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(collectionView.snp.top).offset(850)
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.sections().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        let sectionType = viewModel.sections()[section]
        return viewModel.numberOfItems(in: sectionType)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        let sectionType = viewModel.sections()[indexPath.section]
        
        switch sectionType {
        case .dietPhotos, .workoutPhotos:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
            cell.backgroundColor = .clear
            
            let photoURL: String
            if Section(rawValue: indexPath.section) == .dietPhotos {
                guard indexPath.item < viewModel.dietPhotos.count else {
                    // 범위를 벗어난 경우 빈 셀 반환
                    return cell
                }
                photoURL = viewModel.dietPhotos[indexPath.item]
            } else {
                guard indexPath.item < viewModel.workoutPhotos.count else {
                    // 범위를 벗어난 경우 빈 셀 반환
                    return cell
                }
                photoURL = viewModel.workoutPhotos[indexPath.item]
            }
            
            if let url = URL(string: photoURL), !photoURL.isEmpty {
                cell.showSkeleton()
                cell.imageView.kf.setImage(
                    with: url,
                    placeholder: nil,
                    options: [.transition(.fade(0.5)), .forceRefresh],
                    progressBlock: nil) { result in
                        switch result {
                        case .success(_):
                            cell.hideSkeleton()
                        case .failure(_):
                            cell.showSkeleton()
                        }
                    }
                cell.noImageLabel.isHidden = true
            } else {
                cell.imageView.image = nil
                cell.noImageLabel.isHidden = false
                cell.hideSkeleton()
            }
            return cell
            
        case .dietText, .workoutText:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailListCell.reuseIdentifier, for: indexPath) as? DetailListCell else { return UICollectionViewCell() }
            cell.backgroundColor = .clear
            
            let title: String
            let subtitle: String
            if Section(rawValue: indexPath.section) == .dietText {
                title = viewModel.dietTexts[indexPath.item]
                subtitle = viewModel.dietSubtexts[indexPath.item]
            } else {
                title = viewModel.workoutTexts[indexPath.item]
                subtitle = viewModel.workoutSubtexts[indexPath.item]
            }
            
            cell.titleLabel.text = title
            cell.subtitleLabel.text = subtitle
            cell.contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let viewModel = viewModel else { return UICollectionReusableView() }
        let sectionType = viewModel.sections()[indexPath.section]
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
                return UICollectionReusableView()
            }
            
            switch sectionType {
            case .dietText, .dietPhotos:
                if viewModel.shouldShowHeader(for: sectionType) {
                    headerView.titleLabel.text = "식단"
                    headerView.subTitleLabel.text = viewModel.eatKal > 0 ? "\(viewModel.eatKal)kal" : ""
                    headerView.subTitleLabel.textColor = .appYellow
                    headerView.dot.backgroundColor = .appYellow
                    headerView.isHidden = false
                } else {
                    headerView.isHidden = true
                }
            case .workoutText, .workoutPhotos:
                if viewModel.shouldShowHeader(for: sectionType) {
                    headerView.titleLabel.text = "운동"
                    headerView.subTitleLabel.text = viewModel.workoutKal > 0 ? "\(viewModel.workoutKal)kal" : ""
                    headerView.subTitleLabel.textColor = .appGreen
                    headerView.dot.backgroundColor = .appGreen
                    headerView.isHidden = false
                } else {
                    headerView.isHidden = true
                }
            }
            
            return headerView
        }
        return UICollectionReusableView()
    }
}
