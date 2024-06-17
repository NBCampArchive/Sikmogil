//
//  ProfileAPIManager.swift
//  Sikmogil
//
//  Created by Developer_P on 6/17/24.
//

import Foundation
import Combine
import Alamofire

class ProfileAPIManager {
    static let shared = ProfileAPIManager()
    
    private let baseURL = Bundle.main.baseURL
    private let token = "Bearer \(LoginAPIManager.shared.getAccessTokenFromKeychain())"
    
    // Combine의 AnyCancellable 인스턴스를 저장할 집합
    private var cancellables = Set<AnyCancellable>()
    
    // HTTP 요청 하면 사용할 헤더를 정의해주는데
    private var headers: HTTPHeaders {
        return [
            "Authorization": token,
            "Accept": "application/json"
        ]
    }
    
    // 사용자 정보를 가져오는 함수
    func getUserInfo() -> AnyPublisher<UserResponse, Error> {
        let url = "\(baseURL)/api/members/getMember"
        
        return Future<UserResponse, Error> { [weak self] promise in
            guard let self = self else { return }
            
            // Alamofire를 사용하여 GET 요청을 보냄
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: self.headers)
                .validate()
                .responseDecodable(of: UserResponse.self) { response in
                    switch response.result {
                    case .success(let userResponse):
                        promise(.success(userResponse))
                    case .failure(let error):
                        if let responseCode = error.responseCode, responseCode == 401 {
                            LoginAPIManager.shared.refreshToken { result in
                                switch result {
                                case .success:
                                    self.getUserInfo()
                                        .sink(receiveCompletion: { _ in }, receiveValue: { userResponse in
                                            promise(.success(userResponse))
                                        })
                                        .store(in: &self.cancellables)
                                case .failure(let refreshError):
                                    promise(.failure(refreshError))
                                }
                            }
                        } else {
                            promise(.failure(error))
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    // 사용자 프로필을 업데이트하는 함수
    func userProfileUpdate(userProfile: UserProfile) -> Future<Void, Error> {
        let url = "\(baseURL)/api/members/onboarding"
        
        // 사용자 프로필 정보를 파라미터로 설정
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
        
        // Future를 반환하여 비동기 작업을 처리
        return Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            // Alamofire를 사용하여 POST 요청
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
                .response { response in
                    switch response.result {
                    case .success:
                        promise(.success(()))
                    case .failure(let error):
                        if let responseCode = error.responseCode, responseCode == 401 {
                            // 토큰 갱신을 시도
                            LoginAPIManager.shared.refreshToken { result in
                                switch result {
                                case .success:
                                    self.userProfileUpdate(userProfile: userProfile)
                                        .sink(receiveCompletion: { _ in }, receiveValue: { _ in
                                            promise(.success(()))
                                        })
                                        .store(in: &self.cancellables)
                                case .failure(let refreshError):
                                    promise(.failure(refreshError))
                                }
                            }
                        } else {
                            promise(.failure(error))
                        }
                    }
                }
        }
    }
}
