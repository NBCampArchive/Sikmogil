//
//  DietAlbumViewController.swift
//  Sikmogil
//
//  Created by 희라 on 6/5/24.
//  [View] **설명** 식단 앨범

import UIKit
import SnapKit
import Then

class DietAlbumViewController: UIViewController {

    let AlbumTitleLabel = UILabel().then {
        $0.text = "식단 앨범"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 28)
        $0.textAlignment = .left
    }
    let AlbumTitleSubLabel = UILabel().then {
        $0.text = "먹은 음식을 사진으로 기록해보세요!"
        $0.textColor = .appDarkGray
        $0.font = Suite.semiBold.of(size: 14)
        $0.textAlignment = .left
    }
    let albumAddPhotoButton = UIButton().then {
        $0.setTitle("사진 기록하기", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)

        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
    }
    
    let AlbumcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        
        view.backgroundColor = .white
        
        AlbumcollectionView.delegate = self
        AlbumcollectionView.dataSource = self
        
        AlbumcollectionView.register(DietAlbumCollectionViewCell.self, forCellWithReuseIdentifier: DietAlbumCollectionViewCell.identifier)
    }
    

    private func setupViews() {
        view.addSubviews(AlbumTitleLabel, AlbumTitleSubLabel, AlbumcollectionView, albumAddPhotoButton)
    }
    
    private func setupConstraints() {
        AlbumTitleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
        }
        AlbumTitleSubLabel.snp.makeConstraints{
            $0.top.equalTo(AlbumTitleLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalToSuperview()
        }
        AlbumcollectionView.snp.makeConstraints{
            $0.top.equalTo(AlbumTitleSubLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        albumAddPhotoButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
    }
}


extension DietAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DietAlbumCollectionViewCell.identifier, for: indexPath) as! DietAlbumCollectionViewCell
        cell.backgroundColor = .appLightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingSpace = 8 * (itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
