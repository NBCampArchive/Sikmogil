//
//  ProfileTableView.swift
//  Sikmogil
//
//  Created by Developer_P on 6/7/24.
//

import UIKit
import SnapKit
import Then

class ProfileTableView: UIView {
    
    // MARK: - 테이블 속성정의
    let tableView = UITableView().then {
        $0.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        $0.separatorStyle = .none // 구분선 제거
        $0.rowHeight = 60 // 커뮤니티 각 셀별 높이 지정
    }
    
    // MARK: - 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 설정
    private func setupUI() {
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        let titles = ["메달 확인", "작성한 게시글", "공감한 게시글"]
        let icons = ["cup", "pencilline", "heart"]
        cell.configure(with: titles[indexPath.row], iconName: icons[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
