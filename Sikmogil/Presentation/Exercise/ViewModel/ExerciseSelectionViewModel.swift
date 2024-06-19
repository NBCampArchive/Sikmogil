//
//  ExerciseSelectionViewModel.swift
//  Sikmogil
//
//  Created by 정유진 on 6/16/24.
//

import Foundation
import Combine

class ExerciseSelectionViewModel {
    
    @Published var selectedExercise: String?
    @Published var selectedTime: String?
    @Published var selectedIntensity: Int?
    @Published var expectedCalories: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Publishers.CombineLatest3($selectedExercise, $selectedTime, $selectedIntensity)
            .sink { [weak self] exercise, time, intensity in
                self?.updateExpectedCalories(exercise: exercise, time: time, intensity: intensity)
            }
            .store(in: &cancellables)
    }
    
    private func updateExpectedCalories(exercise: String?, time: String?, intensity: Int?) {
        guard let exercise = exercise, let time = time, let intensity = intensity else {
            expectedCalories = 0
            return
        }
        expectedCalories = calculateCalories(exercise: exercise, time: time, intensity: intensity)
    }
    
    private func calculateCalories(exercise: String, time: String, intensity: Int) -> Int {
        // 운동에 대한 분당 소모 칼로리
        let caloriesPerMinute: [String: Int] = [
            "런닝": 10,
            "수영": 8,
            "자전거": 7,
            "등산": 9,
            "걷기": 4,
            "요가": 3,
            "줄넘기": 11,
            "필라테스": 4,
            "웨이트 트레이닝": 6,
            "복합 유산소 운동": 10,
            "고강도 인터벌 트레이닝": 13,
            "근력 강화 운동": 8,
            "기타": 5
        ]
        
        let timeInMinutes = Int(time.dropLast(1)) ?? 0
        
        let intensityMultiplier: [Int: Double] = [
            0: 0.75,
            1: 1.0,
            2: 1.25
        ]
        
        let baseCalories = caloriesPerMinute[exercise] ?? 0
        let multiplier = intensityMultiplier[intensity] ?? 1.0
        let totalCalories = Double(baseCalories) * Double(timeInMinutes) * multiplier
        
        return Int(totalCalories)
    }
    
    func saveExerciseData() -> ExerciseListModel {
        return ExerciseListModel(
            workoutListId: 0,
            performedWorkout: selectedExercise ?? "",
            workoutTime: Int(selectedTime?.dropLast(1) ?? "0") ?? 0, // ex) "30분" -> 30
            workoutIntensity: selectedIntensity ?? 0,
            workoutPicture: "",
            calorieBurned: expectedCalories
        )
    }
}
