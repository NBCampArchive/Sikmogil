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
    let totalPages: Int
    let totalElements: Int
    let pageable: Pageable
    let size: Int
    let content: [BoardContent]
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let first, last, empty: Bool
}

// MARK: - Pageable
struct Pageable: Codable {
    let paged: Bool
    let pageNumber, pageSize, offset: Int
    let sort: Sort
    let unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let sorted, empty, unsorted: Bool
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
    let comments: [Comment]
}

// MARK: - Comment
struct Comment: Codable {
    let writerProfileImage: String
    let writerMemberId, commentId: Int
    let content: String
}
