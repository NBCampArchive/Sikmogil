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
