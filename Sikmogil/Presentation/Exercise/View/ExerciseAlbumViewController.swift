//
//  ExerciseAlbumViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/26/24.
//

import UIKit
import SnapKit
import Then

class ExerciseAlbumViewController: UIViewController {
    
    private var viewModel = ExerciseAlbumViewModel()
    
    // MARK: - Components
    let albumTitleLabel = UILabel().then {
        $0.text = "운동 앨범"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 24)
        $0.textAlignment = .left
    }
    
    let albumTitleSubLabel = UILabel().then {
        $0.text = "운동 기록을 사진으로 기록해보세요!"
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 14)
        $0.textAlignment = .left
    }
    
    let albumAddPhotoButton = UIButton().then {
        $0.setTitle("사진 기록하기", for: .normal)
        $0.backgroundColor = .appBlack
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
    }
    
    let albumCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        setupViews()
        setupConstraints()
        bindViewModel()
    }
    
    // MARK: - Setup View
    private func setupViews() {
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.register(ExerciseAlbumCell.self, forCellWithReuseIdentifier: ExerciseAlbumCell.identifier)
        
        view.addSubviews(albumTitleLabel, albumTitleSubLabel, albumCollectionView)
    }
    
    private func setupConstraints() {
        albumTitleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
        }
        
        albumTitleSubLabel.snp.makeConstraints{
            $0.top.equalTo(albumTitleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalToSuperview()
        }
        
        albumCollectionView.snp.makeConstraints{
            $0.top.equalTo(albumTitleSubLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.$exerciseAlbum
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.albumCollectionView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }
}
// MARK: - UICollectionView
extension ExerciseAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseAlbumCell.identifier, for: indexPath) as? ExerciseAlbumCell else {
            return UICollectionViewCell()
        }
        
        let exercisePicture = viewModel.exercisePictures[indexPath.item]
        cell.configure(with: exercisePicture.workoutPicture ?? "", date: exercisePicture.date)
        cell.backgroundColor = .appLightGray
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension ExerciseAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20 // 셀 간 간격
        let availableWidth = collectionView.frame.width - padding
        let width = availableWidth / 2
        return CGSize(width: width, height: width)
    }
}
// MARK: - UICollectionViewDelegate
extension ExerciseAlbumViewController: UICollectionViewDelegate {
    // 스크롤 이벤트 감지
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            loadMoreData()
        }
    }
    
    private func loadMoreData() {
        viewModel.fetchNextPage()
    }
    
    // 이미지 확대
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exercisePicture = viewModel.exercisePictures[indexPath.item]
        guard let imageURLString = exercisePicture.workoutPicture,
              let imageURL = URL(string: imageURLString) else { return }
        let date = exercisePicture.date
        let workoutId = exercisePicture.workoutListId
        
        let imageVC = ExercisePhotoViewController(
            imageURL: imageURL,
            title: date,
            imageId: workoutId,
            viewModel: viewModel
        )
        navigationController?.pushViewController(imageVC, animated: true)
    }
}
