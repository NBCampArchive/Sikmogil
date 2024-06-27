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
    
    // Combine의 AnyCancellable 인스턴스를 저장할 집합
    private var cancellables = Set<AnyCancellable>()
    
    // HTTP 요청 하면 사용할 헤더를 정의해주는데
    private let session: Session = {
        let interceptor = AuthInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    // 사용자 정보를 가져오는 함수
    func getUserInfo() -> AnyPublisher<UserResponse, Error> {
        let url = "\(baseURL)/api/members/getMember"
        
        return session.request(url, method: .get)
            .validate()
            .publishDecodable(type: UserResponse.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    // 사용자 프로필을 업데이트하는 함수
    func userProfileUpdate(userProfile: UserProfile) -> AnyPublisher<Void, Error> {
        let url = "\(baseURL)/api/members/onboarding"
        
        // 사용자 프로필 정보를 파라미터로 설정
        let parameters: [String: Any] = [
            "nickname": userProfile.nickname,
            "height": userProfile.height,
            "weight": userProfile.weight,
            "gender": userProfile.gender,
            "picture": userProfile.picture ?? "",
            "targetWeight": userProfile.targetWeight,
            "targetDate": userProfile.targetDate,
            "createdDate": userProfile.createdDate,
            "canEatCalorie": userProfile.canEatCalorie,
            "remindTime": userProfile.remindTime
        ]
        
        return session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .publishData()
            .tryMap { response in
                if let error = response.error {
                    throw error
                }
                return ()
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
