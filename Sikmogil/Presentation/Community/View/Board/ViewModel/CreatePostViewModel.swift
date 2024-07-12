//
//  AddBoardViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/2/24.
//

import Combine
import Foundation
import UIKit

class CreatePostViewModel {
    @Published var title: String = ""
    @Published var category: String = ""
    @Published var content: String = ""
    @Published var images: [UIImage] = []
    @Published var postCreationCompleted: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func createPost() {
        // 이미지를 업로드할 필요가 없으면 직접 빈 배열로 설정
        if images.isEmpty {
            sendPostRequest(with: "")
        } else {
            uploadImages { [weak self] urls in
                guard let self = self else { return }
                let urlString = urls?.joined(separator: ", ") ?? ""
                self.sendPostRequest(with: urlString)
            }
        }
    }
    
    private func sendPostRequest(with urls: String) {
        let post = PostModel(title: self.title, category: self.category, content: self.content, imageUrl: urls)
        
        BoardAPIManager.shared.createPost(board: post)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.postCreationCompleted = true
                    print("Post created successfully")
                case .failure(let error):
                    print("Failed to create post: \(error.localizedDescription)")
                }
            }, receiveValue: { response in
                print("Server Response: \(response.message), Data: \(response.data)")
            })
            .store(in: &self.cancellables)
    }
    
    private func uploadImages(completion: @escaping ([String]?) -> Void) {
        ImageAPIManager.shared.uploadImage(directory: "post_images", images: images) { result in
            switch result {
            case .success(let imageModel):
                print("Images uploaded successfully: \(imageModel.data)")
                completion(imageModel.data)
            case .failure(let error):
                print("Failed to upload images: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
