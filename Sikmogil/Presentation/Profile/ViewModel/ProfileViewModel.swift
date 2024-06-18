//
//  ProfileViewModel.swift
//  Sikmogil
//
//  Created by Developer_P on 6/15/24.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userProfile = UserProfile(nickname: "", height: "", weight: "", gender: "", targetWeight: "", targetDate: "", canEatCalorie: 0, createdDate: "", remindTime: "")
    
    @Published var nickname = ""
    @Published var height = ""
    @Published var weight = ""
    @Published var gender = ""
    @Published var targetWeight = ""
    @Published var targetDate = Date()
    @Published var reminderTime = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bindProfile()
        fetchUserProfile()
    }
    
    func fetchUserProfile() {
        ProfileAPIManager.shared.getUserInfo()
            .print("userProfile")
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching user profile: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] userProfile in
                self?.updateFields(from: userProfile.data)
                self?.userProfile = userProfile.data
                print("333\(self?.userProfile)")
            }
            .store(in: &cancellables)
    }
    
    func saveProfileData() {
        userProfile.nickname = nickname
        userProfile.height = height
        userProfile.weight = weight
        userProfile.gender = gender
    }
    
    func saveTargetData() {
        userProfile.targetWeight = targetWeight
        userProfile.targetDate = DateHelper.shared.formatDateToYearMonthDay(targetDate)
    }
    
    func saveReminderData() {
        userProfile.createdDate = DateHelper.shared.formatDateToYearMonthDay(Date())
        userProfile.remindTime = reminderTime
    }
    
    func targetValidateForm() -> Bool {
        return !targetWeight.isEmpty
    }
    
    func reminderValidateForm() -> Bool {
        return !reminderTime.isEmpty
    }
    
    func submitProfile(completion: @escaping (Result<Void, Error>) -> Void) {
        ProfileAPIManager.shared.userProfileUpdate(userProfile: userProfile)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    completion(.success(()))
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    private func bindProfile() {
        $nickname
            .sink { [weak self] nickname in
                self?.userProfile.nickname = nickname
            }
            .store(in: &cancellables)
        
        $height
            .sink { [weak self] height in
                self?.userProfile.height = height
            }
            .store(in: &cancellables)
        
        $weight
            .sink { [weak self] weight in
                self?.userProfile.weight = weight
            }
            .store(in: &cancellables)
        
        $gender
            .sink { [weak self] gender in
                self?.userProfile.gender = gender
            }
            .store(in: &cancellables)
    }
    
    func updateFields(from userProfile: UserProfile) {
        self.userProfile = userProfile
        self.nickname = userProfile.nickname
        self.height = userProfile.height
        self.weight = userProfile.weight
        self.gender = userProfile.gender
        self.targetWeight = userProfile.targetWeight
        self.targetDate = DateHelper.shared.dateFromServerString(userProfile.targetDate) ?? Date()
        self.reminderTime = userProfile.remindTime
    }
    
    func debugPrint() {
        print("Nickname: \(nickname)")
        print("Height: \(height)")
        print("Weight: \(weight)")
        print("Gender: \(gender)")
        print("Target Weight: \(targetWeight)")
        print("Target Date: \(targetDate)")
        print("Reminder Time: \(reminderTime)")
        print("Created Date: \(userProfile.createdDate)")
        print("Can Eat Calorie: \(userProfile.canEatCalorie)")
    }
}
