//
//  ImageAPIManager.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/12/24.
//

import Foundation
import Alamofire
import UIKit

class ImageAPIManager {
    
    static let shared = ImageAPIManager()
    
    private init() {}
    
    private let baseURL = Bundle.main.baseURL
    
    private let session: Session = {
        let interceptor = AuthInterceptor()
        return Session(interceptor: interceptor)
    }()
    
    func uploadImage(directory: String, images: [UIImage], completion: @escaping (Result<ImageModel, Error>) -> Void) {
        
        let url = "\(baseURL)/api/image/upload"
        
        var parameters: [String: Any] = [
            "directory": directory,
        ]
        
        print("\(directory) \(images)")
        
        session.upload(multipartFormData: { multipartFormData in
            // directory 추가
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            // 이미지 배열 추가
            for (index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 1) {
                    multipartFormData.append(imageData, withName: "image", fileName: "\(Date())\(index).jpg", mimeType: "image/jpeg")
                }
            }
        }, to: url).responseDecodable(of: ImageModel.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}

//MARK: - 예시 코드
//        let images = [UIImage(named: "calendar")!]
//        ImageAPIManager.shared.uploadImage(directory: "diet", images: images) { result in
//            switch result {
//            case .success(let data):
//                var imageURL = data.data
//                print("uploadImage success\(imageURL)")
//                //MARK: - 식단 사진 추가
//                DietAPIManager.shared.addDietPicture(date: DateHelper.shared.formatDateToYearMonthDay(Date()), pictureData: imageURL[0]) { result in
//                    switch result {
//                    case .success:
//                        print("success")
//                    case .failure(_):
//                        print("failure")
//                    }
//
//                }
//                //MARK: - 운동 리스트에 사진 추가(ExerciseAPIManager 에 사진 Parameter 주석 해제하시고 테스트해보셔야해요!)
//                //API 내부(뷰모델 안에서 불러오면 다른식으로도 할 수 있을 것 같아요)
//                self?.viewModel.expectedPicture = imageURL[0]
//                //ViewModel
//                @Published var expectedPicture: String = ""
//                return ExerciseListModel(
//                    workoutPicture: expectedPicture,
//                    calorieBurned: expectedCalories
//                )
//            case .failure(let error):
//                print("uploadImage failure")
//                print(error)
//            }
//        }
