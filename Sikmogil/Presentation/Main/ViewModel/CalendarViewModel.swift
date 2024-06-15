//
//  CalendarViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/15/24.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    @Published var calendarModels: CalendarModel?
    @Published var calendarListModels: [CalendarModel]?
    @Published var errorMessage: String?
    @Published var createDate: Date?
    @Published var targetDate: Date?
    @Published var postSuccess: Bool = false
    @Published var selectedDate: Date?
 
    private var cancellables = Set<AnyCancellable>()
    private let calendarService = CalendarAPIManager.shared
    
    //MARK: - 캘린더 기간
    func loadTargetData() {
        calendarService.getWeightData()
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { targetModel in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                self.createDate = dateFormatter.date(from: targetModel.createDate)
                self.targetDate = dateFormatter.date(from: targetModel.targetDate)
            }
            .store(in: &cancellables)
    }
    
    //MARK: - 전체 캘린더 정보
    func loadCalendarData() {
        calendarService.getAllCalendarData()
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { calendarModels in
                print("Loaded Calendar Models: \(calendarModels)") // 디버깅 출력
                self.calendarListModels = calendarModels
            }
            .store(in: &cancellables)
    }
    
    //MARK: - 특정 날짜 일기 업데이트
    func updateCalendarData(calendarDate: String, diaryText: String) {
        calendarService.updateCalendarData(calendarDate: calendarDate, diaryText: diaryText)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                self.loadCalendarData()
                self.postSuccess = true
            }
            .store(in: &cancellables)
    }
}
