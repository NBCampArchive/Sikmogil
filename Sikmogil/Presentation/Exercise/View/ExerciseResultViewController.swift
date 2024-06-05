//
//  ExerciseResultViewController.swift
//  Sikmogil
//
//  Created by 정유진 on 6/4/24.
//

import UIKit

class ExerciseResultViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .customLightGray
        return view
    }()
    
    private let checkImage: UIImageView = {
        let imageView  = UIImageView()
        imageView.image = .check
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let completionLabel: UILabel = {
        let label = UILabel()
        label.text = "운동을 끝마쳤습니다!"
        label.font = Suite.semiBold.of(size: 20)
        label.textColor = .customBlack
        return label
    }()
    
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let circularProgressBar = CircularProgressBar().then {
        $0.backgroundColor = .clear
        $0.progressColor = .appGreen
        $0.trackColor = .appLightGray
    }
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        let fullText = "예상 소모 칼로리는\n0kcal 예요"
        let font = Suite.semiBold.of(size: 20)
        let changeText = "0kcal"
        let color = UIColor.appGreen
        label.setAttributedText(fullText: fullText, changeText: changeText, color: color, font: font)
        label.numberOfLines = 2
        label.textAlignment = .center
        // TODO: 텍스트 컬러 변경 customDarkGray

        return label
    }()
   
    private let resultView: UIView = {
        let view = UIView()
        view.backgroundColor = .customLightGray
        return view
    }()
    // TODO: resultView 컴포넌트 추가
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가하기", for: .normal)
        button.titleLabel?.font = Suite.bold.of(size: 20)
        button.tintColor = .white
        button.backgroundColor = .customBlack
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup View
    private func setupViews() {
        view.backgroundColor = .white
        circularProgressBar.progress = 0.6
        
        view.addSubviews(scrollView, addButton)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(cardView, progressView, resultView)
        cardView.addSubviews(checkImage, completionLabel)
        progressView.addSubviews(circularProgressBar, progressLabel)
    }
    
    private func setupConstraints() {
        // TODO: 스크롤뷰 레이아웃 조정
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        cardView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(64)
        }
        
        checkImage.snp.makeConstraints {
            $0.centerY.equalTo(cardView)
            $0.trailing.equalTo(completionLabel.snp.leading).inset(-16)
        }
        
        completionLabel.snp.makeConstraints {
            $0.centerY.equalTo(cardView)
            $0.centerX.equalTo(cardView)
        }
        
        progressView.snp.makeConstraints {
            $0.width.height.equalTo(300)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cardView.snp.bottom).offset(50)
        }
        
        circularProgressBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        progressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        resultView.snp.makeConstraints {
            $0.height.equalTo(300)
            $0.top.equalTo(progressView.snp.bottom).offset(30)
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(resultView.snp.bottom).offset(100)
        }
        
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).inset(26)
            $0.height.equalTo(60)
        }
    }
}
#Preview{
    ExerciseResultViewController()
}
