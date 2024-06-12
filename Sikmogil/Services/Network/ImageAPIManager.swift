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
    
    let token = "Bearer \(LoginAPIManager.shared.getAccessTokenFromKeychain())"
    
    private var headers: HTTPHeaders {
        return [
            "Authorization": token,
            "Accept": "application/json"
        ]
    }
    
    func uploadImage(directory: String, images: [UIImage], completion: @escaping (Result<ImageModel, Error>) -> Void) {
        
        let url = "\(baseURL)/api/imageUpload"
        
        var parameters: [String: Any] = [
            "directory": directory,
        ]
        
        print("\(directory) \(images)")
        
        AF.upload(multipartFormData: { multipartFormData in
            // directory 추가
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            // 이미지 배열 추가
            for (index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 1) {
                    multipartFormData.append(imageData, withName: "image", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                }
            }
        }, to: url, headers: headers).responseDecodable(of: ImageModel.self) { response in
            switch response.result {
            case .success(let data):
                print("uploadImage success")
                print(data)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}

//예시코드
//let images = [UIImage(named: "calendar")!, UIImage(named: "calendar")!]
//ImageAPIManager.shared.uploadImage(directory: "diet", images: images) { result in
//    switch result {
//    case .success:
//        print("uploadImage success")
//        이부분에 사진을 받은 이후 게시글 작성 api, 운동 api 등 추가하시면 됩니다 
//    case .failure(let error):
//        print("uploadImage failure")
//        print(error)
//    }
//}
