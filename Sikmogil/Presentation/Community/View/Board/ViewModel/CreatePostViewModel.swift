//
//  AddBoardViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/2/24.
//

import Combine
import Foundation

class CreatePostViewModel {
    @Published var title: String = ""
        @Published var category: String = "DIET"
        @Published var content: String = ""
        @Published var imageUrl: [String] = []
        
        private var cancellables = Set<AnyCancellable>()
        
    func createPost() {
        let post = PostModel(title: title, category: category, content: content, imageUrl: imageUrl.isEmpty ? nil : imageUrl)
        
        BoardAPIManager.shared.createPost(board: post)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Post created successfully")
                case .failure(let error):
                    print("Failed to create post: \(error.localizedDescription)")
                }
            }, receiveValue: { response in
                print("Server Response: \(response.message)")
            })
            .store(in: &cancellables)
    }
}
