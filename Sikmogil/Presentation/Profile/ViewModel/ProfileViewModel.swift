//
//  ProfileViewModel.swift
//  Sikmogil
//
//  Created by Developer_P on 6/15/24.
//  [프로필 뷰모델] 🔥 뷰 모델 🔥

import Foundation
import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    // MARK: - 데이터가 변경될 때 UI를 업데이트를 관리
    @Published var userProfile = UserProfile(nickname: "", height: "", weight: "", gender: "", targetWeight: "", targetDate: "", canEatCalorie: 0, createdDate: "", remindTime: "", picture: "")
    @Published var nickname = ""
    @Published var height = ""
    @Published var weight = ""
    @Published var gender = ""
    @Published var picture = ""
    @Published var targetWeight = ""
    @Published var targetDate = Date()
    @Published var reminderTime = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - 가져온 정보들을 인스턴스 생성될때 호출 및 초기화
    init() {
        fetchUserProfile()
    }
    
    // MARK: - 사용자 정보를 서버에서 가져옴
    func fetchUserProfile() {
        ProfileAPIManager.shared.getUserInfo()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching user profile: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] userResponse in
                guard let self = self else { return }
                self.updateFields(from: userResponse.data)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 관리되고 있는 프로필 관련 속성들의 값을 userProfile 객체에 저장
    func saveProfileData() {
        userProfile.picture = picture
        userProfile.nickname = nickname
        userProfile.height = height
        userProfile.weight = weight
        userProfile.gender = gender
    }
    
    // MARK: - 목표 체중관련 데이터가 유효한지 검증역할
    func targetValidateForm() -> Bool {
        return !targetWeight.isEmpty
    }
    
    // MARK: - 목표 데이터 저장
    func saveTargetData() {
        userProfile.targetWeight = targetWeight
        userProfile.targetDate = DateHelper.shared.formatDateToYearMonthDay(targetDate)
    }
    
    // MARK: - 리마인더 데이터 확인 및 저장
    func reminderValidateForm() -> Bool {
        return !reminderTime.isEmpty
    }
    
    func saveReminderData() {
        userProfile.createdDate = DateHelper.shared.formatDateToYearMonthDay(Date())
        userProfile.remindTime = reminderTime
        print("Reminder Time: \(userProfile.remindTime)")
        calculateCanEatCalorie()
    }
    
    func calculateCanEatCalorie() {
        var bmr: Double = 0.0
        let weightValue = 10 * (Double(weight) ?? 0)
        let heightValue = 6.25 * (Double(height) ?? 0)
        let ageValue = 5 * Double(20)
        
        if userProfile.gender == "남자" {
            bmr = weightValue + heightValue - ageValue + 5
        } else {
            bmr = weightValue + heightValue - ageValue - 161
        }
        
        print("\(userProfile.gender) BMR: \(bmr)")
        userProfile.canEatCalorie = Int(bmr)
    }
    
    // MARK: - 서버에 프로필 정보를 제출 및 요청
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
    
    // MARK: - 외부 데이터에서 받은 사용자 프로필 데이터를 업데이트
    func updateFields(from userProfile: UserProfile) {
        self.userProfile = userProfile
        self.nickname = userProfile.nickname
        self.height = userProfile.height
        self.weight = userProfile.weight
        self.gender = userProfile.gender
        self.picture = userProfile.picture ?? ""
        self.targetWeight = userProfile.targetWeight
        self.targetDate = DateHelper.shared.dateFromServerString(userProfile.targetDate) ?? Date()
        self.reminderTime = userProfile.remindTime
        self.userProfile.picture = self.picture
    }
    
    // MARK: - 이미지 업로드 요청
    func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        ImageAPIManager.shared.uploadImage(directory: "profile", images: [image]) { [weak self] result in
            switch result {
            case .success(let imageModel):
                if let firstURLString = imageModel.data.first, let imageURL = URL(string: firstURLString) {
                    self?.picture = imageURL.absoluteString
                    completion(.success(imageURL))
                } else {
                    completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 디버깅
    func debugPrint() {
        print("Nickname: \(nickname)")
        print("Height: \(height)")
        print("Weight: \(weight)")
        print("Gender: \(gender)")
        print("Picture URL: \(picture)")
        print("Target Weight: \(targetWeight)")
        print("Target Date: \(targetDate)")
        print("Reminder Time: \(reminderTime)")
        print("Created Date: \(userProfile.createdDate)")
        print("Can Eat Calorie: \(userProfile.canEatCalorie)")
    }
}
