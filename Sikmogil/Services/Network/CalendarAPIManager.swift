//
//  CalendarAPIManager.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/12/24.
//

import Foundation
import Alamofire

class CalendarAPIManager {
    
    static let shared = CalendarAPIManager()
    
    private init() {}
    
    private let baseURL = Bundle.main.baseURL
    
    private let token = "Bearer \(LoginAPIManager.shared.getAccessTokenFromKeychain())"
    
    private var headers: HTTPHeaders {
        return [
            "Authorization": token,
            "Accept": "application/json"
        ]
    }
    
    // MARK: - 캘린더 데이터 업데이트
    func updateCalendarData(calendarDate: String, diaryText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/api/calendar/UpdateCalendar"
        
        let parameters: [String: Any] = [
            "diaryDate": calendarDate,
            "diaryText": diaryText,
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success:
                print("updateCalendarData success")
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 캘린더 전체 데이터 출력
    func getAllCalendarData(completion: @escaping (Result<[CalendarModel], Error>) -> Void) {
        let url = "\(baseURL)/api/calendar"
        
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseDecodable(of: [CalendarModel].self) { response in
            switch response.result {
            case .success(let data):
                print("getAllCalendarData success")
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 캘린더 전체 데이터 출력
    func getCalendarData(calendarDate: String, completion: @escaping (Result<[CalendarModel], Error>) -> Void) {
        
        let url = "\(baseURL)/api/calendar"
        
        let parameters: [String: Any] = [
            "diaryDate": calendarDate
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseDecodable(of: [CalendarModel].self) { response in
            switch response.result {
            case .success(let data):
                print("getCalendarData success")
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
