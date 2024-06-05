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
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(15)
        }
    }
    
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
            currentIndex += 1
            setViewControllers([orderedViewControllers[currentIndex]], direction: .forward, animated: true, completion: nil)
            updateProgressBar()
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
