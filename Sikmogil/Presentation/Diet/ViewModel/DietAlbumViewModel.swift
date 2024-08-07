//
//  DietAlbumViewModel.swift
//  Sikmogil
//
//  Created by 희라 on 6/11/24.
//  [ViewModel] **설명** 다이어트 앨범 뷰모델

import Foundation
import UIKit


class DietAlbumViewModel {
    var savedDietImages: [SavedDietImage] = []
    var lastPage: Int = 0
    var currentPage: Int = 0
    var isLoading = false
    
    init() {
    }
    
    func saveImage(_ image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        if let imageData = image.pngData() {
            let images = [image]
            ImageAPIManager.shared.uploadImage(directory: "diet", images: images) { result in
                switch result {
                case .success(let data):
                    var imageURL = data.data
                    print("uploadImage success \(imageURL)")
                    DietAPIManager.shared.addDietPicture(date: DateHelper.shared.formatDateToYearMonthDay(Date()), pictureData: imageURL[0]) { result in
                        switch result {
                        case .success:
                            print("uploadDietImage success")
                            self.loadImages(page: 0) { // reload the first page
                                completion(.success(()))
                            }
                        case .failure(let error):
                            print("failure \(error)")
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    print("uploadImage failure \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadImages(page: Int, completion: @escaping () -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        DietAPIManager.shared.getDietPicture(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let album):
                if page == 0 {
                    self.savedDietImages = []
                }
                self.lastPage = album.lastPage
                self.currentPage = page + 1
                
                DispatchQueue.global().async {
                    var newImages: [SavedDietImage] = []
                    for dietPicture in album.pictures {
                        if let imageUrl = URL(string: dietPicture.foodPicture),
                           let imageData = try? Data(contentsOf: imageUrl) {
                            let savedImage = SavedDietImage(dietPictureId: dietPicture.dietPictureId,
                                                            foodPicture: imageData,
                                                            dietDate: dietPicture.dietDate)
                            newImages.append(savedImage)
                        }
                    }
                    DispatchQueue.main.async {
                        self.savedDietImages.append(contentsOf: newImages)
                        completion()
                    }
                }
                
            case .failure(let error):
                print("loadImages failure \(error)")
            }
        }
    }
    
    func loadMoreImages(completion: @escaping () -> Void) {
        if currentPage < lastPage {
            loadImages(page: currentPage, completion: completion)
        }
    }
    
    func deleteImage(at index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard index < savedDietImages.count else {
            completion(.failure(NSError(domain: "DietAlbumViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Index out of bounds"])))
            return
        }
        
        let dietImage = savedDietImages[index]
        let date = dietImage.dietDate
        let dietPictureId = dietImage.dietPictureId // 저장된 이미지의 ID (API에서 사용할 수 있는 식별자)
        
        //print("Deleting diet picture with date: \(date), dietPictureId: \(dietPictureId)")
        
        DietAPIManager.shared.deleteDietPicture(date: date, dietPictureId: dietPictureId) { result in
            switch result {
            case .success:
                print("deleteDietPicture success")
                DispatchQueue.main.async {
                    self.savedDietImages.remove(at: index)
                    completion(.success(()))
                }
            case .failure(let error):
                print("deleteDietPicture failure \(error)")
                completion(.failure(error))
            }
        }
    }
}
