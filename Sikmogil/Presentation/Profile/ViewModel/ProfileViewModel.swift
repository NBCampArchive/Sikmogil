//
//  ProfileViewModel.swift
//  Sikmogil
//
//  Created by Developer_P on 6/15/24.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class ProfileViewModel {
    var userProfile = UserProfile(nickname: "", height: "", weight: "", gender: "", targetWeight: "", toDate: "", targetDate: "", reminderTime: "", canEatCalorie: 0)
    var nickname = BehaviorRelay<String>(value: "")
    var height = BehaviorRelay<String>(value: "")
    var weight = BehaviorRelay<String>(value: "")
    var gender = BehaviorRelay<String>(value: "")
    var targetWeight = BehaviorRelay<String>(value: "")
    var targetDate = BehaviorRelay<Date>(value: Date())
    var reminderTime = BehaviorRelay<String>(value: "")
    
    func fetchUserProfile() {
        UserAPIManager.shared.getUserInfo { result in
            switch result {
            case .success(let data):
                print(data)
                self.userProfile = data
                self.nickname.value = data.nickname
                self.height.value = data.height
                self.weight.value = data.weight
                self.gender.value = data.gender
                self.targetWeight.value = data.targetWeight
                self.targetDate.value = DateHelper.shared.parseDate(data.targetDate)
                self.reminderTime.value = data.reminderTime
            case .failure(_):
                print("error")
            }
        }
    }
    
    func saveProfileData() {
        userProfile.nickname = nickname.value
        userProfile.height = height.value
        userProfile.weight = weight.value
        userProfile.gender = gender.value
    }
    
    func saveTargetData() {
        userProfile.targetWeight = targetWeight.value
        userProfile.targetDate = DateHelper.shared.formatDateToYearMonthDay(targetDate.value)
    }
    
    func saveReminderData() {
        userProfile.toDate = DateHelper.shared.formatDateToYearMonthDay(Date())
        userProfile.reminderTime = reminderTime.value
    }
    
    func submitProfile(completion: @escaping (Result<Void, Error>) -> Void) {
        // 서버 통신 로직
        UserAPIManager.shared.userProfileUpdate(userProfile: userProfile) { result in
            completion(result)
        }
    }
}
