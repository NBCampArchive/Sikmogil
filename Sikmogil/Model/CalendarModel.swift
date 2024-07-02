//
//  CalendarModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/12/24.
//

import Foundation

struct CalendarModel: Decodable {
    var diaryDate: String
    var diaryWeight: Int?
    var diaryText: String?
    var dietPicture: CalendarDietPicture?
    var workoutList: CalendarWorkoutList?
}

struct CalendarDietPicture: Decodable {
    var dietPictureId: Int?
    var foodPicture: String?
    var dietDate: String?
}

struct CalendarWorkoutList: Decodable {
    var workoutListId: Int?
    var performedWorkout: String?
    var workoutTime: Int?
    var workoutIntensity: Int?
    var workoutPicture: String?
    var calorieBurned: Int?
}
