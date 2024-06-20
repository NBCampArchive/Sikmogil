//
//  DietViewModel.swift
//  Sikmogil
//
//  Created by 희라 on 6/14/24.
//  [ViewModel] **설명** 식단 뷰모델

import Foundation

class DietViewModel {
    
    // API Manager
    let dietAPIManager = DietAPIManager.shared
    
    // MARK: - DietLog
    //식단
    var dietLog : DietLog?
    
    //특정날짜 식단 데이터 업데이트
    func updateDietLog(for date: String, water: Int, totalCalorieEaten:Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        dietAPIManager.updateDietLog(date: date, water: water, totalCalorieEaten: totalCalorieEaten) { result in
            switch result {
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //특정 날짜 식단 데이터 출력
    func getDietLogDate(for date: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        dietAPIManager.getDietLogDate(date: date) {
            result in
            switch result {
            case .success(let data):
                self.dietLog = data
                completion(.success(()))
                print("식단 출력 성공: \(data)")
            case .failure(let error):
                completion(.failure(error))
                print("식단 출력 실패: \(error)")
            }
        }
    }
}
