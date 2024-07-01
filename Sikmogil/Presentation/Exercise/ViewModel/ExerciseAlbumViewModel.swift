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
    private var itemPerPage = 10
    
    var exercisePictures: [ExerciseListModel] {
        return exerciseAlbum?.pictures ?? []
    }
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        // 초기 데이터 가져오기 (필요한 경우)
        getExercisePictures(page: currentPage)
    }
    
    func getExercisePictures(page: Int) {
        guard !isFetching else { return }
        isFetching = true
        
        ExerciseAPIManager.shared.getExercisePicture(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let data):
                print("이미지 데이터 fetch 성공")
                DispatchQueue.main.async {
                    if page == 0 {
                        self.exerciseAlbum = data
                    } else {
                        self.exerciseAlbum?.pictures.append(contentsOf: data.pictures)
                    }
                    self.currentPage = page
                    
                    // 데이터가 10개 미만이면 더 이상 페이지네이션하지 않음
                    if data.pictures.count < self.itemPerPage {
                        self.isFetching = true // 다음 페이지 요청을 막음
                    }
                }
            case .failure(let error):
                print("운동 이미지 fetch 실패: \(error)")
            }
        }
    }
    
    func fetchNextPage() {
        guard let exerciseAlbum = exerciseAlbum, !isFetching else { return }
        let nextPage = currentPage + 1
        getExercisePictures(page: nextPage)
    }
}
