//
//  DietListModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/11/24.
//

import Foundation

struct DietLog: Decodable {
    var waterIntake: Int
    var totalCalorieEaten: Int
    var dietDate: String
    var canEatCalorie: Int?
}

struct DietList: Decodable {
    var dietListId: Int
    var calorie: Int
    var foodName: String
    var mealTime: String
}

struct DietPicture: Decodable {
    var dietPictureId: Int
    var foodPicture: String
    var dietDate: String
}
