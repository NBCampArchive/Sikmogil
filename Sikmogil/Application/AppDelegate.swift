//
//  AppDelegate.swift
//  Sikmogil
//
//  Created by 박현렬 on 5/31/24.
//

import UIKit
import CoreData
import GoogleSignIn
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationHelper = NotificationHelper.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        notificationHelper.requestNotificationPermission { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else {
                UserDefaults.standard.set(granted, forKey: "NotificationEnabled")
                self.notificationHelper.checkNotificationSettings { status in
                    switch status {
                    case .authorized:
                        print("알림 허용됨")
                    case .denied:
                        print("Notification denied")
                    case .notDetermined:
                        print("Notification not determined")
                    default:
                        break
                    }
                }
            }
        }
        // Override point for customization after application launch.
        // 네비게이션 바의 스타일을 전역적으로 설정
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = .black // 버튼의 색상
        
        // 네비게이션 바의 백 버튼 타이틀을 비우기
        let barButtonAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        barButtonAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

    // MARK: - Core Data stack 및 saveContext 메서드 추가
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Sikmogil")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
