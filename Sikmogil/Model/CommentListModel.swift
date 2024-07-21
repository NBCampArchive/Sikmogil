//
//  CommentListModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/21/24.
//

import Foundation

struct CommentResponse: Codable {
    let statusCode: Int
    let message: String
    let data: CommentData
}

struct CommentData: Codable {
    let commentInfoResDtos: CommentPage
}

struct CommentPage: Codable {
    let content: [CommentInfo]
    let page: PageInfo
}

struct CommentInfo: Codable {
    let commentId: Int
    let content: String
    let writerNickname: String
    let writerProfileImage: String?
    let createdAt: String
}

struct PageInfo: Codable {
    let size: Int
    let number: Int
    let totalElements: Int
    let totalPages: Int
}
