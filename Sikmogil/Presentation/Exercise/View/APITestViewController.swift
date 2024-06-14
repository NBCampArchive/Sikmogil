//
//  APITestViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/13/24.
//

import UIKit
import SnapKit
import Then

class APITestViewController: UIViewController {

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
       
        // MARK: - API 테스트
        // 예시로 사용할 날짜
//        let exerciseDayToFetch = "2024.06.13"
//        insertDataList()
//        fetchExerciseList(for: exerciseDayToFetch)
        
//        deleteExerciseListData(for: "2024-06-13", exerciseListId: 1) 
        // -> deleteExerciseListData success
        
//        updateExerciseData()
//        fetchAllExerciseData()

//        fetchExerciseData(for: "2024-06-13")
        // 더 사용해보기!
    
    }
    
    // MARK: - Exercise API Test ⭐️
    // 1. 특정 날짜 운동 리스트 = 리스트 출력
    // addExerciseListData, getExerciseList, deleteExerciseListData
    private func insertDataList() {
        // 예시로 사용할 운동 리스트 데이터
        let exerciseListToAdd = ExerciseListModel(
            workoutListId: 1,
            performedWorkout: "Running",
            workoutTime: 30,
            workoutIntensity: 5,
            workoutPicture: "", // 사진 추가시 경로 설정
            calorieBurned: 300
        )

        // 예시로 사용할 날짜
        let exerciseDayToAdd = "2024.06.13"

        // ExerciseAPIManager.shared.addExerciseListData 호출
        ExerciseAPIManager.shared.addExerciseListData(exerciseDay: exerciseDayToAdd, exerciseList: exerciseListToAdd) { result in
            switch result {
            case .success:
                print("Exercise list added successfully!")
                // 추가된 데이터가 있으므로 이후 데이터 가져오기 호출
                self.fetchAllExerciseData()
            case .failure(let error):
                print("Failed to add exercise list:", error)
            }
        }
    }
    
    private func fetchExerciseList(for date: String) {
        ExerciseAPIManager.shared.getExerciseList(exerciseDay: date) { result in
            switch result {
            case .success(let exerciseList):
                print("getExerciseList success")
                if exerciseList.isEmpty {
                    print("데이터가 없음")
                } else {
                    print("날짜, 운동 데이터 \(date):")
                }
            case .failure(let error):
                print("exercise list fetch 실패:", error)
            }
        }
    }
    
    // 특정 날짜의 운동 리스트 데이터를 삭제하기 테스트
    private func deleteExerciseListData(for date: String, exerciseListId: Int) {
        ExerciseAPIManager.shared.deleteExerciseListData(exerciseDay: date, exerciseListId: exerciseListId) { result in
            switch result {
            case .success:
                print("특정날짜 리스트 삭제: \(date) &  \(exerciseListId)")
            case .failure(let error):
                print(" 날짜 리스트 삭제 실패 \(date) &  \(exerciseListId):", error)
            }
        }
    }
    
    // 2. 특정날짜 운동내용 = 모든 운동내용
    // updateExerciseData, getExerciseData, getAllExerciseData
    private func updateExerciseData() {
        // 예시로 사용할 날짜와 운동 데이터
        let exerciseDayToUpdate = "2024.06.12"
        let steps = 60000
        let totalCaloriesBurned = 200

        // updateExerciseData 메서드 호출
        ExerciseAPIManager.shared.updateExerciseData(exerciseDay: exerciseDayToUpdate, steps: steps, totalCaloriesBurned: totalCaloriesBurned) { result in
            switch result {
            case .success:
                print("운동 데이터 업데이트 성공 \(exerciseDayToUpdate)")
            case .failure(let error):
                print("운동 데이터 업데이트 실패:", error)
            }
        }
    }

    // 특정 날짜의 운동 데이터를 가져오기 테스트
    private func fetchExerciseData(for date: String) {
        ExerciseAPIManager.shared.getExerciseData(exerciseDay: date) { result in
            switch result {
            case .success(let exerciseData):
                print("특정 날짜: \(date)")
                print("Date: \(exerciseData.workoutDate ?? "Unknown Date"), Steps: \(exerciseData.steps ?? 0), Total Calories Burned: \(exerciseData.totalCaloriesBurned ?? 0)")
            case .failure(let error):
                print("특정날짜 exercise data fetch 실패 \(date):", error)
            }
        }
    }
    
    // TODO: Date: Unknown Date
    private func fetchAllExerciseData() {
        ExerciseAPIManager.shared.getAllExerciseData { result in
            switch result {
            case .success(let exerciseDataArray):
                // 성공 시 모든 운동 데이터 콘솔에 출력
                print("All Exercise Data:")
                if exerciseDataArray.isEmpty {
                    print("No exercise data available.")
                    print(exerciseDataArray)
                } else {
                    print(exerciseDataArray)
                    
                    for exerciseData in exerciseDataArray {
                        // 값이 nil인 경우 0으로 대체
                        let workoutDate = exerciseData.workoutDate ?? "Unknown Date"
                        let steps = exerciseData.steps ?? 0
                        let totalCaloriesBurned = exerciseData.totalCaloriesBurned ?? 0
                        print("Date: \(workoutDate), Steps: \(steps), Calories Burned: \(totalCaloriesBurned)")
                    }
                }
            case .failure(let error):
                // 실패 시 에러 출력
                print("all exercise data fetch 실패:", error)
            }
        }
    }
    
    
    // MARK: - Exercise Category Test ⭐️
    private func fetchAllExerciseCategories() {
        ExerciseCategoryAPIManager.shared.getAllExerciseCategories { result in
            switch result {
            case .success(let categories):
                print("All Exercise Categories:")
                if categories.isEmpty {
                    print("No exercise categories available.")
                } else {
                    for category in categories {
                        print("Category Name: \(category.categoryName), Calories Burned: \(category.caloriesBurned)")
                    }
                }
            case .failure(let error):
                print("Failed to fetch exercise categories:", error)
            }
        }
    }
}

