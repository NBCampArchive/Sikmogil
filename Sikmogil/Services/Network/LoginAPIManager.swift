//
//  LoginAPIManager.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/4/24.
//

import Foundation
import Alamofire
import KeychainSwift

class LoginAPIManager{
    
    static let shared = LoginAPIManager()
    
    let keychain = KeychainSwift()
    
    let baseURL = Bundle.main.baseURL
    
    private init() {}
    
    func getAccessToken(authCode: String?, provider: String, completion: @escaping (Result<LoginModel, Error>) -> Void){
        let url = "\(baseURL)/api/\(provider)/token"
        // Body 설정
        let parameters: Parameters = [
            "authCode" : authCode!,
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: LoginModel.self) { response in
                switch response.result {
                case .success(let tokenResponse):
                    self.keychain.set(tokenResponse.data.accessToken, forKey: "accessToken")
                    self.keychain.set(tokenResponse.data.refreshToken, forKey: "refreshToken")
                    completion(.success(tokenResponse))
                case .failure(let error):
                    print("로그인 요청 에러")
                    completion(.failure(error))
                }
            }
    }
}
