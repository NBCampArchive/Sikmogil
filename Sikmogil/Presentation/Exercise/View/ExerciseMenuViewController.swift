//
//  ExerciseMenuViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/10/24.
//

import UIKit
import Then

class ExerciseMenuViewController: UIViewController {
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        showFirstView()
        setupButtons()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(containerView, headerStackView)
        headerStackView.addArrangedSubviews(exerciseMenuButton, stepsMenuButton)
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        headerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(28)
            $0.leading.equalToSuperview().offset(16)
        }
        // TODO: headerStackView 스크롤 되도록 수정
    }

    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
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
        if let currentVC = children.first {
            remove(asChildViewController: currentVC)
        }
        add(asChildViewController: viewController)
    }

    private func updateButtonColors(selectedButton: UIButton) {
        let buttons = [exerciseMenuButton, stepsMenuButton]
        buttons.forEach { button in
            if button == selectedButton {
                button.tintColor = .appBlack
            } else {
                button.tintColor = .appDarkGray
            }
        }
    }
}
