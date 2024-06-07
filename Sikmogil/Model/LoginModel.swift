//
//  LoginModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/4/24.
//

import Foundation

// MARK: - TokenResponse
struct LoginModel: Decodable {
    let statusCode: Int
    let message: String
    let data: TokenData
}

// MARK: - TokenData
struct TokenData: Decodable {
    let accessToken: String
    let refreshToken: String
}
