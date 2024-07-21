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
    
    func fetchBoardList(category: String, page: Int) -> AnyPublisher<BoardListResponse, Error> {
        let url = "\(baseURL)/api/boards/\(category)"
        
        let parameters: [String: Any] = [
            "page": page
        ]
        
        return session.request(url, method: .get, parameters:parameters)
            .publishDecodable(type: BoardListResponse.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func createPost(board: PostModel) -> AnyPublisher<PostResponse, Error> {
        let url = "\(baseURL)/api/boards/"
        
        print("Creating post: \(board)")
        
        return session.request(url, method: .post, parameters: board, encoder: URLEncodedFormParameterEncoder.default)
            .validate()
            .responseData { response in
                debugPrint(response)
                if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
            }
            .publishDecodable(type: PostResponse.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func fetchBoardDetail(boardId: Int) -> AnyPublisher<BoardDetailModel, Error> {
        let url = "\(baseURL)/api/boards/detail/\(boardId)"
        
        let parameters: [String: Any] = [
            "boardId": boardId
        ]
        
        return session.request(url, method: .get, parameters: parameters)
            .publishDecodable(type: BoardDetailModel.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func toggleLike(boardId: Int) -> AnyPublisher<Void, Error> {
        let url = "\(baseURL)/api/boards/likes/like"
        
        let parameters: [String: Any] = [
            "boardId": boardId
        ]
        
        return session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .publishData()
            .tryMap{ response in
                if response.error != nil {
                    throw response.error!
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    func deleteLike(boardId: Int) -> AnyPublisher<Void, Error> {
        let url = "\(baseURL)/api/boards/likes/cancel"
        
        let parameters: [String: Any] = [
            "boardId": boardId
        ]
        
        return session.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .publishData()
            .tryMap{ response in
                if response.error != nil {
                    throw response.error!
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    func reportPost(boardId: Int) -> AnyPublisher<Void, Error> {
        let url = "\(baseURL)/api/boards/report"
        
        let parameters: [String: Any] = [
            "boardId": boardId
        ]
        
        return session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .publishData()
            .tryMap{ response in
                if response.error != nil {
                    throw response.error!
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    func deletePost(boardId: Int) -> AnyPublisher<Void, Error> {
        let url = "\(baseURL)/api/boards/\(boardId)"
        
        let parameters: [String: Any] = [
            "boardId": boardId
        ]
        
        return session.request(url, method: .delete, parameters: parameters)
            .validate()
            .publishData()
            .tryMap{ response in
                if response.error != nil {
                    throw response.error!
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    // 게시글 수정
    func updatePost(boardId: Int, board: PostModel) -> AnyPublisher<PostResponse, Error> {
        let url = "\(baseURL)/api/boards/\(boardId)"
        
        return session.request(url, method: .put, parameters: board, encoder: URLEncodedFormParameterEncoder.default)
            .validate()
            .publishDecodable(type: PostResponse.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
