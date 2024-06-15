//
//  DietAPITest.swift
//  Sikmogil
//
//  Created by t2023-m0114 on 6/14/24.
//  DietAPITest용 파일입니다

import UIKit
import SnapKit
import Then

class DietAPITestViewController: UIViewController {
    
    let testLabel = UILabel().then {
        $0.text = "APITest"
        $0.font = Suite.bold.of(size: 30)
        $0.textColor = .appBlack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appPurple
        view.addSubview(testLabel)
        
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
        //addExerciseListData() //한끼 식사 추가
        //getDietListByDate() //식사 출력
        //deleteDietList() //식사 삭제

        
//        updateDietLog() // 식단 추가
//        getDietLogDate() // 식단 출력
        
        
    }
    
    
    
    //[식사] 추가하기
    private func addDietList() {
        
        let date = "2024.06.14"
        
        // 예시로 사용할 다이어트 리스트 데이터
        let dietList = DietList(
            dietListId: 1,
            calorie: 150,
            foodName: "오이또",
            mealTime: "breakfast"
        )
        
        DietAPIManager.shared.addDietList(date: date, dietList: dietList) { result in
            switch result {
            case .success():
                print("식단 업데이트 성공")
            case .failure(let error):
                print("식단 업데이트 실패: \(error)")
            }
        }
    }
    
    //[식사] 리스트 출력
    private func getDietListByDate() {
        
        let date = "2024.06.14"
        
        DietAPIManager.shared.getDietListByDate(date: date) {
            result in
                switch result {
                case .success(let data):
                    print("식단 출력 성공: \(data)")
                case .failure(let error):
                    print("식단 출력 실패: \(error)")
                }
        }
    }
    
    
    //[식사] 리스트 삭제
    private func deleteDietList() {
        
        let date = "2024.06.14"
        
        DietAPIManager.shared.deleteDietList(date: date, dietListId: 2) {
            result in
                switch result {
                case .success:
                    print("식단 삭제 성공")
                case .failure(let error):
                    print("식단 삭제 실패: \(error)")
                }
        }
    }
    
    
    
    //특정날짜 식단 데이터 업데이트
    private func updateDietLog() {
        
        let date = "2024.06.14"
        let water = 500
        let totalCalorieEaten = 1200
        
        DietAPIManager.shared.updateDietLog(date: date, water: water, totalCalorieEaten: totalCalorieEaten) { result in
            switch result {
            case .success():
                print("식단 업데이트 성공")
            case .failure(let error):
                print("식단 업데이트 실패: \(error)")
            }
        }
    }
    
    //특정 날짜 식단 데이터 출력
    private func getDietLogDate(){
        
        let date = "2024.06.14"
        
        DietAPIManager.shared.getDietLogDate(date: date) {
            result in
            switch result {
            case .success(let data):
                print("식단 출력 성공: \(data)")
            case .failure(let error):
                print("식단 출력 실패: \(error)")
            }
        }
    }
    
}
