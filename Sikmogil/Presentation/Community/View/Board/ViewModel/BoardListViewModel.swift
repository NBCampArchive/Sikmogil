//
//  PostViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/7/24.
//

import Combine
import Foundation

class BoardListViewModel {
    @Published var boardList: [BoardContent] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasMoreData: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 0
    private var totalPages: Int = 1
    
    func fetchBoardList(category: String, page: Int = 0, reset: Bool = false) {
        if reset {
            self.boardList.removeAll()
            self.currentPage = 0
            self.totalPages = 1
            self.hasMoreData = true
        }
        
        guard !isLoading && (page < totalPages) else { return }
        isLoading = true
        BoardAPIManager.shared.fetchBoardList(category: category, page: page)
            .print("fetchBoardList")
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
                self.boardList.append(contentsOf: response.data.boardInfoResDtos.content)
                self.currentPage = response.data.boardInfoResDtos.page.number
                self.totalPages = response.data.boardInfoResDtos.page.totalPages
                self.hasMoreData = self.currentPage < self.totalPages - 1
            })
            .store(in: &cancellables)
    }
    
    func fetchNextPage(category: String) {
        guard hasMoreData else { return }
        fetchBoardList(category: category, page: currentPage + 1)
    }
}
