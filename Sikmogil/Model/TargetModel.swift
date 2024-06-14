//
//  TargetModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/14/24.
//

import Foundation

struct TargetModel: Decodable {
    let createDate: String
    let targetDate: String
    let targetWeight: String
    let weight: String
    let weekWeights: [WeekWeight]
}

struct WeekWeight: Decodable {
    let date: String
    let weight: Double
}
