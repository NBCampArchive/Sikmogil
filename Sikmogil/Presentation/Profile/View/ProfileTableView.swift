//
//  ProfileTableView.swift
//  Sikmogil
//
//  Created by 박준영 on 6/7/24.
//  [프로필 테이블] 🏅(메달), 📝(게시글), ❤️(공감)

import UIKit
import SnapKit
import Then

class ProfileTableView: UIView {
    
    let tableView = UITableView().then {
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        $0.separatorStyle = .none
        $0.rowHeight = 60
    }
    
    private let titles = ["메달 확인", "작성한 게시글", "공감한 게시글"]
    private let iconNames = ["cup", "pencilline", "heart"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - setupTableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ProfileTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let iconName = iconNames[indexPath.row]
        cell.configure(with: title, iconName: iconName)
        
        return cell
    }
}

extension ProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let parentVC = self.parentViewController as? ProfileViewController {
            parentVC.didSelectCell(at: indexPath.row)
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let responder = parentResponder {
            parentResponder = responder.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
