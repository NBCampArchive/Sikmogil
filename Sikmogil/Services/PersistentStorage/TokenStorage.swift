//
//  TokenStorage.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/27/24.
//

import Foundation
import KeychainSwift

class TokenStorage {
    static let shared = TokenStorage()
    private let keychain = KeychainSwift()
    
    var accessToken: String? {
        return keychain.get("accessToken")
    }
    
    var refreshToken: String? {
        return keychain.get("refreshToken")
    }
    
    func setTokens(accessToken: String, refreshToken: String) {
        keychain.set(accessToken, forKey: "accessToken")
        keychain.set(refreshToken, forKey: "refreshToken")
    }
    
    func clearTokens() {
        keychain.delete("accessToken")
        keychain.delete("refreshToken")
    }
}

