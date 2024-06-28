//
//  addMealViewModel.swift
//  Sikmogil
//
//  Created by 희라 on 6/16/24.
//  [ViewModel] **설명** 다이어트 바텀시트<-> 다이어트 메인뷰

import Foundation
import Combine

class AddMealViewModel: ObservableObject {
    
    static let shared = AddMealViewModel()
    let dietAPIManager = DietAPIManager.shared
    
    @Published var totalBreakfastKcal: Int = 0
    @Published var totalLunchKcal: Int = 0
    @Published var totalDinnerKcal: Int = 0
    
    private var previousBreakfastCount = 0
    private var previousDinnerCount = 0
    
    init() {
        self.setupDietListListeners()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //칼로리 변화를 구독하는 변수
    var totalKcalPublisher: AnyPublisher<Int, Never> {
        Publishers.CombineLatest3($totalBreakfastKcal, $totalLunchKcal, $totalDinnerKcal)
            .map { breakfast, lunch, dinner in
                return breakfast + lunch + dinner
            }
            .eraseToAnyPublisher()
    }
    
    private func setupDietListListeners() {
        // 아침 식사 추가 감지
        $breakfastDietLists
            .sink { [weak self] lists in
                guard let self = self else { return }
                let currentCount = lists.count
                if self.previousBreakfastCount == 0 && currentCount == 1 {
                    self.postBreakfastAlert()
                }
                self.previousBreakfastCount = currentCount
            }
            .store(in: &cancellables)
        
        // 저녁 식사 추가 감지
        $dinnerDietLists
            .sink { [weak self] lists in
                guard let self = self else { return }
                let currentCount = lists.count
                if self.previousDinnerCount == 0 && currentCount == 1 {
                    self.postDinnerAlert()
                }
                self.previousDinnerCount = currentCount
            }
            .store(in: &cancellables)
    }
    
    private func postBreakfastAlert() {
        NotificationCenter.default.post(name: .showBreakfastAlert, object: nil, userInfo: ["isForBreakfast": true])
    }
    
    private func postDinnerAlert() {
        NotificationCenter.default.post(name: .showDinnerAlert, object: nil, userInfo: ["isForBreakfast": false])
    }
    
    // MARK: - DietList
    //식사리스트
    @Published var dietList : [DietList] = []
    @Published var breakfastDietLists : [DietList] = []    {
        didSet {
            totalBreakfastKcal = breakfastDietLists.reduce(0) { $0 + $1.calorie }
        }
    }
    @Published var lunchDietLists : [DietList] = []    {
        didSet {
            totalLunchKcal = lunchDietLists.reduce(0) { $0 + $1.calorie }
        }
    }
    @Published var dinnerDietLists : [DietList] = []    {
        didSet {
            totalDinnerKcal = dinnerDietLists.reduce(0) { $0 + $1.calorie }
        }
    }
    
    //식사리스트 업데이트
    func addDietList(for date: String, dietList: DietList, completion: @escaping (Result<Void, Error>) -> Void) {
        
        dietAPIManager.addDietList(date: date, dietList: dietList) { result in
            switch result {
            case .success():
                completion(.success(()))
                self.getDietListByDate(for: date) { _ in }
                print("식단 업데이트 성공")
            case .failure(let error):
                completion(.failure(error))
                print("식단 업데이트 실패: \(error)")
            }
        }
    }
    
    // 식사리스트 출력
    func getDietListByDate(for date: String, completion: @escaping (Result<Void, Error>) -> Void) {
        dietAPIManager.getDietListByDate(date: date) { result in
            switch result {
            case .success(let data):
                self.dietList = data
                self.breakfastDietLists = self.dietList.filter { $0.mealTime == "breakfast" }
                self.lunchDietLists = self.dietList.filter { $0.mealTime == "lunch" }
                self.dinnerDietLists = self.dietList.filter { $0.mealTime == "dinner" }
                completion(.success(()))
                print("식사리스트 출력 성공: \(data)")
            case .failure(let error):
                self.dietList = []
                self.breakfastDietLists = []
                self.lunchDietLists = []
                self.dinnerDietLists = []
                completion(.failure(error))
                print("식사리스트 출력 실패: \(error)")
            }
        }
    }
    
    //식사리스트 삭제: dietListId 필요
    func deleteDietList(for date: String, dietListId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        dietAPIManager.deleteDietList(date: date, dietListId: dietListId) {
            result in
            switch result {
            case .success:
                completion(.success(()))
                print("식단 삭제 성공")
            case .failure(let error):
                completion(.failure(error))
                print("식단 삭제 실패: \(error)")
            }
        }
    }
}

extension Notification.Name {
    static let showBreakfastAlert = Notification.Name("showBreakfastAlert")
    static let showDinnerAlert = Notification.Name("showDinnerAlert")
}
