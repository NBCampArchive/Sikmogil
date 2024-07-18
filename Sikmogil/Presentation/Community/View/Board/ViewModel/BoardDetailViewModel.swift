//
//  BoardDetailViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/18/24.
//

import Foundation
import Combine

class BoardDetailViewModel {
    @Published var boardDetail: BoardDetail?
    
    init() {
        loadBoardDetail()
    }
    
    func loadBoardDetail() {
        // 임시 데이터로 초기화
        boardDetail = BoardDetail(
            id: "1",
            title: "2024 시크모길 여름 행사 안내",
            author: "관리자",
            date: "2024.07.18",
            likeCount: 10,
            commentCount: 5,
            isLiked: false
        )
    }
    
    func toggleLike() {
        guard var detail = boardDetail else { return }
        detail.isLiked.toggle()
        detail.likeCount += detail.isLiked ? 1 : -1
        boardDetail = detail
        
        // 실제 API 호출 대신 콘솔에 로그 출력
        print("좋아요 상태 변경: isLiked = \(detail.isLiked), likeCount = \(detail.likeCount)")
    }
}

struct BoardDetail {
    let id: String
    let title: String
    let author: String
    let date: String
    var likeCount: Int
    var commentCount: Int
    var isLiked: Bool
}
