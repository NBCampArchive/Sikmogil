//
//  ExerciseAPIManager.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/9/24.
//

import Foundation
import Alamofire

class ExerciseAPIManager {
    
    static let shared = ExerciseAPIManager()
    
    private init() {}
    
    let baseURL = Bundle.main.baseURL
    
    let token = "Bearer \(LoginAPIManager.shared.getAccessTokenFromKeychain())"
    
    // MARK: - 특정 날짜의 운동 데이터 업데이트(셀에 추가되는 데이터는 로컬에서 처리, 서버에 업데이트는 총량으로 처리)
    func updateExerciseData(exerciseDay: String, steps: Int, totalCaloriesBurned: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/api/workoutLog/updateWorkoutLog"
        
        let headers: HTTPHeaders = [
            "Authorization": token,
            "Accept": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "date": exerciseDay,
            "steps": steps,
            "totalCaloriesBurned": totalCaloriesBurned
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success:
                print("updateExerciseData success\(exerciseDay) \(steps) \(totalCaloriesBurned)")
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 특정 날짜의 운동 데이터 가저오기
    func getExerciseData(exerciseDay: String, completion: @escaping (Result<ExerciseModel, Error>) -> Void) {
        let url = "\(baseURL)/api/workoutLog/getWorkoutLogDate"
        
        let headers: HTTPHeaders = [
            "Authorization": token,
            "Accept": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "workoutDate": exerciseDay
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: ExerciseModel.self, emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 사용자의 모든 운동 내역 출력
    func getAllExerciseData(completion: @escaping (Result<[ExerciseModel], Error>) -> Void) {
        let url = "\(baseURL)/api/workoutLog"
        
        let headers: HTTPHeaders = [
            "Authorization": token,
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: [ExerciseModel].self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
//ExerciseAPIManager.shared.updateExerciseData(exerciseDay: DateHelper.shared.formatDateToYearMonthDay(Date()), steps: 10, totalCaloriesBurned: 50) { result in
//    switch result {
//    case .success:
//        ExerciseAPIManager.shared.getExerciseData(exerciseDay: DateHelper.shared.formatDateToYearMonthDay(Date())) { result in
//            switch result {
//            case .success(let data):
//                print("getExerciseData \(data)")
//            case .failure(let error):
//                print("getExerciseData \(error)")
//            }
//        }
//    case .failure(let error):
//        print("updateExerciseData \(error)")
//    }
//}
//
//ExerciseAPIManager.shared.getAllExerciseData { result in
//    switch result {
//    case .success(let data):
//        print("getAllExerciseData \(data)")
//    case .failure(let error):
//        print("getAllExerciseData \(error)")
//    }
//}
