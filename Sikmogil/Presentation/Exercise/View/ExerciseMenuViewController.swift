//
//  ExerciseMenuViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/10/24.
//

import UIKit
import SnapKit
import Then

class ExerciseMenuViewController: UIViewController {

    private var currentChildViewController: UIViewController?

    // MARK: - Components
    private let contentView = UIView()
    
    private let headerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 22
        $0.alignment = .fill
    }
    
    let exerciseMenuButton = UIButton(type: .system).then {
        $0.setTitle("운동", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 24)
        $0.tintColor = .appBlack
    }
    
    let stepsMenuButton = UIButton(type: .system).then {
        $0.setTitle("걸음 수", for: .normal)
        $0.titleLabel?.font = Suite.bold.of(size: 24)
        $0.tintColor = .appDarkGray
    }
    
    let plusMenuButton = UIButton(type: .system).then {
        $0.setImage(.listPlusButton, for: .normal)
        $0.tintColor = .appBlack
    }
  
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
        view.addSubview(contentView)
        contentView.addSubviews(headerStackView)
        headerStackView.addArrangedSubviews(exerciseMenuButton, stepsMenuButton)
        contentView.addSubview(plusMenuButton)
    }

    private func setupConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(28)
        }
        
        plusMenuButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(headerStackView)
        }
    }

    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
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
        plusMenuButton.addTarget(self, action: #selector(plusMenuButtonButtonTapped), for: .touchUpInside)
    }

    @objc private func showFirstView() {
        let exerciseVC = ExerciseViewController()
        transition(to: exerciseVC)
        plusMenuButton.isHidden = false
        updateButtonColors(selectedButton: exerciseMenuButton)
    }

    @objc private func showSecondView() {
        let stepsVC = StepsViewController()
        transition(to: stepsVC)
        plusMenuButton.isHidden = true
        updateButtonColors(selectedButton: stepsMenuButton)
    }
    
    @objc private func plusMenuButtonButtonTapped() {
        let exerciseSelectionVC = ExerciseSelectionViewController()
        exerciseSelectionVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(exerciseSelectionVC, animated: true)
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
