//
//  BoadModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/2/24.
//

import Foundation

struct PostModel: Codable {
    var title: String
    var category: String
    var content: String
    var imageUrl: String
}

// 응답 데이터 모델
struct PostResponse: Decodable {
    var statusCode: Int
    var message: String
    var data: String
}
