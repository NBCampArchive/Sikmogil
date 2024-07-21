//
//  CommentListViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 7/21/24.
//

import UIKit
import SnapKit
import Then
import FloatingPanel
import Combine

class CommentListViewController: UIViewController {
    private let viewModel = CommentViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView = UITableView().then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentCell")
        $0.delegate = self
        $0.dataSource = self
        $0.tableHeaderView = headerView
        $0.keyboardDismissMode = .interactive
    }
    
    private lazy var headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80)).then {
        let titleLabel = UILabel().then {
            $0.text = "댓글"
            $0.font = Suite.bold.of(size: 24)
        }
        $0.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    private let inputContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
    }
    
    private let commentTextField = UITextField().then {
        $0.placeholder = "댓글을 입력하세요..."
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var sendButton = UIButton().then {
        $0.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        $0.tintColor = .appBlack
        $0.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBindings()
        viewModel.fetchComments()
        
        hideKeyboardWhenTappedAround()
        setKeyboardObserver()
        view.backgroundColor = .white
    }
    
    private func setupViews() {
        view.addSubviews(tableView, inputContainerView)
        inputContainerView.addSubviews(commentTextField, sendButton)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(inputContainerView.snp.top)
        }
        
        inputContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(50)
        }
        
        commentTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }
        
        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
        }
    }
    
    private func setupBindings() {
        viewModel.$comments
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func sendButtonTapped() {
        guard let comment = commentTextField.text, !comment.isEmpty else { return }
        //            viewModel.addComment(comment)
        commentTextField.text = ""
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.3) {
                self.inputContainerView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.inputContainerView.transform = .identity
        }
    }
}

extension CommentListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        let comment = viewModel.comments[indexPath.row]
        cell.configure(with: comment)
        return cell
    }
}
