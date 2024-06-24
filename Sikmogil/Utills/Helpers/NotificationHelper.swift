//
//  NotificationHelper.swift
//  Sikmogil
//
//  Created by Developer_P on 6/14/24.
//

import Foundation
import UserNotifications
import Then

class NotificationHelper {
    
    static let shared = NotificationHelper()

    // 초기화 방지
    private init() {}
    
    // MARK: - 알림 권한 요청 메서드
    // 사용자에게 알림 권한을 요청하고 결과를 completion 핸들러로 반환
    // Parameter completion: 권한 부여 여부와 오류를 반환하는 클로저
    func requestNotificationPermission(completion: @escaping (Bool, Error?) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }
    
    // MARK: - 알림 스케줄링 메서드
    
    // 지정된 날짜 구성 요소에 맞춰 일일 알림을 스케줄링합니다.
    // dateComponents: 알림을 트리거할 날짜와 시간 구성 요소
    // completion: 알림 설정 결과를 반환하는 클로저 (선택 사항)
    func scheduleDailyNotification(at dateComponents: DateComponents, completion: ((Error?) -> Void)? = nil) {
        let content = UNMutableNotificationContent().then {
            $0.title = "리마인더"
            $0.body = "설정된 시간입니다!"
            $0.sound = .default
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "DailyReminderNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("알림 설정 실패: \(error.localizedDescription)")
                } else {
                    print("알림이 성공적으로 설정되었습니다: \(dateComponents)")
                }
                completion?(error)
            }
        }
    }
    
    // MARK: - 타이머 알림 메서드
    func timerNotification() {
        let content = UNMutableNotificationContent().then {
            $0.title = "Sikmogil"
            $0.body = "운동이 끝났습니다!"
            $0.sound = .default
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "timerNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("알림 설정 실패: \(error.localizedDescription)")
                } else {
                    print("즉시 알림이 성공적으로 설정되었습니다.")
                }
            }
        }
    }
    
    // MARK: - 단식 14시간 알림
    func fastingNotification() {
        guard let startTime = UserDefaults.standard.object(forKey: "startTime") as? Date else {
            print("Start time not found")
            return
        }
        
        let content = UNMutableNotificationContent().then {
            $0.title = "Sikmogil"
            $0.body = "단식 시간이 끝났습니다!"
            $0.sound = .default
        }
        
        let calendar = Calendar.current
        let notificationTime = calendar.date(byAdding: .hour, value: 14, to: startTime) ?? Date().addingTimeInterval(14 * 60 * 60)
        let notificationComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "fastingNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("알림 설정 실패: \(error.localizedDescription)")
                } else {
                    print("14시간 알림이 성공적으로 설정되었습니다.")
                }
            }
        }
    }
    
    //MARK: - 공복 알림 제거
    func removeFastingNotification() {
        let identifiers = ["fastingNotification"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        print("fastingNotification 알림이 성공적으로 제거되었습니다.")
    }
    
    // MARK: - 모든 알림 제거 메서드
    // 모든 예약된 알림을 제거
    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - 알림 설정 확인 메서드
    // 현재 알림 권한 상태를 확인하고 completion 핸들러로 반환
    // Parameter completion: 알림 권한 상태를 반환하는 클로저
    func checkNotificationSettings(completion: @escaping (UNAuthorizationStatus) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
}
