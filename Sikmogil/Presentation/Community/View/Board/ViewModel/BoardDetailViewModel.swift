//
//  BoardDetailViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/18/24.
//

import Foundation
import Combine

class BoardDetailViewModel {
    @Published private(set) var boardDetail: BoardDetailData?
    @Published private(set) var localLikeCount: Int = 0
    @Published private(set) var isLikedLocally: Bool = false
    
    init() {
        loadBoardDetail()
    }
    
    func loadBoardDetail() {
        // 실제 API 호출 대신 임시 데이터 사용
        let detail = BoardDetailData.mockData()
        self.boardDetail = detail
        self.localLikeCount = detail.likeCount
        self.isLikedLocally = detail.isLike
    }
    
    func toggleLike() {
        isLikedLocally.toggle()
        localLikeCount += isLikedLocally ? 1 : -1
        
        // API 호출
//        toggleLike(for: boardDetail?.boardId ?? 0)
        
        print("좋아요 상태 변경 (로컬): isLike = \(isLikedLocally), likeCount = \(localLikeCount)")
    }
    
    func reportPost(boardId: Int, reason: String) {
        // 여기에 실제 API 호출 로직 구현
        // 예: API.reportPost(boardId: boardDetail?.boardId)
        //     .sink(receiveCompletion: { ... }, receiveValue: { ... })
        //     .store(in: &cancellables)
    }
    
    
    
    func deletePost(boardId: Int) {
        // 여기에 실제 API 호출 로직 구현
        // 예: API.deletePost(boardId: boardDetail?.boardId)
        //     .sink(receiveCompletion: { ... }, receiveValue: { ... })
        //     .store(in: &cancellables)
    }
    
}
