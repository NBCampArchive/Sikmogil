//
//  DateHelper.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/2/24.
//

import Foundation

class DateHelper {

    static let shared = DateHelper()

    private init() {}

    // "yyyy.MM.dd" 형식으로 변환하는 함수
    func formatDateToYearMonthDay(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }

    // "yy.MM.dd.HH:mm" 형식으로 변환하는 함수
    func formatDateToYearMonthDayHourMinute(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd.HH:mm"
        return dateFormatter.string(from: date)
    }
    
    // 서버에서 받은 문자열을 Date로 변환 (예제: "2024-06-02T14:30:00Z")
    func dateFromServerString(_ dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: dateString)
    }
}

