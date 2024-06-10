//
//  StepsViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/5/24.
//

import UIKit

class StepsViewController: UIViewController {

    // MARK: - Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .appLightGray
        view.layer.cornerRadius = 100
        return view
    }()
    
    private let stepsImage: UIImageView = {
         let imageView  = UIImageView()
         imageView.image = .steps
         imageView.contentMode = .scaleAspectFit
         return imageView
     }()
    
    private let stepsLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 걸음 수"
        label.font = Suite.medium.of(size: 18)
        label.textColor = .appBlack
        return label
    }()
    
    private let stepsValueLabel: UILabel = {
        let label = UILabel()
        label.text = "15,000"
        label.font = Suite.bold.of(size: 50)
        label.textColor = .appBlack
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 만보 걷기"
        label.font = Suite.semiBold.of(size: 18)
        label.textColor = .appBlack
        return label
    }()
    
    private let goalValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0% 달성"
        label.font = Suite.regular.of(size: 12)
        label.textColor = .appBlack
        return label
    }()
    
    private let goalValueView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.appBlack.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        return view
    }()

    private let goalProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .appGreen
        view.layer.cornerRadius = 10
        return view
    }()
    // TODO: 걷기 프로그레스
    
    private let subCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .appLightGray
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let kcalLabel: UILabel = {
        let label = UILabel()
        label.text = "소모량 30kcal"
        label.font = Suite.semiBold.of(size: 20)
        label.textColor = .appBlack
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup View
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(circleView, stepsLabel, stepsValueLabel, cardView)
        circleView.addSubview(stepsImage)
        cardView.addSubviews(goalLabel, goalValueView, goalProgressView, subCardView)
        goalValueView.addSubview(goalValueLabel)
        subCardView.addSubview(kcalLabel)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        circleView.snp.makeConstraints {
            $0.width.height.equalTo(200)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(60)
        }
        
        stepsImage.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        stepsLabel.snp.makeConstraints {
            $0.top.equalTo(circleView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        stepsValueLabel.snp.makeConstraints {
            $0.top.equalTo(stepsLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        cardView.snp.makeConstraints {
            $0.top.equalTo(stepsValueLabel.snp.bottom).offset(64)
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.height.equalTo(160)
        }
        
        goalLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        goalValueView.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(24)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(goalLabel)
        }
        
        goalValueLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        goalProgressView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(subCardView.snp.top).inset(-10)
            $0.height.equalTo(20)
        }
        
        subCardView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(38)
        }
        
        kcalLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(cardView.snp.bottom).offset(30)
        }
    }
}
