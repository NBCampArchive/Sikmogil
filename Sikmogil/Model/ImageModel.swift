//
//  ImageTestModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/12/24.
//

import Foundation

struct ImageModel: Decodable {
    var statusCode: Int
    var message: String
    var data: [String]
}
