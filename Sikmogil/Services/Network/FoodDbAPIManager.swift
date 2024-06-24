//
//  FoodDbAPIManager.swift
//  Sikmogil
//
//  Created by 희라 on 6/13/24.
//  [Network] **설명** 식단 식품영양성분DB정보 API 매니저

import Foundation
import Alamofire

let sessionManager: Session = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    let manager = ServerTrustManager(evaluators: ["apis.data.go.kr": DisabledTrustEvaluator()])
    return Session(configuration: configuration, serverTrustManager: manager)
}()

class FoodDbAPIManager {
    
    private let baseURLString = "https://apis.data.go.kr/1471000/FoodNtrCpntDbInfo/getFoodNtrCpntDbInq"
    private let serviceKey = Bundle.main.foodDBKEY

    init() {}
    
    static let shared = FoodDbAPIManager()
    
    func fetchFoodItems(searchQuery: String, index: Int, completion: @escaping (Result<[FoodItem], Error>) -> Void) {
        guard let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "검색어를 인코딩하는 중 오류 발생"])
            completion(.failure(error))
            return
        }

        let urlString = "\(baseURLString)?serviceKey=\(serviceKey)&pageNo=1&numOfRows=\(index)&type=json&FOOD_NM_KR=\(encodedQuery)"
        //print("요청 URL:", urlString)

        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "유효하지 않은 URL입니다."])
            completion(.failure(error))
            return
        }

        sessionManager.request(url, method: .get).responseDecodable(of: [FoodItem].self) { response in
            //debugPrint(response) // 응답 정보 디버깅용

            switch response.result {
            case .success(let data):
                do {
                    guard let data = response.data else {
                        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "응답 데이터가 없습니다."])
                    }
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data)
                    let items = response.body.items
                    completion(.success(items))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
