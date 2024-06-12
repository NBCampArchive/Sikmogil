//
//  UserProfileDummy.swift
//  Sikmogil
//
//  Created by Developer_P on 6/12/24.
//

import Foundation

struct UserProfileDummy {
    static let shared = UserProfile(
        nickname: "Cats Green",
        height: "170",
        weight: "65",
        gender: "남자",
        targetWeight: "60",
        toDate: "2024-06-12",
        targetDate: "2024-12-12",
        reminderTime: "09:00"
    )
}
