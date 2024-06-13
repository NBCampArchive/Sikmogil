//
//  apiTest.swift
//  Sikmogil
//
//  Created by 희라 on 6/14/24.
//  테스트용 뷰 입니다.

import UIKit
import Alamofire

class APITestViewController: UIViewController {
    
    // MARK: - Properties
    
    let apiManager = FoodDbInfoAPIManager()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "식품명을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("검색", for: .normal)
        button.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Button Action
    
    @objc func searchButtonTapped(_ sender: UIButton) {
        guard let searchText = searchTextField.text, !searchText.isEmpty else {
            // 검색어가 비어 있을 경우 알림을 표시하거나 사용자에게 메시지를 보여줄 수 있음
            print("검색어를 입력해주세요.")
            return
        }
        
        apiManager.fetchFoodItems(searchQuery: searchText) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    // API 응답 처리
                    self.handleSuccessResponse(items)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    // 에러 처리
                    self.handleError(error)
                }
            }
        }
    }
    
    // MARK: - Response Handling
    
    private func handleSuccessResponse(_ items: [FoodItem]) {
        // 성공적으로 데이터를 받아왔을 때 처리할 작업 추가
        print("API 응답:")
        for item in items {
            print("식품명: \(item.foodNmKr)")
            print("칼로리: \(item.amtNum1)Kcal")
        }
        // UI 업데이트 또는 추가 작업 수행
    }
    
    private func handleError(_ error: Error) {
        // API 요청 중 발생한 에러 처리
        print("데이터를 가져오는 중 오류 발생: \(error.localizedDescription)")
        // 사용자에게 알림을 표시하거나 필요한 작업 수행
    }
}

