//
//  ExerciseMenuViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/10/24.
//

import UIKit
import Then

class ExerciseMenuViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 22
        stackView.alignment = .fill
        return stackView
    }()
    
    let exerciseMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("운동", for: .normal)
        button.titleLabel?.font = Suite.bold.of(size: 28)
        button.tintColor = .appBlack
        return button
    }()
    
    let stepsMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("걸음 수", for: .normal)
        button.titleLabel?.font = Suite.bold.of(size: 28)
        button.tintColor = .appDarkGray
        return button
    }()
    
    private var currentChildViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
        showFirstView()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(headerStackView)
        headerStackView.addArrangedSubviews(exerciseMenuButton, stepsMenuButton)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(28)
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(scrollView.snp.height).offset(-36)
        }
        viewController.didMove(toParent: self)
        currentChildViewController = viewController
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    // MARK: - Setup Button
    private func setupButtons() {
        exerciseMenuButton.addTarget(self, action: #selector(showFirstView), for: .touchUpInside)
        stepsMenuButton.addTarget(self, action: #selector(showSecondView), for: .touchUpInside)
    }

    @objc private func showFirstView() {
        let exerciseVC = ExerciseViewController()
        transition(to: exerciseVC)
        updateButtonColors(selectedButton: exerciseMenuButton)
    }

    @objc private func showSecondView() {
        let stepsVC = StepsViewController()
        transition(to: stepsVC)
        updateButtonColors(selectedButton: stepsMenuButton)
    }

    private func transition(to viewController: UIViewController) {
        if let currentVC = currentChildViewController {
            remove(asChildViewController: currentVC)
        }
        add(asChildViewController: viewController)
    }

    private func updateButtonColors(selectedButton: UIButton) {
        let buttons = [exerciseMenuButton, stepsMenuButton]
        buttons.forEach { button in
            button.tintColor = (button == selectedButton) ? .appBlack : .appDarkGray
        }
    }
}
