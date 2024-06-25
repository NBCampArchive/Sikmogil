//
//  CalendarAPIManager.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/12/24.
//

import Foundation
import Alamofire
import Combine

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
    func updateCalendarData(calendarDate: String, diaryText: String) -> AnyPublisher<Void, Error> {
        let url = "\(baseURL)/api/calendar/updateCalendar"
        
        let parameters: [String: Any] = [
            "diaryDate": calendarDate,
            "diaryText": diaryText,
            "dietPictures": [],
            "workoutLists": []
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .publishData()
            .tryMap { response in
                if let error = response.error {
                    throw error
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - 캘린더 전체 데이터 출력
    func getAllCalendarData() -> AnyPublisher<[CalendarModel], Error> {
        let url = "\(baseURL)/api/calendar"
        
        return AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .publishDecodable(type: [CalendarModel].self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    // MARK: - 특정 날짜 캘린더 데이터 출력
    func getCalendarData(calendarDate: String) -> AnyPublisher<CalendarModel, Error>{
        
        let url = "\(baseURL)/api/calendar/getCalendarDate"
        
        let parameters: [String: Any] = [
            "diaryDate": calendarDate
        ]
        
        return AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .publishDecodable(type: CalendarModel.self)
            .value()
            .mapError { $0 as Error}
            .eraseToAnyPublisher()
    }
    
    //MARK: - 특정 날짜 몸무게 업데이트
    func updateWeightData(weightDate: String, weight: String)  -> AnyPublisher<Void, Error> {
        let url = "\(baseURL)/api/calendar/updateWeight"
        
        let parameters: [String: Any] = [
            "date": weightDate,
            "weight": weight
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
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
    
    //MARK: - 7일 기록치 몸무게 출력, 시작일 - 목표기간 포함
    func getWeightData() -> AnyPublisher<TargetModel, Error> {
        let url = "\(baseURL)/api/calendar/getWeek"
        
        return AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .publishDecodable(type: TargetModel.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
}
