//
//  OnboardingViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class OnboardingViewModel {
    var userProfile = UserProfile(nickname: "", height: "", weight: "", gender: "", targetWeight: "", targetDate: "", canEatCalorie: 0, createdDate: "", remindTime: "")
    var currentIndex = BehaviorRelay<Int>(value: 0)
    
    var nickname = BehaviorRelay<String>(value: "")
    var height = BehaviorRelay<String>(value: "")
    var weight = BehaviorRelay<String>(value: "")
    var gender = BehaviorRelay<String>(value: "")
    var targetWeight = BehaviorRelay<String>(value: "")
    var targetDate = BehaviorRelay<Date>(value: Date())
    var reminderTime = BehaviorRelay<String>(value: "")
    let errorMessage = PublishRelay<String>()
    
    
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
        print("Reminder Time: \(String(describing: userProfile.remindTime))")
        print("To Date: \(String(describing: userProfile.createdDate))")
    }
    
    func saveProfileData() {
        userProfile.nickname = nickname.value
        userProfile.height = height.value
        userProfile.weight = weight.value
        userProfile.gender = gender.value
    }
    
    func checkNicknameAndProceed() {
        guard profileValidateForm() else {
            errorMessage.accept("모든 필드를 올바르게 입력해주세요.")
            return
        }
        
        UserAPIManager.shared.checkNickname(nickname: nickname.value) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if data.statusCode == 400 {
                    self.errorMessage.accept("중복된 닉네임이에요!\n다른 닉네임으로 시도해 주세요")
                } else {
                    self.saveProfileData()
                    self.moveToNextPage()
                    print("닉네임 중복 검사 통과 \(nickname.value)")
                }
            case .failure(let error):
                self.errorMessage.accept("서버가 불안정 합니다.\n잠시 후 다시 시도해주세요.")
                print("\(error.localizedDescription)")
            }
        }
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
        
        userProfile.remindTime = reminderTime.value
        print("Reminder Time: \(userProfile.remindTime)")
        calculateCanEatCalorie()
    }
    
    func calculateCanEatCalorie() {
        var bmr: Double = 0.0
        let weightValue = 10 * (Double(weight.value) ?? 0)
        let heightValue = 6.25 * (Double(height.value) ?? 0)
        let ageValue = 5 * Double(20)
        
        if userProfile.gender == "남자" {
            bmr = weightValue + heightValue - ageValue + 5
        } else {
            bmr = weightValue + heightValue - ageValue - 161
        }
        
        print("\(userProfile.gender) BMR: \(bmr)")
        userProfile.canEatCalorie = Int(bmr)
    }
    
    func reminderValidateForm() -> Bool {
        return !reminderTime.value.isEmpty
    }
    
    func submitProfile(completion: @escaping (Result<Void, Error>) -> Void) {
        // 서버 통신 로직
        UserAPIManager.shared.userProfileUpdate(userProfile: userProfile) { result in
            switch result {
            case .success():
                print("프로필 업데이트 성공")
            case .failure(_):
                print("프로필 업데이트 실패")
            }
        }
    }
}
