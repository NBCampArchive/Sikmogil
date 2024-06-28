//
//  SavedDietImage.swift
//  Sikmogil
//
//  Created by 희라 on 6/12/24.
//  다이어트 앨범 컬렉션뷰 호출 모델

import Foundation

struct SavedDietImage: Codable {
    var dietPictureId: Int
    var foodPicture: Data
    var dietDate: String
}
