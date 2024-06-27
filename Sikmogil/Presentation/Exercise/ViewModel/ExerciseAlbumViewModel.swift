//
//  ExerciseAlbumViewModel.swift
//  Sikmogil
//
//  Created by 정유진 on 6/27/24.
//

import Foundation
import Combine

class ExerciseAlbumViewModel: ObservableObject {
    
    @Published var exercisePictures: [ExerciseListModel] = []
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getExercisePictures()
    }
    
    func getExercisePictures() {
        ExerciseAPIManager.shared.getExercisePicture { [weak self] result in
            switch result {
            case .success(let data):
                print("이미지 데이터", data)
                DispatchQueue.main.async {
                    self?.exercisePictures = data
                }
            case .failure(let error):
                print("Failed to fetch exercise pictures: \(error)")
            }
        }
    }
}
