//
//  OnboardingViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/5/24.
//

import UIKit
import SnapKit
import Then

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let viewModel = OnboardingViewModel()
    
    private let progressBar = OnboardingProgressBar().then {
        $0.setProgress(0.33)
    }
    
    private let containerView = UIView()
    
    private var currentIndex = 0
    
    private lazy var orderedViewControllers: [UIViewController] = {
        return [Step1ViewController(),
                Step2ViewController(),
                Step3ViewController()]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = .white
        
        if let firstViewController = orderedViewControllers.first {
            addChild(firstViewController)
            containerView.addSubview(firstViewController.view)
            firstViewController.view.frame = containerView.bounds
            firstViewController.didMove(toParent: self)
        }
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubviews(progressBar, containerView)
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    private lazy var viewControllersContainer: UIView = {
            let containerView = UIView()
            containerView.backgroundColor = .clear
            addChild(self)
            containerView.addSubview(self.view)
            self.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.didMove(toParent: self)
            return containerView
        }()
        
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
                if let currentViewController = viewControllers?.first,
                   let index = orderedViewControllers.firstIndex(of: currentViewController) {
                    currentIndex = index
                    updateProgressBar()
                }
            }
        }
        
        private func updateProgressBar() {
            let progress = Float(currentIndex + 1) / Float(orderedViewControllers.count)
            progressBar.setProgress(progress)
        }
        
        func moveToNextPage() {
            if currentIndex < orderedViewControllers.count - 1 {
                let nextIndex = currentIndex + 1
                let nextViewController = orderedViewControllers[nextIndex]
                
                setViewControllers([nextViewController], direction: .forward, animated: true) { [weak self] _ in
                    self?.updateProgressBar()
                    self?.currentIndex = nextIndex
                }
            }
        }
    
}

extension UIViewController {
    var onboardingPageViewController: OnboardingPageViewController? {
        var parentController = parent
        while parentController != nil {
            if let onboardingPageVC = parentController as? OnboardingPageViewController {
                return onboardingPageVC
            }
            parentController = parentController?.parent
        }
        return nil
    }
}
