//
//  ExerciseSelectionViewModel.swift
//  Sikmogil
//
//  Created by 정유진 on 6/16/24.
//

import Foundation
import UIKit
import Combine

class ExerciseSelectionViewModel {
    
    @Published var selectedExercise: String?
    @Published var selectedTime: String?
    @Published var selectedIntensity: Int?
    @Published var expectedCalories: Int = 0
    @Published var selectedImageView: UIImage?
    @Published var uploadedImageURL: String?
    
    private var cancellables = Set<AnyCancellable>()
    let day = DateHelper.shared.formatDateToYearMonthDay(Date())
    
    let exerciseIconMapping: [String: String] = [
        "런닝": "runningIcon",
        "수영": "swimmingIcon",
        "자전거": "bicycleIcon",
        "등산": "hikingIcon",
        "걷기": "walkingIcon",
        "요가": "yogaIcon",
        "줄넘기": "jumpingIcon",
        "필라테스": "pilatesIcon",
        "웨이트 트레이닝": "weightIcon",
        "복합 유산소 운동": "aerobicsIcon",
        "고강도 인터벌 트레이닝": "HIITIcon",
        "근력 강화 운동": "strengthIcon",
        "기타": "exerciseIcon"
    ]

    func iconName(for exercise: String) -> String {
        return exerciseIconMapping[exercise] ?? "exerciseIcon"
    }
    
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
            date: day,
            workoutListId: 0,
            performedWorkout: selectedExercise ?? "",
            workoutTime: Int(selectedTime?.dropLast(1) ?? "0") ?? 0, // ex) "30분" -> 30
            workoutIntensity: selectedIntensity ?? 0,
            workoutPicture: uploadedImageURL ?? "",
            calorieBurned: expectedCalories
        )
    }
    
    // 이미지 업로드 메서드
    func uploadExerciseImage(image: UIImage, directory: String, completion: @escaping (Result<String, Error>) -> Void) {
        ImageAPIManager.shared.uploadImage(directory: directory, images: [image]) { result in
            switch result {
            case .success(let imageModel):
                if let firstImageUrl = imageModel.data.first {
                    completion(.success(firstImageUrl)) // 첫 번째 이미지의 URL 반환
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 운동 리스트 데이터 추가 메서드
    func addExerciseListData(exerciseList: ExerciseListModel, completion: @escaping (Result<Void, Error>) -> Void) {
        ExerciseAPIManager.shared.addExerciseListData(exerciseDay: day, exerciseList: exerciseList) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
