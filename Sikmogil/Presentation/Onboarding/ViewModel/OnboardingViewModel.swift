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
    var userProfile = UserProfile()
    var currentIndex = BehaviorRelay<Int>(value: 0)
    
    func moveToNextPage() {
        let nextIndex = currentIndex.value + 1
        currentIndex.accept(nextIndex)
    }
    
    func saveProfileData(nickname: String, height: String, weight: String, gender: String) {
        userProfile.nickname = nickname
        userProfile.height = height
        userProfile.weight = weight
        userProfile.gender = gender
    }
    
    func saveTargetData(targetWeight: String, targetDate: String) {
        userProfile.targetWeight = targetWeight
        userProfile.targetDate = targetDate
    }
    
    func saveReminderData(reminderTime: String) {
        userProfile.toDate = DateHelper.shared.formatDateToYearMonthDay(Date())
        userProfile.reminderTime = reminderTime
    }
    
    func submitProfile(completion: @escaping (Result<Void, Error>) -> Void) {
        // 서버 통신 로직
    }
}
