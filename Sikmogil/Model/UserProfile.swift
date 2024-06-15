//
//  UserProfile.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import Foundation

struct UserResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: UserProfile
}

struct UserProfile: Decodable {
    var nickname: String
    var height: String
    var weight: String
    var gender: String
    var targetWeight: String
    var targetDate: String
    var canEatCalorie: Int?
    var createdDate: String
    var reminderTime: String?
}
