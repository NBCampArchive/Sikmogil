//
//  PostViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/7/24.
//

import Combine
import Foundation

class BoardListViewModel: ObservableObject {
    @Published var boardList: [BoardContent] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchBoardList(category: String, page: Int = 0) {
        isLoading = true
        BoardAPIManager.shared.fetchBoardList(category: category, page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                self.boardList = response.data.boardInfoResDtos.content
            })
            .store(in: &cancellables)
    }
}

