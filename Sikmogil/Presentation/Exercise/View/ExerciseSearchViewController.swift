//
//  ExerciseSearchViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 7/16/24.
//

import UIKit
import SnapKit
import Then

class ExerciseSearchViewController: UIViewController {
    // MARK: - Properties
    var searchResults: [String] = []
    var exerciseList: [String] = ["운동1", "운동2", "운동3", "운동4", "운동5", "운동6", "운동7"]
    
    // MARK: - Components
    let titleLabel = UILabel().then {
        $0.text = "운동 종목"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 24)
        $0.textAlignment = .left
    }
    
    let addDirectButton = UIButton().then {
        $0.setTitle("+ 직접 추가", for: .normal)
        $0.backgroundColor = .appBlack
        $0.layer.cornerRadius = 16
    }
   
    let searchBar = UISearchBar().then {
        $0.placeholder = "무슨 운동을 하셨나요?"
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.layer.borderWidth = 1
        $0.searchTextField.layer.borderColor = UIColor.appBlack.cgColor
        $0.searchTextField.layer.cornerRadius = 10
        $0.tintColor = .appBlack
        $0.setValue("취소", forKey: "cancelButtonText")
        $0.backgroundImage = UIImage()
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(ExerciseItemCell.self, forCellReuseIdentifier: ExerciseItemCell.identifier)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        navigationController?.navigationBar.isHidden = false
        configureKeyboard()
    }
    
    // MARK: - Setup View
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(titleLabel, addDirectButton, searchBar, tableView)
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(16)
        }
        
        searchBar.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Keyboard Configuration
    private func configureKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            tableView.contentInset.bottom = keyboardFrame.height
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset.bottom = 0
    }
}

extension ExerciseSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = exerciseList
        } else {
            searchResults = exerciseList.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchResults = exerciseList
        tableView.reloadData()
        dismissKeyboard()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension ExerciseSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseItemCell.identifier, for: indexPath) as? ExerciseItemCell else {
            return UITableViewCell()
        }
        cell.exerciseLabel.text = searchResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
