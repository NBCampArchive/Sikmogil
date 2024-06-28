//
//  ExerciseAlbumViewModel.swift
//  Sikmogil
//
//  Created by 정유진 on 6/27/24.
//

import Foundation
import Combine

class ExerciseAlbumViewModel: ObservableObject {
    
    @Published var exerciseAlbum: ExerciseAlbum?
    
    private var currentPage: Int = 0
    private var isFetching = false
    
    var exercisePictures: [ExerciseListModel] {
        return exerciseAlbum?.pictures ?? []
    }
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        // 초기 데이터 가져오기 (필요한 경우)
        getExercisePictures(page: 0)
    }
    
    func getExercisePictures(page: Int) {
        ExerciseAPIManager.shared.getExercisePicture(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let data):
                print("이미지 데이터", data)
                DispatchQueue.main.async {
                    if page == 0 {
                        self.exerciseAlbum = data
                    } else {
                        self.exerciseAlbum?.pictures.append(contentsOf: data.pictures)
                    }
                    self.currentPage = page
                }
            case .failure(let error):
                print("Failed to fetch exercise pictures: \(error)")
            }
        }
    }
}
