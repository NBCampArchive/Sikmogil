//
//  WaterViewModel.swift
//  Sikmogil
//
//  Created by 희라 on 6/3/24.
//  [ViewModel] **설명** 물마시기 뷰모델

import Foundation
import Combine

class WaterViewModel {
    
    let dietViewModel = DietViewModel()
    
    static let shared = WaterViewModel()
    
    @Published var todayWaterAmount: Int = 0
    
    var waterLiterLabelTextPublisher: AnyPublisher<String, Never> {
        return $todayWaterAmount
            .map { amount -> String in
                return "\(amount)ml / 2L"
            }
            .replaceError(with: "waterLiterLabelTextPublisher 에러발생")
            .eraseToAnyPublisher()
    }
    
    var waterProgressPublisher: AnyPublisher<Float, Never> {
        return $todayWaterAmount
            .map { amount -> Float in
                return Float(amount) / 2000.0
            }
            .replaceError(with: 0.0)
            .eraseToAnyPublisher()
    }
    
    private init() {
        // 초기화 시 서버의 값을 불러와서 todayWaterAmount에 설정
        dietViewModel.getDietLogDate(for: DateHelper.shared.formatDateToYearMonthDay(Date())) { [weak self] result in
            switch result {
            case .success(let data):
                let waterIntake = self!.dietViewModel.dietLog!.waterIntake
                self?.todayWaterAmount = waterIntake
            case .failure(let error):
                print("식단 출력 실패: \(error)")
            }
        }
    }
    
    func addWaterAmount(_ amount: Int) {
        todayWaterAmount += amount
        updateDietLog()
    }
    
    func setWaterAmount(_ amount: Int) {
        todayWaterAmount = amount
        updateDietLog()
    }
    
    func updateDietLog() {
        dietViewModel.updateDietLog(for: DateHelper.shared.formatDateToYearMonthDay(Date()), water: todayWaterAmount, totalCalorieEaten: 0) { result in
            switch result {
            case .success():
                print("식단 업데이트 성공")
            case .failure(let error):
                print("식단 업데이트 실패: \(error)")
            }
        }
    }
    
}
