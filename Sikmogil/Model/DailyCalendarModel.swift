//
//  DailyCalendarModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/3/24.
//

import Foundation

struct DailyCalendarModel: Decodable {
    var diaryDate: String
    var diaryWeight: Int?
    var diaryText: String?
    var canEatCalorie: Int?
    var waterIntake: Int?
    var totalCalorieEaten: Int?
    var dietPictureDTOS: [DailyDietPicture]?
    var workoutLists: [DailyWorkoutList]?
}

struct DailyDietPicture: Decodable {
    var date: String?
    var dietPictureId: Int?
    var foodPicture: String?
    var dietDate: String?
}

struct DailyWorkoutList: Decodable {
    var date: String?
    var workoutListId: Int?
    var performedWorkout: String?
    var workoutTime: Int?
    var workoutIntensity: Int?
    var workoutPicture: String?
    var calorieBurned: Int?
}
