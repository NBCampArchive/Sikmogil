//
//  ExerciseViewModel.swift
//  Sikmogil
//
//  Created by 정유진 on 6/12/24.
//

import Foundation

class ExerciseViewModel {
    
    // 운동 데이터
    var exerciseData: ExerciseModel?
    
    // 운동 리스트 데이터
    var exerciseList: [ExerciseListModel] = []
    
    // 사용자가 선택한 운동 리스트
    var selectedExerciseList: [ExerciseListModel] = []
    
    // API Manager
    let exerciseAPIManager = ExerciseAPIManager.shared
    
    // MARK: - Fetch Data
    
    func fetchExerciseData(for exerciseDay: String, completion: @escaping (Result<Void, Error>) -> Void) {
        exerciseAPIManager.getExerciseData(exerciseDay: exerciseDay) { result in
            switch result {
            case .success(let data):
                self.exerciseData = data
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchExerciseList(for exerciseDay: String, completion: @escaping (Result<Void, Error>) -> Void) {
        exerciseAPIManager.getExerciseList(exerciseDay: exerciseDay) { result in
            switch result {
            case .success(let data):
                self.exerciseList = data
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Update Data
    
    func updateExerciseData(exerciseDay: String, steps: Int, totalCaloriesBurned: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        exerciseAPIManager.updateExerciseData(exerciseDay: exerciseDay, steps: steps, totalCaloriesBurned: totalCaloriesBurned) { result in
            switch result {
            case .success:
                // Update local exercise data or refresh if necessary
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addExerciseListData(exerciseDay: String, exerciseList: ExerciseListModel, completion: @escaping (Result<Void, Error>) -> Void) {
        exerciseAPIManager.addExerciseListData(exerciseDay: exerciseDay, exerciseList: exerciseList) { result in
            switch result {
            case .success:
                // Update local exercise list or refresh if necessary
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteExerciseListData(exerciseDay: String, exerciseListId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        exerciseAPIManager.deleteExerciseListData(exerciseDay: exerciseDay, exerciseListId: exerciseListId) { result in
            switch result {
            case .success:
                // Update local exercise list or refresh if necessary
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
