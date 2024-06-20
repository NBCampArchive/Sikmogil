//
//  OnboardingViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class OnboardingViewController: UIViewController {
    
    let viewModel = OnboardingViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let progressBar = OnboardingProgressBar().then {
        $0.setProgress(0.33)
    }
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
        $0.view.backgroundColor = .clear
    }
    
    private var currentIndex = 0
    
    private lazy var orderedViewControllers: [UIViewController] = {
        let step1VC = Step1ViewController()
        step1VC.viewModel = viewModel
        let step2VC = Step2ViewController()
        step2VC.viewModel = viewModel
        let step3VC = Step3ViewController()
        step3VC.viewModel = viewModel
        return [step1VC, step2VC, step3VC]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupPageViewController()
        bindViewModel()
        
        if let firstViewController = orderedViewControllers.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupLayout() {
        view.addSubviews(progressBar, pageViewController.view)
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(15)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupPageViewController() {
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    private func updateProgressBar() {
        let progress = Float(viewModel.currentIndex.value + 1) / Float(orderedViewControllers.count)
        progressBar.setProgress(progress)
    }
    
    private func bindViewModel() {
        viewModel.currentIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.setViewcontrollersFromIndex(index: index)
            })
            .disposed(by: disposeBag)
    }
    
    private func setViewcontrollersFromIndex(index: Int) {
        if index < orderedViewControllers.count {
            let viewController = orderedViewControllers[index]
            pageViewController.setViewControllers([viewController], direction: .forward, animated: true) { [weak self] completed in
                guard let self = self else { return }
                if completed {
                    print("Page transition completed")
                    self.updateProgressBar()
                } else {
                    print("Page transition not completed")
                }
            }
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return orderedViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController), index < orderedViewControllers.count - 1 else {
            return nil
        }
        return orderedViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
               let index = orderedViewControllers.firstIndex(of: currentViewController) {
                viewModel.currentIndex.accept(index)
                updateProgressBar()
            }
        }
    }
}
