//
//  AddBoardViewModel.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/2/24.
//

import Combine
import Foundation

class AddBoardViewModel {
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func addBoard(category: String, title: String, content: String) {
        guard !isLoading else { return }
        isLoading = true
        BoardAPIManager.shared.addBoard(category: category, title: title, content: content)
            .print("addBoard")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                print(response)
            })
            .store(in: &cancellables)
    }
}
