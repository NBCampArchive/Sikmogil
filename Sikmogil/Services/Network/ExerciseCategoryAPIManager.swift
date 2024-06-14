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
    let apiKey = "tyjjku7/NiW72Gywhp/sfnkUcvEz6jUAPEZ47eEh6IbSBn5y8Ndz147CDWS+iRq+7C136MJRDqlFZlPkDBZ76g=="
        
    // MARK: - 모든 운동 종목 조회
    func getAllExerciseCategories(completion: @escaping (Result<[ExerciseCategoryModel], Error>) -> Void) {
        let url = "\(baseURL)/15068730/v1/uddi:ea70f2da-241d-4637-a51d-20f61860cf9a"
        
        let parameters: [String: Any] = [
            "serviceKey": apiKey,
            "page": 1,
            "perPage": 100
        ]
        
        AF.request(url, method: .get, parameters: parameters).validate(statusCode: 200..<300).responseDecodable(of: ExerciseCategoryResponse.self) { response in
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
    let equipmentRequired: String
    let caloriesBurned: String
    
    private enum CodingKeys: String, CodingKey {
        case categoryName = "운동종목명"
        case equipmentRequired = "장비유무"
        case caloriesBurned = "칼로리소모량"
    }
}

struct ExerciseCategoryResponse: Decodable {
    let data: [ExerciseCategoryModel]
}
