//
//  BoardMainViewController.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/18/24.
//

import UIKit
import SnapKit
import Then
import Combine

class BoardMainViewController: UIViewController {
    
    //MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    private let segmentedControl = UISegmentedControl(items: ["전체", "다이어트", "운동", "자유"]).then {
        $0.selectedSegmentIndex = 0
    }
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
        $0.view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupPageViewController()
    }
    
    private func setupViews() {
        view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func setupConstraints() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupPageViewController() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        // 초기 페이지 설정
        if let firstVC = viewControllerAtIndex(index: 0) {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @objc private func segmentChanged() {
        let index = segmentedControl.selectedSegmentIndex
        if let viewController = viewControllerAtIndex(index: index) {
            let direction: UIPageViewController.NavigationDirection = index > (pageViewController.viewControllers?.first?.view.tag ?? 0) ? .forward : .reverse
            pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
        }
    }
    
    private func viewControllerAtIndex(index: Int) -> UIViewController? {
        // 각 인덱스에 해당하는 뷰 컨트롤러 반환
        switch index {
        case 0:
            return StepsViewController().then { $0.view.tag = 0 }
        case 1:
            return ViewController().then { $0.view.tag = 1 }
        case 2:
            return StepsViewController().then { $0.view.tag = 2 }
        case 3:
            return ViewController().then { $0.view.tag = 3 }
        default:
            return nil
        }
    }
}

extension BoardMainViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        index -= 1
        return viewControllerAtIndex(index: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        index += 1
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first {
            segmentedControl.selectedSegmentIndex = currentViewController.view.tag
        }
    }
}
