//
//  UserAPIManager.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/6/24.
//

import Foundation
import Alamofire
import KeychainSwift

class UserAPIManager {
    
    static let shared = UserAPIManager()
    
    let baseURL = Bundle.main.baseURL
    
    private init() {}
    
    func userProfileUpdate(userProfile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let url = "\(baseURL)/api/members/onboarding"
        
        let accessToken = KeychainSwift().get("accessToken") ?? ""
        
        print("accessToken \(accessToken)")
        print("\(userProfile)")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "nickname": userProfile.nickname,
            "height": userProfile.height,
            "weight": userProfile.weight,
            "gender": userProfile.gender,
            "targetWeight": userProfile.targetWeight,
            "targetDate": userProfile.targetDate,
            "createdDate": userProfile.toDate
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    print("프로필 업데이트 에러")
                    completion(.failure(error))
                }
            }
    }
}
