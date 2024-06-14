//
//  ExerciseCategoryAPIManager.swift
//  Sikmogil
//
//  Created by 정유진 on 6/14/24.
//

import Foundation
import Alamofire

class ExerciseCategoryAPIManager {
    
    static let shared = ExerciseCategoryAPIManager()
    
    private init() {}
    
    let baseURL = "https://api.odcloud.kr/api"
    
    // MARK: - 모든 운동 종목 조회
    func getAllExerciseCategories(completion: @escaping (Result<[ExerciseCategoryModel], Error>) -> Void) {
        
        let url = "\(baseURL)/15068730/v1/uddi:734ff9bb-3696-4993-a365-c0201eb0a6cd"

        let parameters: [String: Any] = [
//            "serviceKey": apiKey,
            "page": 1,
            "perPage": 100
        ]

        let header: HTTPHeaders = [
            "Authorization": "tyjjku7%2FNiW72Gywhp%2FsfnkUcvEz6jUAPEZ47eEh6IbSBn5y8Ndz147CDWS%2BiRq%2B7C136MJRDqlFZlPkDBZ76g%3D%3D"
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: header).validate(statusCode: 200..<300).responseDecodable(of: ExerciseCategoryResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("getAllExerciseCategories success")
                completion(.success(data.data))
            case .failure(let error):
                print("getAllExerciseCategories failure")
                completion(.failure(error))
            }
        }
    }
}

struct ExerciseCategoryModel: Decodable {
    let categoryName: String
    let caloriesBurned: String
    
    private enum CodingKeys: String, CodingKey {
        case categoryName = "운동명"
        case caloriesBurned = "단위체중당에너지소비량"
    }
}

struct ExerciseCategoryResponse: Decodable {
    let data: [ExerciseCategoryModel]
}
