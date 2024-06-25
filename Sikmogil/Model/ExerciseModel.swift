//
//  ExerciseModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/9/24.
//

import Foundation

// MARK: - 특정 날짜 운동 총량
struct ExerciseModel: Decodable {
    let canEatCalorie: Int?
    let workoutDate: String?
    let steps: Int?
    let totalCaloriesBurned: Int?
}

// MARK: - 특정 날짜 운동 리스트
struct ExerciseListModel: Decodable {
    let workoutListId: Int
    let performedWorkout: String
    let workoutTime: Int
    let workoutIntensity: Int
    let workoutPicture: String?
    let calorieBurned: Int
}
