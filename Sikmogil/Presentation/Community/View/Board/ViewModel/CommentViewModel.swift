//
//  CommentViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/21/24.
//

import Foundation
import Combine

class CommentViewModel {
    @Published var comments: [CommentInfo] = []
    @Published var pageInfo: PageInfo?
    
    func fetchComments() {
        // 더미 데이터로 테스트
        let dummyComments = [
            CommentInfo(commentId: 1, content: "좋은 글이네요!", writerNickname: "사용자1", writerProfileImage: nil, createdAt: "2024-07-12T16:32:44.937042368"),
            CommentInfo(commentId: 2, content: "저도 같은 생각입니다.", writerNickname: "사용자2", writerProfileImage: nil, createdAt: "2024-07-12T16:32:44.937042368")
        ]
        
        let dummyPageInfo = PageInfo(size: 10, number: 0, totalElements: 2, totalPages: 1)
        
        self.comments = dummyComments
        self.pageInfo = dummyPageInfo
    }
}
