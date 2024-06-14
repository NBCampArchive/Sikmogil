//
//  UserProfile.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import Foundation

struct UserProfile: Decodable {
    var nickname: String
    var height: String
    var weight: String
    var gender: String
    var targetWeight: String
    var toDate: String
    var targetDate: String
    var reminderTime: String
    var canEatCalorie: Int
}

