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
    
    private let session: Session = {
        let interceptor = AuthInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    // MARK: - 특정 날짜의 운동 데이터 업데이트
    func updateExerciseData(exerciseDay: String, steps: Int, totalCaloriesBurned: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/api/workoutLog/updateWorkoutLog"
        
        let parameters: [String: Any] = [
            "workoutDate": exerciseDay,
            "steps": steps,
            "totalCaloriesBurned": totalCaloriesBurned
        ]
        
        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                print("updateExerciseData success\(exerciseDay) \(steps) \(totalCaloriesBurned)")
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 특정 날짜의 운동 리스트 추가
    func addExerciseListData(exerciseDay: String, exerciseList: ExerciseListModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/api/workoutLog/workoutList/addWorkoutList"
        
        let parameters: [String: Any] = [
            "date": exerciseDay,
            "performedWorkout": exerciseList.performedWorkout,
            "workoutTime": exerciseList.workoutTime,
            "workoutIntensity": exerciseList.workoutIntensity,
            "workoutPicture": exerciseList.workoutPicture ?? "", // (사진 추가시 사용할 예정)
            "calorieBurned": exerciseList.calorieBurned
            
        ]
        
        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().response { response in
            switch response.result {
            case .success:
                print("addExerciseListData success")
                completion(.success(()))
            case .failure(let error):
                print("addExerciseListData failure")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 특정 날짜의 운동 리스트 삭제
    func deleteExerciseListData(exerciseDay: String, exerciseListId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/api/workoutLog/workoutList/deleteWorkoutList"
        
        let parameters: [String: Any] = [
            "date": exerciseDay,
            "workoutListId": exerciseListId
        ]
        
        session.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).validate().response { response in
            switch response.result {
            case .success:
                print("deleteExerciseListData success")
                completion(.success(()))
            case .failure(let error):
                print("deleteExerciseListData failure")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 사용자의 모든 운동 내역 출력
    func getAllExerciseData(completion: @escaping (Result<[ExerciseModel], Error>) -> Void) {
        let url = "\(baseURL)/api/workoutLog"
        
        session.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: [ExerciseModel].self,  emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let data):
                print("getAllExerciseData success")
                completion(.success(data))
            case .failure(let error):
                print("getAllExerciseData failure")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 특정 날짜의 운동 데이터 출력
    func getExerciseData(exerciseDay: String, completion: @escaping (Result<ExerciseModel, Error>) -> Void) {
        let url = "\(baseURL)/api/workoutLog/getWorkoutLogDate"
        
        let parameters: [String: Any] = [
            "workoutDate": exerciseDay
        ]
        
        session.request(url, method: .get, parameters: parameters).validate(statusCode: 200..<300).responseDecodable(of: ExerciseModel.self, emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let data):
                print("getExerciseData success")
                completion(.success(data))
            case .failure(let error):
                print("getExerciseData failure")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 특정 날짜의 운동 리스트 출력
    func getExerciseList(exerciseDay: String, completion: @escaping (Result<[ExerciseListModel], Error>) -> Void) {
        let url = "\(baseURL)/api/workoutLog/workoutList/getWorkoutListByDate"
        
        let parameters: [String: Any] = [
            "date": exerciseDay
        ]
        
        session.request(url, method: .get, parameters: parameters).validate(statusCode: 200..<300).responseDecodable(of: [ExerciseListModel].self, emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let data):
                print("getExerciseList success")
                completion(.success(data))
            case .failure(let error):
                print("getExerciseList failure")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 운동 사진 출력
    func getExercisePicture(page: Int, completion: @escaping (Result<ExerciseAlbum, Error>) -> Void) {
        let url = "\(baseURL)/api/workoutLog/findWorkoutPictures"
        
        let parameters: Parameters = [
            "page": page
        ]

        session.request(url, parameters: parameters, method: .get).validate(statusCode: 200..<300).responseDecodable(of: [ExerciseListModel].self, emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let data):
                print("getExercisePicture success")
                completion(.success(data))
            case .failure(let error):
                print("getExercisePicture failure")
                completion(.failure(error))
            }
        }
    }
}

