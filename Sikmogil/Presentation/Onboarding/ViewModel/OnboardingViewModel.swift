//
//  OnboardingViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class OnboardingViewModel {
    var userProfile = UserProfile(nickname: "", height: "", weight: "", gender: "", targetWeight: "", targetDate: "", canEatCalorie: 0, createdDate: "", reminderTime: "")
    var currentIndex = BehaviorRelay<Int>(value: 0)
    
    var nickname = BehaviorRelay<String>(value: "")
    var height = BehaviorRelay<String>(value: "")
    var weight = BehaviorRelay<String>(value: "")
    var gender = BehaviorRelay<String>(value: "")
    var targetWeight = BehaviorRelay<String>(value: "")
    var targetDate = BehaviorRelay<Date>(value: Date())
    var reminderTime = BehaviorRelay<String>(value: "")
    
    
    func moveToNextPage() {
        let nextIndex = currentIndex.value + 1
        currentIndex.accept(nextIndex)
        
        debugPrint()
    }
    
    func debugPrint() {
        print("Nickname: \(String(describing: userProfile.nickname))")
        print("Height: \(String(describing: userProfile.height))")
        print("Weight: \(String(describing: userProfile.weight))")
        print("Gender: \(String(describing: userProfile.gender))")
        print("Target Weight: \(String(describing: userProfile.targetWeight))")
        print("Target Date: \(String(describing: userProfile.targetDate))")
        print("Reminder Time: \(String(describing: userProfile.reminderTime))")
        print("To Date: \(String(describing: userProfile.createdDate))")
    }
    
    func saveProfileData() {
        userProfile.nickname = nickname.value
        userProfile.height = height.value
        userProfile.weight = weight.value
        userProfile.gender = gender.value
    }
    
    func profileValidateForm() -> Bool {
        return !nickname.value.isEmpty && !height.value.isEmpty && !weight.value.isEmpty && !gender.value.isEmpty
    }
    
    func saveTargetData() {
        userProfile.targetWeight = targetWeight.value
        userProfile.targetDate = DateHelper.shared.formatDateToYearMonthDay(targetDate.value)
    }
    
    func targetValidateForm() -> Bool {
        return !targetWeight.value.isEmpty
    }
    
    func saveReminderData() {
        userProfile.createdDate = DateHelper.shared.formatDateToYearMonthDay(Date())
        userProfile.reminderTime = reminderTime.value
        calculateCanEatCalorie()
    }
    
    func calculateCanEatCalorie() {
        var bmr: Double = 0.0
        if userProfile.gender == "남자" {
            bmr = 10 * weight.value + 6.25 * height.value - 5 * Double(20) + 5
            
        } else {
            bmr = 10 * weight.value + 6.25 * height.value - 5 * Double(20) - 161
        }
        print("\(userProfile.gender) BMR: \(bmr)")
        userProfile.canEatCalorie = bmr
    }
    
    func reminderValidateForm() -> Bool {
        return !reminderTime.value.isEmpty
    }
    
    func submitProfile(completion: @escaping (Result<Void, Error>) -> Void) {
        // 서버 통신 로직
        UserAPIManager.shared.userProfileUpdate(userProfile: userProfile) { result in
            completion(result)
        }
    }
}
