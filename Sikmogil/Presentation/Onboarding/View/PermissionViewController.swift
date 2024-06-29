//
//  PermissionViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/20/24.
//

import UIKit
import SnapKit
import Then
import AVFoundation
import Photos

class PermissionViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "앱 서비스 접근 권한 안내"
        $0.font = Suite.bold.of(size: 24)
        $0.textAlignment = .center
        $0.textColor = .appBlack
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "식목일에서는 다음 권한들을 사용합니다 \n서비스 이용을 위해 권한을 허용해 주시기 바랍니다."
        $0.font = Suite.light.of(size: 12)
        $0.textColor = .appDarkGray
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let permissionItems: [(String, String, String)] = [
        ("알림", "푸시 알림 및 메시지 수신 안내를 위한 권한", "bell.badge.fill"),
        ("카메라", "식단, 운동 사진 촬영을 위한 권한", "camera.fill"),
        ("사진 라이브러리", "식단, 운동 사진 첨부를 위한 권한", "photo.fill"),
        ("건강", "걸음 수 확보를 위한 권한", "heart.fill")
    ]
    
    private let infoLabel = UILabel().then {
        $0.text = "* 권한을 허용하지 않아도 이용은 가능하지만\n일부 서비스가 제한될 수 있습니다."
        $0.font = Suite.light.of(size: 12)
        $0.textColor = .appDarkGray
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let confirmButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 22)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 8
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .leading
    }
    
    let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.alignment = .leading
    }
    
    let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .leading
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        requestCameraPermission()
        requestPhotoLibraryPermission()
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermission()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubviews(mainStackView, infoLabel, confirmButton)
        mainStackView.addArrangedSubviews(titleStackView, stackView)
        titleStackView.addArrangedSubviews(titleLabel, subTitleLabel)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-48)
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().offset(-32)
        }
        
        titleStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        for (title, description, image) in permissionItems {
            let itemStackView = createPermissionItem(title: title, description: description, image: image)
            stackView.addArrangedSubview(itemStackView)
        }
        
        infoLabel.snp.makeConstraints {
            $0.bottom.equalTo(confirmButton.snp.top).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    private func createPermissionItem(title: String, description: String, image: String) -> UIStackView {
        let iconView = UIImageView().then {
            $0.backgroundColor = .appLightGray
            $0.image = UIImage(systemName: image)
            $0.tintColor = .appBlack
            $0.contentMode = .center
            $0.layer.cornerRadius = 25
        }
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = Suite.bold.of(size: 18)
            $0.textColor = .appBlack
        }
        
        let descriptionLabel = UILabel().then {
            $0.text = description
            $0.font = Suite.regular.of(size: 14)
            $0.textColor = .darkGray
        }
        
        let textStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 4
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(descriptionLabel)
        }
        
        let itemStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 16
            $0.alignment = .center
            $0.addArrangedSubview(iconView)
            $0.addArrangedSubview(textStackView)
        }
        
        iconView.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        return itemStackView
    }
    
    @objc func confirmButtonTapped() {
        let bottomTabBarController = BottomTabBarController()
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            UIView.transition(with: window, duration: 0.7, options: .transitionFlipFromRight, animations: {
                window.rootViewController = bottomTabBarController
            })
            window.makeKeyAndVisible()
        }
        
    }
}

//MARK: - UNUserNotificationCenterDelegate
extension PermissionViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    private func requestNotificationPermission() {
        
        NotificationHelper.shared.requestNotificationPermission { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else {
                UserDefaults.standard.set(granted, forKey: "NotificationEnabled")
                NotificationHelper.shared.checkNotificationSettings { status in
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
    }
}

//MARK: - 사진, 카메라 권한 요청
extension PermissionViewController {
    private func requestCameraPermission() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            // 사용자가 아직 카메라 접근 권한을 부여하지 않은 경우
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    print("카메라 접근 권한이 부여되었습니다.")
                } else {
                    print("카메라 접근 권한이 거부되었습니다.")
                }
            }
        case .restricted, .denied:
            print("카메라 접근 권한이 거부되었습니다.")
            // TODO: - 사용자에게 설정에서 권한을 변경하도록 안내하는 코드 추가
        case .authorized:
            print("카메라 접근 권한이 이미 부여되었습니다.")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    private func requestPhotoLibraryPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .notDetermined:
            // 사용자가 아직 사진 접근 권한을 부여하지 않은 경우
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("사진 접근 권한이 부여되었습니다.")
                case .denied, .restricted:
                    print("사진 접근 권한이 거부되었습니다.")
                case .limited:
                    print("사진 접근 권한이 제한적으로 부여되었습니다.")
                case .notDetermined:
                    print("사진 접근 권한을 결정하지 못했습니다.")
                @unknown default:
                    fatalError("Unknown authorization status")
                }
            }
        case .restricted, .denied:
            print("사진 접근 권한이 거부되었습니다.")
            // TODO: - 사용자에게 설정에서 권한을 변경하도록 안내하는 코드 추가
        case .authorized:
            print("사진 접근 권한이 이미 부여되었습니다.")
        case .limited:
            print("사진 접근 권한이 제한적으로 부여되었습니다.")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
}

//MARK: - 건강 권한 요청
extension PermissionViewController {
    private func requestHealthKitAuthorization(completion: @escaping (Bool) -> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let dataTypesToRead: Set<HKObjectType> = [stepCountType]
        
        healthStore.requestAuthorization(toShare: nil, read: dataTypesToRead) { (success, error) in
            if success {
                print("HealthKit authorization granted")
                completion(true)
            } else {
                print("HealthKit authorization denied")
                if let error = error {
                    print(error.localizedDescription)
                }
                completion(false)
            }
        }
    }
}
