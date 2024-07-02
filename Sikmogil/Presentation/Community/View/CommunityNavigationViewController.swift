//
//  CommunityNavigationViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/18/24.
//

import UIKit
import SnapKit
import Then

class CommunityNavigationViewController: UIViewController {
    // MARK: - Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 22
        $0.alignment = .fill
    }
    
    let exerciseMenuButton = UIButton(type: .system).then {
        $0.setTitle("게시글", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 28)
        $0.tintColor = .appBlack
    }
    
    let stepsMenuButton = UIButton(type: .system).then {
        $0.setTitle("챌린지", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 28)
        $0.tintColor = .appDarkGray
    }
    
    private var currentChildViewController: UIViewController?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupButtons()
        showFirstView()
    }

    // MARK: - Setup Views
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
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(28)
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(scrollView.snp.height).offset(-36)
        }
        viewController.didMove(toParent: self)
        currentChildViewController = viewController
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    // MARK: - Setup Buttons
    private func setupButtons() {
        exerciseMenuButton.addTarget(self, action: #selector(showFirstView), for: .touchUpInside)
        stepsMenuButton.addTarget(self, action: #selector(showSecondView), for: .touchUpInside)
    }

    @objc private func showFirstView() {
        let boardVC = BoardMainViewController()
        transition(to: boardVC)
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
