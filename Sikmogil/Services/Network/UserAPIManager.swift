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
    
    let token = "Bearer \(LoginAPIManager.shared.getAccessTokenFromKeychain())"
    
    private var headers: HTTPHeaders {
        return [
            "Authorization": token,
            "Accept": "application/json"
        ]
    }
    
    //MARK: - 사용자 프로필 내용 업데이트 (온보딩, 프로필 수정)
    func userProfileUpdate(userProfile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let url = "\(baseURL)/api/members/onboarding"
        
        let parameters: [String: Any] = [
            "nickname": userProfile.nickname,
            "height": userProfile.height,
            "weight": userProfile.weight,
            "gender": userProfile.gender,
            "targetWeight": userProfile.targetWeight,
            "targetDate": userProfile.targetDate,
            "createdDate": userProfile.createdDate,
            "canEatCalorie": userProfile.canEatCalorie,
            "remindTime": userProfile.remindTime
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    print("프로필 업데이트 에러")
                    if let responseCode = error.responseCode, responseCode == 401 {
                        // 401 Unauthorized - Access token expired
                        LoginAPIManager.shared.refreshToken { result in
                            switch result {
                            case .success:
                                // 토큰 갱신 성공 후 다시 요청
                                self.userProfileUpdate(userProfile: userProfile, completion: completion)
                            case .failure(let refreshError):
                                completion(.failure(refreshError))
                            }
                        }
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    //MARK: - 사용자 정보 출력
    func getUserInfo(completion: @escaping (Result<UserResponse, Error>) -> Void) {
        
        let url = "\(baseURL)/api/members/getMember"
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                switch response.result {
                case .success(let userProfile):
                    completion(.success(userProfile))
                case .failure(let error):
                    print(self.token)
                    print("getUserInfo error\(error.localizedDescription)")
                    if let responseCode = error.responseCode, responseCode == 401 {
                        // 401 Unauthorized - Access token expired
                        LoginAPIManager.shared.refreshToken { result in
                            switch result {
                            case .success:
                                // 토큰 갱신 성공 후 다시 요청
                                self.getUserInfo(completion: completion)
                            case .failure(let refreshError):
                                completion(.failure(refreshError))
                            }
                        }
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
}
