//
//  BoardListResponseModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/1/24.
//

import Foundation

// MARK: - BoardListResponse
struct BoardListResponse: Codable {
    let statusCode: Int
    let message: String
    let data: BoardData
}

// MARK: - BoardData
struct BoardData: Codable {
    let boardInfoResDtos: BoardInfoResDtos
}

// MARK: - BoardInfoResDtos
struct BoardInfoResDtos: Codable {
    let content: [BoardContent]
    let page: Page
}

// MARK: - Page
struct Page: Codable {
    let size: Int
    let number: Int
    let totalElements: Int
    let totalPages: Int
}

// MARK: - BoardContent
struct BoardContent: Codable {
    let myMemberId, writerMemberId, boardId: Int
    let category, title, content: String
    let imageUrl: [String]
    let likeCount: Int
    let isLike: Bool
    let commentCount: Int
    let nickname, date: String
    let comments: [Comment]?
}

// MARK: - Comment
struct Comment: Codable {
    let writerProfileImage: String
    let writerMemberId, commentId: Int
    let content: String
}
