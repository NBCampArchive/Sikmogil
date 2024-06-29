//
//  UserAPIManager.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/6/24.
//

import Foundation
import Alamofire
import KeychainSwift
import UIKit

class UserAPIManager {
    
    static let shared = UserAPIManager()
    
    let baseURL = Bundle.main.baseURL
    
    private init() {}
    
    private let session: Session = {
        let interceptor = AuthInterceptor()
        return Session(interceptor: interceptor)
    }()
    
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
        
        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
        
        session.request(url, method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                switch response.result {
                case .success(let userProfile):
                    completion(.success(userProfile))
                case .failure(let error):
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
    
    //MARK: - 닉네임 중복 확인
    func checkNickname(nickname: String, completion: @escaping (Result<CheckNickname, Error>) -> Void) {
        
        let url = "\(baseURL)/api/members/nickname"
        
        let parameters: [String: Any] = [
            "nickname": nickname
        ]
        
        session.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: CheckNickname.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    print("닉네임 중복 확인 에러")
                }
            }
    }
    
    //MARK: - 회원 탈퇴
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        
        let url = "\(baseURL)/api/my/delete-account"
        
        session.request(url, method: .post, encoding: JSONEncoding.default).validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    print("회원 탈퇴 에러\(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
}
