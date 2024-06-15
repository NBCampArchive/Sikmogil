//
//  DietViewModel.swift
//  Sikmogil
//
//  Created by 희라 on 6/3/24.
//  [ViewModel] **설명** 다이어트 뷰모델

import Foundation
import Combine

class WaterViewModel {
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
    
    private init() {}
    
    func addWaterAmount(_ amount: Int) {
        todayWaterAmount += amount
    }
}
