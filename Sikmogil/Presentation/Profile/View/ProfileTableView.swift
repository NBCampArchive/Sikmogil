//
//  ProfileTableView.swift
//  Sikmogil
//
//  Created by Developer_P on 6/7/24.
//  [프로필 테이블] 🏅(메달), 📝(게시글), ❤️(공감)

import UIKit
import SnapKit
import Then

class ProfileTableView: UIView {
    
    // MARK: - 테이블 속성
    let tableView = UITableView().then {
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        $0.separatorStyle = .none
        $0.rowHeight = 60
    }
    
    private var cellData: [ProfileTableViewCellData] = [
        ProfileTableViewCellData(title: "메달 확인", iconName: "cup"),
        ProfileTableViewCellData(title: "작성한 게시글", iconName: "pencilline"),
        ProfileTableViewCellData(title: "공감한 게시글", iconName: "heart")
    ]
    
    // MARK: - 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 제약조건
    private func setupConstraints() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - 테이블뷰 설정
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension ProfileTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        let data = cellData[indexPath.row]
        cell.configure(with: data.title, iconName: data.iconName)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // ProfileViewController에서 직접 처리할 수 있도록 합니다.
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
