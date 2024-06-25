//
//  DietAPIManager.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/11/24.
//

import Foundation
import Alamofire

class DietAPIManager {
    
    static let shared = DietAPIManager()
    
    private init() {}
    
    private let baseURL = Bundle.main.baseURL
    
    let token = "Bearer \(LoginAPIManager.shared.getAccessTokenFromKeychain())"
    
    private var headers: HTTPHeaders {
        return [
            "Authorization": token,
            "Accept": "application/json"
        ]
    }
    
    // MARK: - 특정 날짜 식단 데어터 업데이트
        func updateDietLog(date: String, water: Int, totalCalorieEaten: Int, completion: @escaping (Result<Void, Error>) -> Void) {
            
            let url = "\(baseURL)/api/dietLog/updateDietLog"
            
            let parameters: [String: Any] = [
                "dietDate": date,
                "waterIntake": water,
                "totalCalorieEaten": totalCalorieEaten
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().response { response in
                switch response.result {
                case .success:
                    print("updateDietLog success")
                    completion(.success(()))
                case .failure(let error):
                    print("updateDietLog failure")
                    completion(.failure(error))
                }
            }
        }
    
    // MARK: - 특정 날짜 식단 사진 추가
    func addDietPicture(date: String, pictureData: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let url = "\(baseURL)/api/dietLog/dietPicture/addDietPicture"
        
        let parameters: [String: Any] = [
            "date": date,
            "foodPicture": pictureData,
            "dietDate": date
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().response { response in
            switch response.result {
            case .success:
                print("addDietPicture success")
                completion(.success(()))
            case .failure(let error):
                print("addDietPicture failure")
                completion(.failure(error))
            }
        }
        
    }
    
    // MARK: - 특정 날짜 식단 사진 삭제
    func deleteDietPicture(date: String, dietPictureId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let url = "\(baseURL)/api/dietLog/dietPicture/deleteDietPicture"
        
        let parameters: [String: Any] = [
            "date": date,
            "dietPictureId": dietPictureId
            
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().response { response in
            switch response.result {
            case .success:
                print("deleteDietPicture success")
                completion(.success(()))
            case .failure(let error):
                print("deleteDietPicture failure")
                completion(.failure(error))
            }
        }
        
    }
    
    // MARK: - 특정 날짜 식단 추가
    func addDietList(date: String, dietList: DietList, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let url = "\(baseURL)/api/dietLog/dietList/addDietList"
        
        let parameters: [String: Any] = [
            "date": date,
            "calorie": dietList.calorie,
            "foodName": dietList.foodName,
            "mealTime": dietList.mealTime // 밥먹은 시간 예시 ) breakfast, lunch, dinner, snack
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().response { response in
            switch response.result {
            case .success:
                print("addDietList success")
                completion(.success(()))
            case .failure(let error):
                print("addDietList failure")
                completion(.failure(error))
            }
        }
        
    }
    
    // MARK: - 특정 날짜 식단 삭제
    func deleteDietList(date: String, dietListId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let url = "\(baseURL)/api/dietLog/dietList/deleteDietList"
        
        let parameters: [String: Any] = [
            "date": date,
            "dietListId": dietListId
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().response { response in
            switch response.result {
            case .success:
                print("deleteDietList success")
                completion(.success(()))
            case .failure(let error):
                print("deleteDietList failure \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
    }
    
    // MARK: - 사용자 모든 식단 내역 출력
    func getDietLog(completion: @escaping (Result<[DietLog], Error>) -> Void) {
        
        let url = "\(baseURL)/api/dietLog"
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: [DietLog].self,  emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let data):
                print("getDietLog success")
                completion(.success(data))
            case .failure(let error):
                print("getDietLog failure")
                completion(.failure(error))
            }
        }
        
    }
    
    // MARK: - 특정 날짜 식단 데이터 출력
    func getDietLogDate(date: String, completion: @escaping (Result<DietLog, Error>) -> Void) {
        
        let url = "\(baseURL)/api/dietLog/getDietLogDate"
        
        let parameters: [String: Any] = ["dietDate": date]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: DietLog.self,  emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let data):
                print("getDietLogDate success")
                completion(.success(data))
            case .failure(let error):
                print("getDietLogDate failure")
                completion(.failure(error))
            }
        }
        
    }
    
    // MARK: - 특정 날짜 식단 사진 출력
    func getDietPictureByDate(date: String, completion: @escaping (Result<[DietPicture], Error>) -> Void) {
        
        let url = "\(baseURL)/api/dietLog/dietPicture/getDietPictureByDate"
        
        let parameters: [String: Any] = ["date": date]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: [DietPicture].self,  emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let data):
                print("getDietPictureByDate success")
                completion(.success(data))
            case .failure(let error):
                print("getDietPictureByDate failure")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 특정 날짜 식단 리스트 출력
    func getDietListByDate(date: String, completion: @escaping (Result<[DietList], Error>) -> Void) {
        
        let url = "\(baseURL)/api/dietLog/dietList/getDietListByDate"
        
        let parameters: [String: Any] = ["date": date]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: [DietList].self,  emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let data):
                print("getDietListByDate success")
                completion(.success(data))
            case .failure(let error):
                print("getDietListByDate failure")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 식단 사진 출력
    func getDietPicture(completion: @escaping (Result<[DietPicture], Error>) -> Void) {
        
        let url = "\(baseURL)/api/dietLog/findDietPictures"
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: [DietPicture].self,  emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let data):
                print("getDietPicture success")
                completion(.success(data))
            case .failure(let error):
                print("getDietPicture failure")
                completion(.failure(error))
            }
        }
    }
}
