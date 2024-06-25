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
    
    init() {
        // 저장된 이미지 데이터를 불러와서 savedDietImages에 할당
        if let savedImagesData = UserDefaults.standard.data(forKey: "dietImages") {
            let decoder = JSONDecoder()
            if let decodedImages = try? decoder.decode([SavedDietImage].self, from: savedImagesData) {
                savedDietImages = decodedImages
            }
        }
    }
    
    func saveImage(_ image: UIImage) {
        if let imageData = image.pngData() {
            let savedImage = SavedDietImage(imageData: imageData, dateSaved: Date())
            savedDietImages.append(savedImage)
            
            // 갱신된 이미지 데이터를 UserDefaults에 저장
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(savedDietImages) {
                UserDefaults.standard.set(encodedData, forKey: "dietImages")
            }
        }
    }
    
    func loadImages() {
        if let savedImagesData = UserDefaults.standard.data(forKey: "dietImages") {
            let decoder = JSONDecoder()
            if let decodedImages = try? decoder.decode([SavedDietImage].self, from: savedImagesData) {
                savedDietImages = decodedImages
            }
        }
    }
    
    func deleteImage(at index: Int) {
        savedDietImages.remove(at: index)
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(savedDietImages) {
            UserDefaults.standard.set(encodedData, forKey: "dietImages")
        }
    }
}
