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
    
    // MARK: - 특정 날짜 캘린더 데이터 출력
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
// MARK: - Example Code
//CalendarAPIManager.shared.updateCalendarData(calendarDate: DateHelper.shared.formatDateToYearMonthDay(Date()), diaryText: "다이어리 테스트 1"){ result in
//    switch result {
//    case .success:
//        print("다이어리 업데이트 성공")
//    case .failure(let error):
//        print("다이어리 업데이트 실패: \(error)")
//    }
//}
//
//CalendarAPIManager.shared.getCalendarData(calendarDate: DateHelper.shared.formatDateToYearMonthDay(Date())){ result in
//    switch result {
//    case .success(let data):
//        print("다이어리 데이터 가져오기 성공: \(data)")
//    case .failure(let error):
//        print("다이어리 데이터 가져오기 실패: \(error)")
//    }
//}
//
//CalendarAPIManager.shared.getAllCalendarData() { result in
//    switch result {
//    case .success(let data):
//        print("다이어리 전체 데이터 가져오기 성공: \(data)")
//    case .failure(let error):
//        print("다이어리 전체 데이터 가져오기 실패: \(error)")
//    }
//}
