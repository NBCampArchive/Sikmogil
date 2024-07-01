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
        
        print("Uploading images to \(directory) with URL: \(url)")
        
        session.upload(multipartFormData: { multipartFormData in
            // directory 추가
            for (key, value) in parameters {
                if let valueData = "\(value)".data(using: .utf8) {
                    multipartFormData.append(valueData, withName: key)
                }
            }
            // 이미지 배열 추가
            for (index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    let fileName = "\(Date().timeIntervalSince1970)_\(index).jpg"
                    multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
                }
            }
        }, to: url).validate().responseDecodable(of: ImageModel.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print("Upload failed with error: \(error.localizedDescription)")
                if let afError = error.asAFError, afError.isResponseSerializationError {
                    print("Response serialization error")
                }
                completion(.failure(error))
            }
        }
        
    }
}
