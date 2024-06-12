//
//  AddDietMenuViewController.swift
//  Sikmogil
//
//  Created by 희라 on 6/4/24.
//  [View] **설명** 식사추가 페이지

import UIKit
import FloatingPanel

class AddDietMenuViewController: UIViewController {
    
    let TitleLabel = UILabel().then {
        $0.text = "식사 추가"
        $0.textColor = .appBlack
        $0.font = Suite.bold.of(size: 28)
        $0.textAlignment = .left
    }
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "무슨 음식을 드셨나요?"
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.layer.borderWidth = 1
        $0.searchTextField.layer.borderColor = UIColor.appBlack.cgColor
        $0.searchTextField.layer.cornerRadius = 10
    }
    
    let searchResultTableView = UITableView().then {
        $0.backgroundColor = .appLightGray
        $0.register(AddDietMenuTableViewCell.self, forCellReuseIdentifier: "AddDietMenuTableViewCell")
        $0.separatorStyle = .none
    }

    override func viewDidLoad() {
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
    }
    
    
    private func setupViews() {
        view.addSubviews(TitleLabel, searchBar, searchResultTableView)
    }
    
    private func setupConstraints() {
        
        TitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(16)
        }
        searchBar.snp.makeConstraints{
            $0.top.equalTo(TitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        searchResultTableView.snp.makeConstraints{
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

}


extension AddDietMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddDietMenuTableViewCell", for: indexPath) as? AddDietMenuTableViewCell else {
            return UITableViewCell()
        }
        
        // 셀 구성 (필요에 따라 설정)
        //cell.textLabel?.text = "Item \(indexPath.row + 1)"
        
        return cell
    }
    
}
