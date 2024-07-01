//
//  BoardAPIManager.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/1/24.
//

import Foundation
import Alamofire
import Combine

class BoardAPIManager {
    
    static let shared = BoardAPIManager()
    
    private init() {}
    
    private let baseURL = Bundle.main.baseURL
    
    private let session: Session = {
        let interceptor = AuthInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    func fetchBoardList() -> AnyPublisher<BoardListResponse, Error> {
        let url = "\(baseURL)/api/board/list"
        
        return session.request(url, method: .get)
            .publishDecodable(type: BoardListResponse.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
