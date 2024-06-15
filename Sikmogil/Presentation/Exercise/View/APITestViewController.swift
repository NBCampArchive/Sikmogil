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
//        addExerciseListData()
//        
//        getExerciseList(for: "2024.06.14")
//        
//        deleteExerciseListData(for: "2024.06.13", exerciseListId: 1)
//        
//        updateExerciseData()
//        
//        getExerciseData(for: "2024.06.13")
//        
//        getAllExerciseData()
//        
//        fetchAllExerciseCategories()
        
    }
    
    // MARK: - Exercise List
    
    private func addExerciseListData() {
        let day = DateHelper.shared.formatDateToYearMonthDay(Date())
        
        let exerciseDay = "2024.06.14"
        
        // 예시로 사용할 운동 리스트 데이터
        let exerciseList = ExerciseListModel(
            workoutListId: 1,
            performedWorkout: "Running",
            workoutTime: 30,
            workoutIntensity: 5,
            workoutPicture: "", // 사진 추가시 경로 설정
            calorieBurned: 300
        )
        
        ExerciseAPIManager.shared.addExerciseListData(exerciseDay: exerciseDay, exerciseList: exerciseList) { result in
            switch result {
            case .success:
                print("운동 리스트 추가 성공")
                // fetch 확인
                self.getExerciseList(for: exerciseDay)
            case .failure(let error):
                print("운동 리스트 추가 실패", error)
            }
        }
    }
    
    private func getExerciseList(for date: String) {
        ExerciseAPIManager.shared.getExerciseList(exerciseDay: date) {
            result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(_):
                print("운동 리스트 불러오기 실패")
            }
        }
    }
    
    private func deleteExerciseListData(for date: String, exerciseListId: Int) {
        ExerciseAPIManager.shared.deleteExerciseListData(exerciseDay: date, exerciseListId: exerciseListId) { result in
            switch result {
            case .success:
                print("운동 리스트 삭제: \(date)")
            case .failure(let error):
                print("운동 리스트 삭제 실패 \(date)", error)
            }
        }
    }
    
    // MARK: - ExerciseData
    
    private func updateExerciseData() {
        
        let exerciseDayToUpdate = "2024.06.13"
        let steps = 4000
        let totalCaloriesBurned = 300
        
        ExerciseAPIManager.shared.updateExerciseData(exerciseDay: exerciseDayToUpdate, steps: steps, totalCaloriesBurned: totalCaloriesBurned) { result in
            switch result {
            case .success:
                print("운동 데이터 업데이트 성공 \(exerciseDayToUpdate)")
            case .failure(let error):
                print("운동 데이터 업데이트 실패:", error)
            }
        }
    }
    
    private func getExerciseData(for date: String) {
        ExerciseAPIManager.shared.getExerciseData(exerciseDay: date) { result in
            switch result {
            case .success(let exerciseData):
                print("Date: \(exerciseData.workoutDate ?? "Unknown Date"), Steps: \(exerciseData.steps ?? 0), Total Calories Burned: \(exerciseData.totalCaloriesBurned ?? 0)")
            case .failure(let error):
                print("운동 데이터 불러오기 실패:", error)
            }
        }
    }
    
    private func getAllExerciseData() {
        ExerciseAPIManager.shared.getAllExerciseData { result in
            switch result {
            case .success(let exerciseDataArray):
                if exerciseDataArray.isEmpty {
                    print("No exercise data available.")
                } else {
                    print(exerciseDataArray)
                    
                    for exerciseData in exerciseDataArray {
                        let workoutDate = exerciseData.workoutDate ?? "Unknown Date"
                        let steps = exerciseData.steps ?? 0
                        let totalCaloriesBurned = exerciseData.totalCaloriesBurned ?? 0
                        print("Date: \(workoutDate), Steps: \(steps), Calories Burned: \(totalCaloriesBurned)")
                    }
                }
            case .failure(let error):
                print("모든 운동 데이터 불러오기 실패:", error)
            }
        }
    }
    
    
    // MARK: - Exercise Category
    private func fetchAllExerciseCategories() {
        ExerciseCategoryAPIManager.shared.getAllExerciseCategories { result in
            switch result {
            case .success(let categories):
                if categories.isEmpty {
                    print("운동 카테고리 비었음")
                } else {
                    for category in categories {
                        print("Category Name: \(category.categoryName), Calories Burned: \(category.caloriesBurned)")
                    }
                }
            case .failure(let error):
                print("운동 카테고리 불러오기 실패:", error)
            }
        }
    }
}

