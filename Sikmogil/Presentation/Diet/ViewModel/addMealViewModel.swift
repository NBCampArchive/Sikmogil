//
//  addMealViewModel.swift
//  Sikmogil
//
//  Created by 희라 on 6/16/24.
//  [ViewModel] **설명** 다이어트 바텀시트<-> 다이어트 메인뷰

import Foundation
import Combine

class AddMealViewModel {
    
    static let shared = AddMealViewModel()
    
    @Published var totalBreakfastKcal: Int = 0
    @Published var totalLunchKcal: Int = 0
    @Published var totalDinnerKcal: Int = 0
    
    
    init() {
        // 초기화 코드
    }
    
    var totalKcalPublisher: AnyPublisher<Int, Never> {
        Publishers.CombineLatest3($totalBreakfastKcal, $totalLunchKcal, $totalDinnerKcal)
            .map { breakfast, lunch, dinner in
                return breakfast + lunch + dinner
            }
            .eraseToAnyPublisher()
    }
    
}
