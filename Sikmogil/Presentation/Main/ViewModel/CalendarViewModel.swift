//
//  CalendarViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/15/24.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    @Published var calendarModels: DailyCalendarModel?
    @Published var calendarListModels: [CalendarModel]?
    @Published var errorMessage: String?
    @Published var createDate: Date?
    @Published var targetDate: Date?
    @Published var postSuccess: Bool = false
    @Published var selectedDate: Date?
    
    @Published var dietPhotos: [String] = []
    @Published var workoutPhotos: [String] = []
    @Published var eatKal: Int = 0
    @Published var workoutKal: Int = 0
    @Published var diaryDate: String = ""
    @Published var diaryText: String = ""
    @Published var workoutTexts: [String] = []
    @Published var workoutSubtexts: [String] = []
    @Published var dietTexts: [String] = []
    @Published var dietSubtexts: [String] = []
    
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
            } receiveValue: { calendarListModel in
                print("Loaded Calendar Models: \(calendarListModel)") // 디버깅 출력
                self.calendarListModels = calendarListModel
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
    
    //MARK: - 특정 날짜 캘린더 정보
    func loadDayCalendar(calendarDate: String) {
        calendarService.getCalendarData(calendarDate: calendarDate)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { calendarModels in
                self.calendarModels = calendarModels
                self.updateDerivedData(from: calendarModels)
            }
            .store(in: &cancellables)
    }
    
    private func updateDerivedData(from calendarModel: DailyCalendarModel) {
        self.diaryDate = calendarModel.diaryDate
        self.diaryText = calendarModel.diaryText ?? ""
        
        self.dietPhotos = calendarModel.dietPictureDTOS?.compactMap { $0.foodPicture }.filter { !$0.isEmpty } ?? []
        self.workoutPhotos = calendarModel.workoutLists?.compactMap { $0.workoutPicture }.filter { !$0.isEmpty } ?? []
        self.workoutKal = calendarModel.workoutLists?.compactMap { $0.calorieBurned }.reduce(0, +) ?? 0
        self.workoutTexts = calendarModel.workoutLists?.compactMap { $0.performedWorkout } ?? []
        self.workoutSubtexts = calendarModel.workoutLists?.compactMap { $0.calorieBurned }.compactMap { "\($0) Kal" } ?? []
    }
    
    // MARK: - 특정 날짜 식단 정보 불러오기
    func loadDayDiet(calendarDate: String) {
        DietAPIManager.shared.getDietListByDate(date: calendarDate) { result in
            switch result {
            case .success(let dietList):
                self.eatKal = dietList.map { $0.calorie }.reduce(0, +)
                self.dietTexts = dietList.map { $0.foodName }
                self.dietSubtexts = dietList.map { "\($0.calorie) Kal" }
                print("Loaded Diet List: \(dietList) date:\(calendarDate)")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - collectinView Sections
    func numberOfSections() -> Int {
        return Section.allCases.filter { section in
            switch section {
            case .dietText: return !self.dietTexts.isEmpty
            case .dietPhotos: return !self.dietPhotos.isEmpty
            case .workoutText: return !self.workoutTexts.isEmpty
            case .workoutPhotos: return !self.workoutPhotos.isEmpty
            }
        }.count
    }
    
    func sections() -> [Section] {
        return Section.allCases.filter { section in
            switch section {
            case .dietText: return !self.dietTexts.isEmpty
            case .dietPhotos: return !self.dietPhotos.isEmpty
            case .workoutText: return !self.workoutTexts.isEmpty
            case .workoutPhotos: return !self.workoutPhotos.isEmpty
            }
        }
    }
}
