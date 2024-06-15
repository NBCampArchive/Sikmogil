//
//  DietViewModel.swift
//  Sikmogil
//
//  Created by 희라 on 6/14/24.
//  [ViewModel] **설명** 식단 뷰모델

import Foundation

class DietViewModel {
    
    //식단
    var dietLog : DietLog?
    
    //식사리스트
    var dietList : [DietList] = []
    
    //식사 사진추가부분 추가예정
    
    // API Manager
    let dietAPIManager = DietAPIManager.shared
    
    
    // MARK: - DietList
    //식사리스트 업데이트
    func addDietList(for date: String, dietList: DietList, completion: @escaping (Result<Void, Error>) -> Void) {
        
        dietAPIManager.addDietList(date: date, dietList: dietList) { result in
            switch result {
            case .success():
                completion(.success(()))
                print("식단 업데이트 성공")
            case .failure(let error):
                completion(.failure(error))
                print("식단 업데이트 실패: \(error)")
            }
        }
    }
    
    //식사리스트 출력
    func getDietListByDate(for date: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        dietAPIManager.getDietListByDate(date: date) {
            result in
            switch result {
            case .success(let data):
                self.dietList = data
                completion(.success(()))
                print("식단 출력 성공: \(data)")
            case .failure(let error):
                completion(.failure(error))
                print("식단 출력 실패: \(error)")
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
    
    
    // MARK: - DietLog
    //특정날짜 식단 데이터 업데이트
    func updateDietLog(for date: String, water: Int, totalCalorieEaten:Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        dietAPIManager.updateDietLog(date: date, water: water, totalCalorieEaten: totalCalorieEaten) { result in
            switch result {
            case .success():
                completion(.success(()))
                print("식단 업데이트 성공")
            case .failure(let error):
                completion(.failure(error))
                print("식단 업데이트 실패: \(error)")
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
