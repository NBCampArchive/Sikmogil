//
//  ExerciseViewModel.swift
//  Sikmogil
//
//  Created by 정유진 on 6/12/24.
//

import Foundation
import Combine

class ExerciseViewModel: ObservableObject {
    
    @Published var exerciseData: [ExerciseModel] = []
    @Published var exerciseList: [ExerciseListModel] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchAllExerciseData() {
        ExerciseAPIManager.shared.getAllExerciseData { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.exerciseData = data
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchExerciseData(for date: String) {
        ExerciseAPIManager.shared.getExerciseData(exerciseDay: date) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.exerciseData = [data]
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchExerciseList(for date: String) {
        ExerciseAPIManager.shared.getExerciseList(exerciseDay: date) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.exerciseList = data
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
