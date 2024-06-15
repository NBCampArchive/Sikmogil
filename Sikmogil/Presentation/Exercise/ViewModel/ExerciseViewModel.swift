//
//  ExerciseViewModel.swift
//  Sikmogil
//
//  Created by 정유진 on 6/12/24.
//

import Foundation
import Combine

class ExerciseViewModel {
    
    @Published var exercises: [ExerciseListModel] = []
    @Published var totalWorkoutTime: Int = 0
    @Published var totalCaloriesBurned: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchExerciseList(for day: String) {
        ExerciseAPIManager.shared.getExerciseList(exerciseDay: day) { [weak self] result in
            switch result {
            case .success(let exercises):
                DispatchQueue.main.async {
                    self?.exercises = exercises
                    self?.updateTotals()
                }
            case .failure(let error):
                print("운동 데이터 불러오기 실패: \(error)")
            }
        }
    }
    
    private func updateTotals() {
        totalWorkoutTime = exercises.reduce(0) { $0 + $1.workoutTime }
        totalCaloriesBurned = exercises.reduce(0) { $0 + $1.calorieBurned }
    }
}
