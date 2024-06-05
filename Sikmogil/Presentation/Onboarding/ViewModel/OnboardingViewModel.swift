//
//  OnboardingViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import Foundation

class OnboardingViewModel {
    var userProfile = UserProfile()
    var currentStep = 0
    
    func saveProfileData(nickname: String, height: String, weight: String, gender: String) {
        userProfile.nickname = nickname
        userProfile.height = height
        userProfile.weight = weight
        userProfile.gender = gender
    }
    
    func saveTargetData(targetWeight: String, targetDate: Date) {
        userProfile.targetWeight = targetWeight
        userProfile.targetDate = targetDate
    }
    
    func saveReminderData(reminderTime: String) {
        userProfile.toDate = Date()
        userProfile.reminderTime = reminderTime
    }
    
    func submitProfile(completion: @escaping (Result<Void, Error>) -> Void) {
        // 서버 통신 로직
    }
}
