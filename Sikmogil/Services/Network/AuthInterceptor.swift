//
//  AuthInterceptor.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/27/24.
//

import Alamofire
import Foundation

class AuthInterceptor: RequestInterceptor {
    
    private let retryLimit = 2
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let token = TokenStorage.shared.accessToken {
            if urlRequest.headers["Authorization"] == nil {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            return completion(.doNotRetryWithError(error))
        }
        guard request.retryCount < retryLimit else { return completion(.doNotRetryWithError(error)) }
        
        guard let refreshToken = TokenStorage.shared.refreshToken, !refreshToken.isEmpty else {
            return completion(.doNotRetryWithError(error))
        }
        
        LoginAPIManager.shared.refreshToken { result in
            switch result {
            case .success(let tokenResponse):
                TokenStorage.shared.setTokens(accessToken: tokenResponse.data.accessToken, refreshToken: tokenResponse.data.refreshToken)
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}


