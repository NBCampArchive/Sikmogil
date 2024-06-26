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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //MARK: - 포그라운드 알림 설정
        UNUserNotificationCenter.current().delegate = self
        print(UserDefaults.standard.bool(forKey: "NotificationEnabled"))
        
        //MARK: - 네비게이션 바의 스타일을 전역적으로 설정
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
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }


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

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if UserDefaults.standard.bool(forKey: "NotificationEnabled") {
            completionHandler([.banner, .sound])
        } else {
            completionHandler([])
        }
//        completionHandler([.banner, .sound])
    }
    
}
