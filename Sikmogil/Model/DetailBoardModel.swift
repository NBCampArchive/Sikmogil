//
//  DetailBoardModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/21/24.
//

import Foundation

// MARK: - BoardDetailModel
struct BoardDetailModel: Codable {
    let statusCode: Int
    let message: String
    let data: BoardDetailData
}

// MARK: - BoardDetailData
struct BoardDetailData: Codable {
    let myMemberId: Int
    let writerMemberId: Int
    let boardId: Int
    let category: Category
    let title: String
    let content: String
    let imageUrl: [String]
    let likeCount: Int
    let isLike: Bool
    let commentCount: Int
    let nickname: String
    let date: String
}

// MARK: - Category
enum Category: String, Codable {
    case diet = "DIET"
    case workout = "WORKOUT"
    case free = "FREE"
}

// 임시 데이터 생성을 위한 extension
extension BoardDetailData {
    static func mockData() -> BoardDetailData {
        return BoardDetailData(
            myMemberId: 1,
            writerMemberId: 2,
            boardId: 100,
            category: .diet,
            title: "2024 시크모길 여름 다이어트 챌린지",
            content: "올 여름 함께 건강해지는 시간 가져볼까요?",
            imageUrl: ["https://example.com/image1.jpg", "https://example.com/image2.jpg"],
            likeCount: 15,
            isLike: false,
            commentCount: 3,
            nickname: "건강지킴이",
            date: "2024-07-18T10:30:00Z"
        )
    }
}
