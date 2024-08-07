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
    let date: String
    let workoutListId: Int
    let performedWorkout: String
    let workoutTime: Int
    let workoutIntensity: Int
    var workoutPicture: String?
    let calorieBurned: Int
}

extension ExerciseListModel: Equatable {}

// MARK: - 운동 사진 출력
struct ExerciseAlbum: Decodable {
    var lastPage: Int
    var pictures: [ExerciseListModel]
    
    mutating func deleteExercise(for id: Int, and date: String) {
        pictures.removeAll { $0.workoutListId == id && $0.date == date }
    }
}
