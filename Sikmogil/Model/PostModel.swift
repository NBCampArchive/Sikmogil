//
//  BoadModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/2/24.
//

import Foundation

struct PostModel: Decodable {
    var title: String
    var category: String
    var content: String
    var imageUrl: [String]?
}
